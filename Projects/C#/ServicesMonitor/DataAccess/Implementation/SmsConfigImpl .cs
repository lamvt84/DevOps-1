using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Security.Principal;
using System.Text;
using System.Threading.Tasks;
using CommonLibs;
using DataAccess.Interface;
using DataAccess.SMDB;
using Microsoft.Data.SqlClient;

namespace DataAccess.Implementation
{
    public class SmsConfigImpl: ISmsConfig
    {
        private readonly string _connString;

        public SmsConfigImpl(string connString)
        {
            _connString = connString;
        }

        public async Task<SmsConfig> Get(int id)
        {
            try
            {
                var spName = "dbo.usp_SmsConfig_Get";
                var parameterValues = new object[1] {id};
                var thisTask = Task.Run(() => SqlHelper.ExecuteDatasetAsync(_connString, spName, parameterValues));
                var result = await thisTask;

                return result.Tables[0].ToList<SmsConfig>().FirstOrDefault();
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        public async Task<List<SmsConfig>> List()
        {
            try
            {
                var spName = "dbo.usp_SmsConfig_List";
                var thisTask = Task.Run(() => SqlHelper.ExecuteDatasetAsync(_connString, spName, null));
                var result = await thisTask;

                return result.Tables[0].ToList<SmsConfig>();
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        public async Task<List<SmsConfig>> ListByAlertConfigId(int alertConfigId)
        {
            try
            {
                var spName = "dbo.usp_SmsConfig_ListByAlertConfigId";
                var parameterValues = new object[1] {alertConfigId};
                var thisTask = Task.Run(() => SqlHelper.ExecuteDatasetAsync(_connString, spName, parameterValues));
                var result = await thisTask;

                return result.Tables[0].ToList<SmsConfig>();
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        public async Task<int> Update(SmsConfig smsConfig)
        {
            try
            {
                var spName = "dbo.usp_SmsConfig_Update";
                var parameterValues = new object[7]
                {
                    smsConfig.Id,
                    smsConfig.AlertConfigId,
                    smsConfig.AccountName,
                    smsConfig.Mobile,
                    smsConfig.Message,
                    smsConfig.ServiceId,
                    smsConfig.DataSign
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
        
        public async Task<int> Add(SmsConfig smsConfig)
        {
            try
            {
                var spName = "dbo.usp_SmsConfig_Add";
                var parameterValues = new object[6]
                {
                    smsConfig.AlertConfigId,
                    smsConfig.AccountName,
                    smsConfig.Mobile,
                    smsConfig.Message,
                    smsConfig.ServiceId,
                    smsConfig.DataSign
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
                var spName = "dbo.usp_SmsConfig_UpdateStatus";

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
                var spName = "dbo.usp_SmsConfig_Delete";
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
