using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using DataAccess.Implementation;
using DataAccess.SMDB;
using Microsoft.AspNetCore.Mvc;
using MVCSite.Libs;
using Newtonsoft.Json;

namespace MVCSite.Controllers
{
    [Route("api")]
    [ApiController]
    public class ApiController : ControllerBase
    {
        private string ConnectionString { get; }
        public ApiController()
        {
            ConnectionString = Startup.ConnectionString;
        }
        [HttpGet("CollectHealthCheck")]
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
                tasks.Add(new HealthCheck().CallHealthCheckApi(item, journalGuid));

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

            if (errorCount > 0) await new HealthCheck().SendAlertEmail(journalGuid);
        }
        [HttpGet("GetServiceSummary")]
        public async Task<string> GetServiceSummary()
        {
            var data = await new ServicesImpl(ConnectionString).GetServiceSummary();
            var rData = JsonConvert.SerializeObject(data);
            return rData;
        }
        [HttpGet("GetServiceMonitorList")]
        public async Task<string> GetServiceMonitorList(int? id)
        {
            var groupId = id ?? 0;
            var data = await new ServicesImpl(ConnectionString)
                .ListByGroupId(groupId);
            return JsonConvert.SerializeObject(new { data = data.Where(x => x.Enable == 1) });
        }
    }

    [Route("api_user")]
    [ApiController]
    public class UserApiController : Controller
    {
        private string ConnectionString { get; }
        public UserApiController()
        {
            ConnectionString = Startup.ConnectionString;
        }
        [HttpGet("GetList")]
        public async Task<ActionResult> GetList()
        {
            return Json(new { data = await new UsersImpl(ConnectionString).List() });
        }
        [HttpPost("UpdateStatus")]
        public async Task<IActionResult> UpdateStatus(int id)
        {
            await new UsersImpl(ConnectionString).UpdateStatus(id);
            return Json(new { success = true, message = "update successful" });
        }
        [HttpDelete("Delete")]
        public async Task<IActionResult> Delete(int id)
        {
            var user = await new UsersImpl(ConnectionString).Get(id);
            if (user == null)
            {
                return Json(new { success = false, message = "Error while Deleting" });
            }
            await new UsersImpl(ConnectionString).Delete(id);
            return Json(new { success = true, message = "Delete successful" });
        }
    }

    [Route("api_group")]
    [ApiController]
    public class GroupApiController : Controller
    {
        private string ConnectionString { get; }
        public GroupApiController()
        {
            ConnectionString = Startup.ConnectionString;
        }
        [HttpGet("GetList")]
        public async Task<ActionResult> GetList()
        {
            return Json(new { data = await new GroupsImpl(ConnectionString).List() });
        }
        [HttpDelete("Delete")]
        public async Task<IActionResult> Delete(int id)
        {
            var group = await new GroupsImpl(ConnectionString).Get(id);
            if (group == null)
            {
                return Json(new { success = false, message = "Error while Deleting" });
            }
            await new GroupsImpl(ConnectionString).Delete(id);
            return Json(new { success = true, message = "Delete successful" });
        }
    }
    
    [Route("api_service")]
    [ApiController]
    public class ServiceApiController : Controller
    {
        private string ConnectionString { get; }
        public ServiceApiController()
        {
            ConnectionString = Startup.ConnectionString;
        }
        [HttpGet("GetList")]
        [HttpGet]
        public async Task<ActionResult> GetList(int? id)
        {
            var groupId = id ?? 0;
            return Json(new { data = await new ServicesImpl(ConnectionString).ListByGroupId(groupId) });
        }

        [HttpDelete("Delete")]
        public async Task<IActionResult> Delete(int id)
        {
            var service = await new ServicesImpl(ConnectionString).Get(id);
            if (service == null)
            {
                return Json(new { success = false, message = "Error while Deleting" });
            }

            await new ServicesImpl(ConnectionString).Delete(id);
            return Json(new { success = true, message = "Delete successful" });
        }
    }
}
