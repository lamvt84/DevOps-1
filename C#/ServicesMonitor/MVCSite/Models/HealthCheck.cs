using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Http;
using System.Runtime.InteropServices.ComTypes;
using System.Threading.Tasks;
using CommonLibs;
using DataAccess.Implementation;
using DataAccess.SMDB;
using Microsoft.Extensions.Options;
using Newtonsoft.Json;

namespace MVCSite.Models
{
    public partial class HealthCheck
    {
        private string ConnectionString { get; }
        private ExtendSettings ExtendSettings { get; set; }
        public HealthCheck(IOptionsSnapshot<ExtendSettings> settings = null)
        {
            if (settings != null) ExtendSettings = settings.Value;
            ConnectionString = Startup.ConnectionString;
        }

        public async Task SendAlert(Guid jGuid, ExtendSettings extendSettings)
        {
            ExtendSettings ??= extendSettings;

            try
            {
                var alertConfig = await new AlertConfigImpl(ConnectionString).Get(1);
                if (alertConfig.PauseStatus == 1) return;

                var serviceList = await new ServicesImpl(ConnectionString).ListByStatus(0);
                var serviceErrorList = "";

                var tasks = new List<Task>();

                foreach (var item in serviceList)
                {
                    serviceErrorList += $"- {item.Name}: {item.Url}<br />";
                }

                tasks.Add(SendAlertEmail(jGuid, serviceErrorList));
                tasks.Add(SendAlertSms());

                await Task.WhenAll(tasks);
            }
            catch (Exception)
            {
                throw;
            }

        }

        private async Task SendAlertEmail(Guid jGuid, string serviceErrorList)
        {
            using var client = new HttpClient();
            try
            {
                var emailConfig = await new EmailConfigImpl(ConnectionString).ListByAlertConfigId(1);
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
                    var response = await client.PostAsync(new Uri(ExtendSettings.SendMailUrl), stringContent);
                    var responseMessage = await response.Content.ReadAsStringAsync();

                    var alertLog = new AlertLog()
                    {
                        AlertType = "EMAIL",
                        AlertUrl = ExtendSettings.SendMailUrl,
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

        private async Task SendAlertSms()
        {
            using var client = new HttpClient();
            try
            {
                var smsConfig = await new SmsConfigImpl(ConnectionString).ListByAlertConfigId(1);
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
                    var response = await client.PostAsync(new Uri(ExtendSettings.SendSmsUrl), stringContent);
                    var responseMessage = await response.Content.ReadAsStringAsync();
                    
                    var alertLog = new AlertLog()
                    {
                        AlertType = "SMS",
                        AlertUrl = ExtendSettings.SendSmsUrl,
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
