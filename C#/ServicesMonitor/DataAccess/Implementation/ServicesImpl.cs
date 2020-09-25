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
    public class ServicesImpl : IServices
    {
        private readonly string _connString;

        public ServicesImpl(string connString)
        {
            _connString = connString;
        }

        public async Task<int> UpdateStatus(Services service)
        {
            try
            {
                var spName = "dbo.usp_Services_UpdateStatus";

                var parameterValues = new object[2]
                {
                    service.Id,
                    service.Status
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

        public async Task<int> Add(Services service)
        {
            try
            {
                var spName = "dbo.usp_Services_Add";

                var parameterValues = new object[8]
                {
                    service.GroupId,
                    service.Name,
                    service.Description,
                    service.Url,
                    service.Params,
                    service.ResponseCode,
                    service.Enable,
                    service.Status
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
        public async Task<int> Update(Services service)
        {
            try
            {
                var spName = "dbo.usp_Services_Update";

                var parameterValues = new object[9]
                {
                    service.Id,
                    service.GroupId,
                    service.Name,
                    service.Description,
                    service.Url,
                    service.Params,
                    service.ResponseCode,
                    service.Enable,
                    service.Status
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
        public async Task<List<Services>> ListByStatus(int status)
        {
            try
            {
                var spName = "dbo.usp_Services_ListByStatus";
                var parameterValues = new object[1] {status};
                var thisTask = Task.Run(() => SqlHelper.ExecuteDatasetAsync(_connString, spName, parameterValues));
                var result = await thisTask;
                
                return result.Tables[0].ToList<Services>();
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        public async Task<List<Services>> ListByGroupId(int groupId)
        {
            try
            {
                var spName = "dbo.usp_Services_ListByGroupId";
                var parameterValues = new object[1] {groupId};
                var thisTask = Task.Run(() => SqlHelper.ExecuteDatasetAsync(_connString, spName, parameterValues));
                var result = await thisTask;
                
                return result.Tables[0].ToList<Services>();
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        public async Task<DataTable> GetServiceSummary()
        {
            try
            {
                var spName = "dbo.usp_Services_GetServiceSummary";
                var thisTask = Task.Run(() => SqlHelper.ExecuteDatasetAsync(_connString, spName, null));
                var result = await thisTask;
                
                return result.Tables[0];
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        
        public async Task<List<Services>> ListByEnable(int enable)
        {
            try
            {
                var spName = "dbo.usp_Services_ListByEnable";
                var parameterValues = new object[1] {enable};
                var thisTask = Task.Run(() => SqlHelper.ExecuteDatasetAsync(_connString, spName, parameterValues));
                var result = await thisTask;
                
                return result.Tables[0].ToList<Services>();
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        public async Task<Services> Get(int id)
        {
            try
            {
                var spName = "dbo.usp_Services_Get";
                var parameterValues = new object[1] {id};
                var thisTask = Task.Run(() => SqlHelper.ExecuteDatasetAsync(_connString, spName, parameterValues));
                var result = await thisTask;

                return result.Tables[0].ToList<Services>().FirstOrDefault();
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
                var spName = "dbo.usp_Services_Delete";
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
