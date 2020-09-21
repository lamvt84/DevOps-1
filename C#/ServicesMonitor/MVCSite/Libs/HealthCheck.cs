using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Http;
using System.Threading.Tasks;
using CommonLibs;
using DataAccess.Implementation;
using DataAccess.SMDB;
using Microsoft.Extensions.Options;
using Newtonsoft.Json;

namespace MVCSite.Libs
{
    public partial class HealthCheck
    {
        private string ConnectionString { get; }
        private ExtendSettings Settings { get; }
        public HealthCheck(IOptions<ExtendSettings> settings = null)
        {
            if (settings != null) Settings = settings.Value;
            ConnectionString = Startup.ConnectionString;
        }
        public async Task SendAlertEmail(Guid jGuid)
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
                    CCMail = Settings.CcEmailList,
                    Subject = Settings.EmailSubject,
                    Message = Settings.EmailBody.Replace("{check_id}", jGuid.ToString())
                        .Replace("{service_list}", serviceErrorList),
                    IsResend = false,
                    ServiceID = 0,
                    smsEMailID = 0,
                    langID = 0,
                    DataSign = Encryption.Md5Hash($"{Settings.ToEmailList}-{Settings.CcEmailList}-{Settings.SecureKey}").ToLower()
                };

                using var stringContent = new StringContent(JsonConvert.SerializeObject(emailSettings), System.Text.Encoding.UTF8, "application/json");
                var response = await client.PostAsync(new Uri(Settings.SendEmailUrl), stringContent);
                await response.Content.ReadAsStringAsync();
            }
            catch (Exception)
            {
                throw;
            }
        }

        public async Task<int> CallHealthCheckApi(Services service, Guid jGuid)
        {
            int returnCode;
            using var client = new HttpClient();
            try
            {
                client.BaseAddress = new Uri(service.Url);
                var response = await client.GetAsync(new Uri(service.Url));
                response.EnsureSuccessStatusCode();

                await response.Content.ReadAsStringAsync();
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
    }
}
