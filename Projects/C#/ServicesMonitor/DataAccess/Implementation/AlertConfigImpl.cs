using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using CommonLibs;
using DataAccess.Interface;
using DataAccess.SMDB;

namespace DataAccess.Implementation
{
    public class AlertConfigImpl: IAlertConfig
    {
        private readonly string _connString;

        public AlertConfigImpl(string connString)
        {
            _connString = connString;
        }

        public async Task<int> UpdateWarningStatus(AlertConfig alertConfig)
        {
            try
            {
                var spName = "dbo.usp_AlertConfig_UpdateWarningStatus";

                var parameterValues = new object[3]
                {
                    alertConfig.Id,
                    alertConfig.PauseStatus,
                    alertConfig.PausePeriod
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
        public async Task<AlertConfig> Get(int id)
        {
            try
            {
                var spName = "dbo.usp_AlertConfig_Get";
                var parameterValues = new object[1] {id};
                var thisTask = Task.Run(() => SqlHelper.ExecuteDatasetAsync(_connString, spName, parameterValues));
                var result = await thisTask;

                return result.Tables[0].ToList<AlertConfig>().FirstOrDefault();
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
    }
}
