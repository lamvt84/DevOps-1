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

                var parameterValues = new object[2];
                parameterValues[0] = service.Id;
                parameterValues[1] = service.Status;
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

                var parameterValues = new object[8];
                parameterValues[0] = service.GroupId;
                parameterValues[1] = service.Name;
                parameterValues[2] = service.Description;
                parameterValues[3] = service.Url;
                parameterValues[4] = service.Params;
                parameterValues[5] = service.ResponseCode;
                parameterValues[6] = service.Enable;
                parameterValues[7] = service.Status;
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

                var parameterValues = new object[9];
                parameterValues[0] = service.Id;
                parameterValues[1] = service.GroupId;
                parameterValues[2] = service.Name;
                parameterValues[3] = service.Description;
                parameterValues[4] = service.Url;
                parameterValues[5] = service.Params;
                parameterValues[6] = service.ResponseCode;
                parameterValues[7] = service.Enable;
                parameterValues[8] = service.Status;
                var thisTask = Task.Run(() => SqlHelper.ExecuteNonQueryAsync(_connString, spName, parameterValues));
                var result = await thisTask;
                return result;
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
                var parameterValues = new object[1];
                parameterValues[0] = groupId;
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
                var parameterValues = new object[1];
                parameterValues[0] = enable;
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
                var parameterValues = new object[1];
                parameterValues[0] = id;
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
                var parameterValues = new object[1];
                parameterValues[0] = id;
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
