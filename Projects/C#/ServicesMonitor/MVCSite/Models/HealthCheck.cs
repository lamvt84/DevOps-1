using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Http;
using System.Runtime.InteropServices.ComTypes;
using System.Threading.Tasks;
using CommonLibs;
using DataAccess.Implementation;
using DataAccess.SMDB;
using Microsoft.ApplicationInsights.Extensibility;
using Microsoft.Extensions.Options;
using Newtonsoft.Json;

namespace MVCSite.Models
{
    public partial class HealthCheck
    {
        private string ConnectionString { get; }
        public HealthCheck()
        {
            ConnectionString = Startup.ConnectionString;
        }

        public async Task SendStatusChangedAlert(Guid jGuid, string listId, ExtendSettings extendSettings)
        {
            var alertConfigId = 2;
            try
            {
                var alertConfig = await new AlertConfigImpl(ConnectionString).Get(1);
                if (alertConfig.PauseStatus == 0 && alertConfig.PausePeriod > (int)AlertRule.Level3) 
                    await new AlertConfigImpl(ConnectionString).UpdateWarningStatus(new AlertConfig()
                    {
                        Id = alertConfig.Id,
                        PauseStatus = 0,
                        PausePeriod = (int)AlertRule.Level1
                    });
                var serviceList = await new ServicesImpl(ConnectionString).ListByGroupId(0);
                var serviceChangedList = "";

                List<string> listIdString = listId.Split(',').ToList();
                foreach (var item in serviceList.Where(x => listIdString.Exists(e => e == x.Id.ToString())))
                {
                    serviceChangedList += $"- {item.Name}: {item.Url}<br />";
                }

                var tasks = new List<Task>
                {
                    SendAlertEmail(jGuid, alertConfigId, serviceChangedList, extendSettings),
                    SendAlertSms(alertConfigId, extendSettings)
                };

                await Task.WhenAll(tasks);
            }
            catch (Exception)
            {
                throw;
            }
        }

        public async Task SendAlert(Guid jGuid, ExtendSettings extendSettings)
        {
            var alertConfigId = 1;
            try
            {
                var alertConfig = await new AlertConfigImpl(ConnectionString).Get(alertConfigId);
                if (alertConfig.PauseStatus == 1) return;
                if (alertConfig.PausePeriod == (int)AlertRule.Level5) return;

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

                    var serviceList = await new ServicesImpl(ConnectionString).ListByStatus(0);
                    var serviceErrorList = "";

                    foreach (var item in serviceList.Where(x => x.Enable == 1))
                    {
                        serviceErrorList += $"- {item.Name}: {item.Url}<br />";
                    }
                    var tasks = new List<Task>
                    {
                        SendAlertEmail(jGuid, alertConfigId, serviceErrorList, extendSettings),
                        SendAlertSms(alertConfigId, extendSettings)
                    };

                    await Task.WhenAll(tasks);
                }
            }
            catch (Exception)
            {
                throw;
            }
        }

        private async Task SendAlertEmail(Guid jGuid, int alertConfigId, string serviceErrorList, ExtendSettings extendSettings)
        {
            using var client = new HttpClient();
            try
            {
                var emailConfig = await new EmailConfigImpl(ConnectionString).ListByAlertConfigId(alertConfigId);
                foreach (var item in emailConfig.Where(x => x.IsEnable))
                {
                    var emailSetting = new MailRequest()
                    {
                        SenderName = item.SenderName,
                        ToMail = item.ToMail,
                        CCMail = item.CCMail,
                        Subject = item.Subject,
                        Message = item.Message.Replace("{check_id}", jGuid.ToString())
                            .Replace("{service_list}", serviceErrorList),
                        IsResend = item.IsResend,
                        ServiceID = item.ServiceId,
                        smsEMailID = item.SmsEmailId,
                        langID = item.LangId,
                        DataSign = item.DataSign
                    };

                    using var stringContent = new StringContent(JsonConvert.SerializeObject(emailSetting), System.Text.Encoding.UTF8, "application/json");
                    //var response = await client.PostAsync(new Uri(ExtendSettings.SendMailUrl), stringContent);
                    var response = await client.PostAsync(new Uri(extendSettings.SendMailUrl), stringContent);
                    var responseMessage = await response.Content.ReadAsStringAsync();

                    var alertLog = new AlertLog()
                    {
                        AlertType = "EMAIL",
                        AlertUrl = extendSettings.SendMailUrl,
                        RequestMessage = JsonConvert.SerializeObject(emailSetting),
                        ResponseMessage = responseMessage
                    };
                    await new AlertLogImpl(ConnectionString).Add(alertLog);
                }
            }
            catch (Exception)
            {
                throw;
            }
        }

        private async Task SendAlertSms(int alertConfigId, ExtendSettings extendSettings)
        {
            using var client = new HttpClient();
            try
            {
                var smsConfig = await new SmsConfigImpl(ConnectionString).ListByAlertConfigId(alertConfigId);
                foreach (var item in smsConfig.Where(x => x.IsEnable))
                {
                    var smsSetting = new SmsRequest()
                    {
                        AccountName = item.AccountName,
                        Mobile = item.Mobile,
                        Message = item.Message,
                        IsResend = item.IsResend,
                        ServiceID = item.ServiceId,
                        smsEMailID = item.SmsEmailId,
                        langID = item.LangId,
                        DataSign = item.DataSign
                    };

                    using var stringContent = new StringContent(JsonConvert.SerializeObject(smsSetting), System.Text.Encoding.UTF8, "application/json");
                    var response = await client.PostAsync(new Uri(extendSettings.SendSmsUrl), stringContent);
                    var responseMessage = await response.Content.ReadAsStringAsync();
                    
                    var alertLog = new AlertLog()
                    {
                        AlertType = "SMS",
                        AlertUrl = extendSettings.SendSmsUrl,
                        RequestMessage = JsonConvert.SerializeObject(smsSetting),
                        ResponseMessage = responseMessage
                    };
                    await new AlertLogImpl(ConnectionString).Add(alertLog);
                }
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
