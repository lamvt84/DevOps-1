using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using CommonLibs;
using DataAccess.Interface;
using DataAccess.SMDB;
using Microsoft.Data.SqlClient;

namespace DataAccess.Implementation
{
    public class EmailConfigImpl: IEmailConfig
    {
        private readonly string _connString;

        public EmailConfigImpl(string connString)
        {
            _connString = connString;
        }

        public async Task<EmailConfig> Get(int id)
        {
            try
            {
                var spName = "dbo.usp_EmailConfig_Get";
                var parameterValues = new object[1] {id};
                var thisTask = Task.Run(() => SqlHelper.ExecuteDatasetAsync(_connString, spName, parameterValues));
                var result = await thisTask;

                return result.Tables[0].ToList<EmailConfig>().FirstOrDefault();
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        public async Task<List<EmailConfig>> List()
        {
            try
            {
                var spName = "dbo.usp_EmailConfig_List";
                var thisTask = Task.Run(() => SqlHelper.ExecuteDatasetAsync(_connString, spName, null));
                var result = await thisTask;

                return result.Tables[0].ToList<EmailConfig>();
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        public async Task<List<EmailConfig>> ListByAlertConfigId(int alertConfigId)
        {
            try
            {
                var spName = "dbo.usp_EmailConfig_ListByAlertConfigId";
                var parameterValues = new object[1] { alertConfigId };
                var thisTask = Task.Run(() => SqlHelper.ExecuteDatasetAsync(_connString, spName, parameterValues));
                var result = await thisTask;

                return result.Tables[0].ToList<EmailConfig>();
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        public async Task<int> Update(EmailConfig emailConfig)
        {
            try
            {
                var spName = "dbo.usp_EmailConfig_Update";
                var parameterValues = new object[8]
                {
                    emailConfig.Id,
                    emailConfig.SenderName,
                    emailConfig.ToMail,
                    emailConfig.CCMail,
                    emailConfig.Subject,
                    emailConfig.Message,
                    emailConfig.ServiceId,
                    emailConfig.DataSign
            };
                
                var thisTask = Task.Run(() => SqlHelper.ExecuteNonQueryAsync(_connString, spName, parameterValues));
                var result = await thisTask;
                return result;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        public async Task<int> UpdateStatus(int id)
        {
            try
            {
                var spName = "dbo.usp_EmailConfig_UpdateStatus";

                var outputParameter = new SqlParameter("@ResponseCode", SqlDbType.Int)
                {
                    Direction = ParameterDirection.Output
                };

                var parameterValues = new object[2]
                {
                    id,
                    outputParameter
                };
               
                var thisTask = Task.Run(() => SqlHelper.ExecuteNonQueryAsync(_connString, spName, parameterValues));
                var result = await thisTask;
                return (int)outputParameter.Value;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public async Task<int> Delete(int id)
        {
            try
            {
                var spName = "dbo.usp_EmailConfig_Delete";
                var parameterValues = new object[1] {id};
                var thisTask = Task.Run(() => SqlHelper.ExecuteNonQueryAsync(_connString, spName, parameterValues));
                var result = await thisTask;
                return result;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
    }
}
