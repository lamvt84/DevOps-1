using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using DataAccess.Implementation;
using DataAccess.SMDB;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Options;
using MVCSite.Models;
using Newtonsoft.Json;

namespace MVCSite.Controllers
{
    [Route("api")]
    [ApiController]
    public class ApiController : ControllerBase
    {
        private string ConnectionString { get; }
        private ExtendSettings ExtendSettings { get; }
        public ApiController(IOptionsSnapshot<ExtendSettings> settings = null)
        {
            if (settings != null) ExtendSettings = settings.Value;
            ConnectionString = Startup.ConnectionString;
        }

        [HttpPost("SendAlert")]
        public async Task<string> SendAlert(string jGuid)
        {
            await new HealthCheck().SendAlert(Guid.Parse(jGuid), ExtendSettings);
            return JsonConvert.SerializeObject(new { status = "OK" });
        }

        [HttpPost("UpdateHealthCheckSpecialCase")]
        public async Task<string> UpdateHealthCheckSpecialCase(int serviceId, string status, string jGuid, string url)
        {
            var journalGuid = Guid.Parse(jGuid);
            await new ServicesLogImpl(ConnectionString).Add(new ServicesLog()
            {
                JournalGuid = journalGuid,
                ServiceId = serviceId,
                ServiceUrl = (serviceId == 0? "" : url),
                ServiceStatus = status
            });

            if (serviceId > 0)
            {
                await new ServicesImpl(ConnectionString).UpdateStatus(new Services()
                {
                    Id = serviceId,
                    Status = (status == "OK") ? 1 : 0
                });
            }

            return JsonConvert.SerializeObject(new { status = "OK" });
        }

        [HttpGet("GetServiceSummary")]
        public async Task<string> GetServiceSummary()
        {
            var data = await new ServicesImpl(ConnectionString).GetServiceSummary();
            var rData = JsonConvert.SerializeObject(data);
            return rData;
        }
        [HttpGet("health_check")]
        public string health_check()
        {
            return JsonConvert.SerializeObject(new { status = "OK"});
        }
        [HttpPost("Test")]
        public async Task<string> Test()
        {
            var alertConfig = await new AlertConfigImpl(ConnectionString).Get(1);
            if (alertConfig.PauseStatus == 1) return JsonConvert.SerializeObject(new { pause_status = alertConfig.PauseStatus }); ;
            if (alertConfig.PausePeriod == (int)AlertRule.Level5) return JsonConvert.SerializeObject(new { pause_period = alertConfig.PausePeriod }); ;

            var currentTime = DateTimeOffset.Now;

            if (currentTime.Subtract(alertConfig.UpdatedTime).TotalSeconds >= alertConfig.PausePeriod)
            {
                var nextLevel = alertConfig.PausePeriod switch
                {
                    0 => (int)AlertRule.Level2,
                    300 => (int)AlertRule.Level3,
                    900 => (int)AlertRule.Level4,
                    3600 => (int)AlertRule.Level5,
                    _ => throw new NotImplementedException()
                };

                await new AlertConfigImpl(ConnectionString).UpdateWarningStatus(new AlertConfig()
                {
                    Id = alertConfig.Id,
                    PauseStatus = 0,
                    PausePeriod = nextLevel
                });
                return JsonConvert.SerializeObject(new
                {
                    Id = alertConfig.Id,
                    PauseStatus = 0,
                    PausePeriod = nextLevel
                });
            }
            return JsonConvert.SerializeObject(new { time_span = currentTime.Subtract(alertConfig.UpdatedTime).TotalSeconds }); ;
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
        [HttpPost("Delete")]
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
        [HttpGet("Get")]
        public async Task<ActionResult> Get(int? id)
        {
            return Json(new { data = await new GroupsImpl(ConnectionString).Get(id ?? 0) });
        }
        [HttpGet("GetList")]
        public async Task<ActionResult> GetList()
        {
            return Json(new { data = await new GroupsImpl(ConnectionString).List() });
        }
        [HttpPost("Delete")]
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
        [HttpGet("Get")]
        public async Task<ActionResult> Get(int? id)
        {
            return Json(new { data = await new ServicesImpl(ConnectionString).Get(id ?? 0) });
        }
        [HttpGet("GetList")]
        public async Task<ActionResult> GetList(int? id)
        {
            var groupId = id ?? 0;
            return Json(new { data = await new ServicesImpl(ConnectionString).ListByGroupId(groupId) });
        }

        [HttpPost("Delete")]
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

        [HttpGet("GetServiceListByStatus")]
        public async Task<string> GetServiceListByStatus(int? status)
        {
            var mStatus = status ?? 0;
            var data = await new ServicesImpl(ConnectionString)
                .ListByStatus(mStatus);
            return JsonConvert.SerializeObject(new { data = data.Where(x => x.Enable == 1) });
        }
        [HttpGet("GetServiceListByGroup")]
        public async Task<string> GetServiceListByGroup(int? id)
        {
            var groupId = id ?? 0;
            var data = await new ServicesImpl(ConnectionString)
                .ListByGroupId(groupId);
            return JsonConvert.SerializeObject(new { data = data.Where(x => x.Enable == 1) });
        }
    }

    [Route("api_alert")]
    [ApiController]
    public class AlertApiController : Controller
    {
        private string ConnectionString { get; }
        public AlertApiController()
        {
            ConnectionString = Startup.ConnectionString;
        }

        [HttpGet("GetEmailConfigList")]
        public async Task<ActionResult> GetEmailConfigList(int? id)
        {
            return Json(new { data = await new EmailConfigImpl(ConnectionString).ListByAlertConfigId(id ?? 1) });
        }

        [HttpGet("GetSmsConfigList")]
        public async Task<ActionResult> GetSmsConfigList(int? id)
        {
            return Json(new { data = await new SmsConfigImpl(ConnectionString).ListByAlertConfigId(id ?? 1) });
        }

        [HttpPost("DeleteSmsConfig")]
        public async Task<IActionResult> DeleteSmsConfig(int id)
        {
            var smsConfig = await new SmsConfigImpl(ConnectionString).Get(id);
            if (smsConfig == null)
            {
                return Json(new { success = false, message = "Error while Deleting" });
            }
            await new SmsConfigImpl(ConnectionString).Delete(id);
            return Json(new { success = true, message = "Delete successful" });
        }

        [HttpPost("DeleteEmailConfig")]
        public async Task<IActionResult> DeleteEmailConfig(int id)
        {
            var smsConfig = await new EmailConfigImpl(ConnectionString).Get(id);
            if (smsConfig == null)
            {
                return Json(new { success = false, message = "Error while Deleting" });
            }
            await new EmailConfigImpl(ConnectionString).Delete(id);
            return Json(new { success = true, message = "Delete successful" });
        }

        [HttpPost("UpdateSmsConfigStatus")]
        public async Task<IActionResult> UpdateSmsConfigStatus(int id)
        {
            var smsConfig = await new SmsConfigImpl(ConnectionString).Get(id);
            if (smsConfig == null)
            {
                return Json(new { success = false, message = "Error while updating", output_value = "" });
            }
            var result = await new SmsConfigImpl(ConnectionString).UpdateStatus(id);
            return Json(new { success = true, message = "Update successful", output_value = result.ToString() });
        }

        [HttpPost("UpdateEmailConfigStatus")]
        public async Task<IActionResult> UpdateEmailConfigStatus(int id)
        {
            var emailConfig = await new EmailConfigImpl(ConnectionString).Get(id);
            if (emailConfig == null)
            {
                return Json(new { success = false, message = "Error while updating", output_value = "" });
            }
            var result = await new EmailConfigImpl(ConnectionString).UpdateStatus(id);
            return Json(new { success = true, message = "Update successful", output_value = result.ToString() });
        }

        [HttpGet("Get")]
        public async Task<ActionResult> GetStatus(int? id)
        {
            var result = await new AlertConfigImpl(ConnectionString).Get(id ?? 0);
            return Json(new { pause_status = (result.PauseStatus == 0) ? "ON" : "OFF" });
        }

        [HttpPost("UpdateWarningStatus")]
        public async Task<IActionResult> UpdateWarningStatus(int id, int pause)
        {
            AlertConfig alertConfig = new AlertConfig()
            {
                Id = id,
                PauseStatus = pause,
                PausePeriod = 0
            };
            var result = await new AlertConfigImpl(ConnectionString).UpdateWarningStatus(alertConfig);
            return Json(new { success = true, message = "Action successful", pause_status = pause });
        }
    }
}
