using System;
using System.Collections.Generic;
using System.Text;
using System.Threading.Tasks;
using CommonLibs;
using DataAccess.Interface;
using DataAccess.SMDB;

namespace DataAccess.Implementation
{
    public class TaskSchedulerLogImpl: ITaskSchedulerLog
    {
        private readonly string _connString;

        public TaskSchedulerLogImpl(string connString)
        {
            _connString = connString;
        }

        public async Task<int> Add(TaskSchedulerLog taskSchedulerLog)
        {
            try
            {
                var spName = "dbo.usp_TaskSchedulerLog_Add";
                var parameterValues = new object[3]
                {
                    taskSchedulerLog.Source,
                    taskSchedulerLog.Name,
                    taskSchedulerLog.Duration
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
