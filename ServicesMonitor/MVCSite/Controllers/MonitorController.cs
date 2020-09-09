using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Http;
using System.Text;
using System.Threading.Tasks;
using CommonLibs;
using DataAccess.Implementation;
using DataAccess.SMDB;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Options;
using MVCSite.Libs;
using Newtonsoft.Json;

namespace MVCSite.Controllers
{
    public class MonitorController : Controller
    {
        private string ConnectionString { get; }
        private ExtendSettings Settings { get; }
        public MonitorController(IOptions<ExtendSettings> settings = null, IConfiguration configuration = null)
        {
            if (settings != null) Settings = settings.Value;
            ConnectionString = Startup.ConnectionString;
        }
        public IActionResult Index()
        {
            Task.Run(async () => await CollectHealthCheck());
            return View();
        }

        private async Task SendAlertEmail(System.Guid jGuid)
        {
            var serviceList = await new ServicesImpl(ConnectionString).ListByStatus(0);
            var serviceErrorList = "";
            foreach (var item in serviceList)
            {
                serviceErrorList += $"- {item.Name}<br />";
            }
            
            using var client = new HttpClient();
            try
            {
                var emailSettings = new MailRequest()
                {
                    SenderName = "",
                    ToMail = Settings.ToEmailList,
                    CCMail = "",
                    Subject = Settings.EmailSubject,
                    Message = Settings.EmailBody.Replace("{check_id}", jGuid.ToString())
                        .Replace("{service_list}", serviceErrorList),
                    IsResend = false,
                    ServiceID = 0,
                    smsEMailID = 0,
                    langID = 0,
                    DataSign = Encryption.Md5Hash($"{Settings.ToEmailList}--{Settings.SecureKey}").ToLower()
                };

                using var stringContent = new StringContent(JsonConvert.SerializeObject(emailSettings), System.Text.Encoding.UTF8, "application/json");
                var response = await client.PostAsync(new Uri(Settings.SendEmailUrl), stringContent);
                var result = await response.Content.ReadAsStringAsync();
            }
            catch (Exception ex)
            {
                throw;
            }
        }

        private async Task<int> CallHealthCheckApi(Services service, System.Guid jGuid)
        {
            var returnCode = 0;
            using var client = new HttpClient();
            try
            {
                client.BaseAddress = new Uri(service.Url);
                var response = await client.GetAsync(new Uri(service.Url));
                response.EnsureSuccessStatusCode();

                var stringResult = await response.Content.ReadAsStringAsync();
                await new ServicesLogImpl(ConnectionString).Add(new ServicesLog()
                {
                    JournalGuid = jGuid,
                    ServiceId = service.Id,
                    ServiceUrl = service.Url,
                    ServiceStatus = response.StatusCode.ToString()
                });
                await new ServicesImpl(ConnectionString).UpdateStatus(new Services()
                {
                    Id = service.Id,
                    Status = (response.StatusCode.ToString() == "OK") ? 1 : 0
                });
                returnCode = (response.StatusCode.ToString() == "OK") ? 1 : 0;
            }
            catch (HttpRequestException)
            {
                await new ServicesLogImpl(ConnectionString).Add(new ServicesLog()
                {
                    JournalGuid = jGuid,
                    ServiceId = service.Id,
                    ServiceUrl = service.Url,
                    ServiceStatus = "ERROR"
                });
                await new ServicesImpl(ConnectionString).UpdateStatus(new Services()
                {
                    Id = service.Id,
                    Status = 0
                });
                returnCode = 0;
            }

            return returnCode;
        }

        #region API Calls

        [HttpGet]
        public async Task CollectHealthCheck()
        {
            var errorCount = 0;
            var serviceList = await new ServicesImpl(ConnectionString).ListByEnable(1);
            var journalGuid = Guid.NewGuid();
            var tasks = new List<Task<int>>();

            await new ServicesLogImpl(ConnectionString).Add(new ServicesLog()
            {
                JournalGuid = journalGuid,
                ServiceId = 0,
                ServiceUrl = "",
                ServiceStatus = "START"
            });

            foreach (var item in serviceList)
            {
                tasks.Add(CallHealthCheckApi(item, journalGuid));
               
                if (tasks.Count == 20)
                {
                    int[] resultsAll = await Task.WhenAll(tasks);
                    foreach (var r in resultsAll)
                    {
                        if (r == 0) errorCount += 1;
                    }
                    tasks.Clear();
                }
            }

            if (tasks.Any())
            {
                int[] resultsAll = await Task.WhenAll(tasks);
                foreach (var r in resultsAll)
                {
                    if (r == 0) errorCount += 1;
                }
                tasks.Clear();
            }

            await new ServicesLogImpl(ConnectionString).Add(new ServicesLog()
            {
                JournalGuid = journalGuid,
                ServiceId = 0,
                ServiceUrl = "",
                ServiceStatus = "END"
            });

            if (errorCount > 0) await SendAlertEmail(journalGuid);
        }

        [HttpGet]
        public async Task<string> GetServiceSummary()
        {
            var data = await new ServicesImpl(ConnectionString).GetServiceSummary();
            var rData = JsonConvert.SerializeObject(data);
            return rData;
        }
        [HttpGet]
        public async Task<ActionResult> GetServiceMonitorList(int? id)
        {
            var groupId = id ?? 0;
            var data = await new ServicesImpl(ConnectionString)
                .ListByGroupId(groupId);
            return Json(new { data = data.Where(x => x.Enable == 1) });
        }

        #endregion
    }
}
