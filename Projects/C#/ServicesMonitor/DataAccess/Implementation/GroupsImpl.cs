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
    public class GroupsImpl : IGroups
    {
        private readonly string _connString;

        public GroupsImpl(string connString)
        {
            _connString = connString;
        }

        public async Task<int> Add(Groups group)
        {
            try
            {
                var spName = "dbo.usp_Groups_Add";

                var parameterValues = new object[3]
                {
                    group.Tag,
                    group.Name,
                    group.Description
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
        public async Task<int> Update(Groups group)
        {
            try
            {
                var spName = "dbo.usp_Groups_Update";

                var parameterValues = new object[4]
                {
                    group.Id, 
                    group.Tag, 
                    group.Name, 
                    group.Description
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

        public async Task<List<Groups>> List()
        {
            try
            {
                var spName = "dbo.usp_Groups_List";
                var thisTask = Task.Run(() => SqlHelper.ExecuteDatasetAsync(_connString, spName, null));
                var result = await thisTask;
                
                return result.Tables[0].ToList<Groups>();
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        public async Task<Groups> Get(int id)
        {
            try
            {
                var spName = "dbo.usp_Groups_Get";
                var parameterValues = new object[1] {id};
                var thisTask = Task.Run(() => SqlHelper.ExecuteDatasetAsync(_connString, spName, parameterValues));
                var result = await thisTask;

                return result.Tables[0].ToList<Groups>().FirstOrDefault();
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
                var spName = "dbo.usp_Groups_Delete";
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
