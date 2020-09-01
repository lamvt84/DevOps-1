using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Http;
using System.Text;
using System.Threading.Tasks;
using DataAccess.Implementation;
using DataAccess.SMDB;
using Microsoft.AspNetCore.Mvc;
using Newtonsoft.Json;

namespace MVCSite.Controllers
{
    public class MonitorController : Controller
    {
        public IActionResult Index()
        {
            Task.Run(async () => await CollectHealthCheck());
            return View();
        }

        private async Task<int> CallHealthCheckApi(Services service, System.Guid jGuid)
        {
            using var client = new HttpClient();
            try
            {
                client.BaseAddress = new Uri(service.Url);
                var response = await client.GetAsync(new Uri(service.Url));
                response.EnsureSuccessStatusCode();

                var stringResult = await response.Content.ReadAsStringAsync();
                await new ServicesLogImpl(Startup.ConnectionString).Add(new ServicesLog()
                {
                    JournalGuid = jGuid,
                    ServiceId = service.Id,
                    ServiceUrl = service.Url,
                    ServiceStatus = response.StatusCode.ToString()
                });
                await new ServicesImpl(Startup.ConnectionString).UpdateStatus(new Services()
                {
                    Id = service.Id,
                    Status = (response.StatusCode.ToString() == "OK") ? 1 : 0
                });
            }
            catch (HttpRequestException)
            {
                await new ServicesLogImpl(Startup.ConnectionString).Add(new ServicesLog()
                {
                    JournalGuid = jGuid,
                    ServiceId = service.Id,
                    ServiceUrl = service.Url,
                    ServiceStatus = "ERROR"
                });
                await new ServicesImpl(Startup.ConnectionString).UpdateStatus(new Services()
                {
                    Id = service.Id,
                    Status = 0
                });
            }

            return 1;
        }

        #region API Calls

        [HttpGet]
        public async Task<int> CollectHealthCheck()
        {
            var serviceList =
                await new ServicesImpl(Startup.ConnectionString).ListByEnable(1);
            var journalGuid = Guid.NewGuid();
            var tasks = new List<Task>();
            //var counter = 0; // not sure what this is for

            await new ServicesLogImpl(Startup.ConnectionString).Add(new ServicesLog()
            {
                JournalGuid = journalGuid,
                ServiceId = 0,
                ServiceUrl = "",
                ServiceStatus = "START"
            });

            foreach (var item in serviceList)
            {
                tasks.Add(CallHealthCheckApi(item, journalGuid)); // do not create a wrapping task
                //counter++; // not sure about this either

                // it won't ever be greater than 20
                if (tasks.Count == 20)
                {
                    await Task.WhenAll(tasks);
                    tasks.Clear();
                }
            }

            if (tasks.Any())
            {
                await Task.WhenAll(tasks);
                tasks.Clear();
            }

            await new ServicesLogImpl(Startup.ConnectionString).Add(new ServicesLog()
            {
                JournalGuid = journalGuid,
                ServiceId = 0,
                ServiceUrl = "",
                ServiceStatus = "END"
            });

            return 1;
        }

        [HttpGet]
        public async Task<string> GetServiceSummary()
        {
            var data = await new ServicesImpl(Startup.ConnectionString).GetServiceSummary();
            var rData = JsonConvert.SerializeObject(data);
            return rData;
        }
        [HttpGet]
        public async Task<ActionResult> GetServiceMonitorList(int? id)
        {
            var groupId = id ?? 0;
            var data = await new ServicesImpl(Startup.ConnectionString)
                .ListByGroupId(groupId);
            return Json(new { data = data.Where(x => x.Enable == 1) });
        }

        #endregion
    }
}
