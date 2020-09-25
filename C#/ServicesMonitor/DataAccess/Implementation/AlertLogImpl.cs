using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Runtime.InteropServices.ComTypes;
using System.Threading.Tasks;
using DataAccess.Interface;
using DataAccess.SMDB;
using CommonLibs;
using Microsoft.IdentityModel.Protocols;
using Microsoft.Data.SqlClient;

namespace DataAccess.Implementation
{
    public class AlertLogImpl : IAlertLog
    {
        private readonly string _connString;

        public AlertLogImpl(string connString)
        {
            _connString = connString;
        }

        public async Task<int> Add(AlertLog alertLog)
        {
            try
            {
                var spName = "dbo.usp_AlertLog_Add";

                var parameterValues = new object[4]
                {
                    alertLog.AlertType,
                    alertLog.AlertUrl,
                    alertLog.RequestMessage,
                    alertLog.ResponseMessage
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
    }
}
