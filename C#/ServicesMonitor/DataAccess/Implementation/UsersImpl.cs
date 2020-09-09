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
    public class UsersImpl: IUsers
    {
        private readonly string _connString;

        public UsersImpl(string connString)
        {
            _connString = connString;
        }

        public async Task<int> Add(Users user)
        {
            try
            {
                var spName = "dbo.usp_Users_Add";

                var parameterValues = new object[6];
                parameterValues[0] = user.FirstName;
                parameterValues[1] = user.LastName;
                parameterValues[2] = user.Email;
                parameterValues[3] = user.UserName;
                parameterValues[4] = user.Password;
                var thisTask = Task.Run(() => SqlHelper.ExecuteNonQueryAsync(_connString, spName, parameterValues));
                var result = await thisTask;
                return result;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        public async Task<int> Update(Users user)
        {
            try
            {
                var spName = "dbo.usp_Users_Update";

                var parameterValues = new object[7];
                parameterValues[0] = user.Id;
                parameterValues[1] = user.FirstName;
                parameterValues[2] = user.LastName;
                parameterValues[3] = user.Email;
                parameterValues[4] = user.UserName;
                parameterValues[5] = user.Password;
                var thisTask = Task.Run(() => SqlHelper.ExecuteNonQueryAsync(_connString, spName, parameterValues));
                var result = await thisTask;
                return result;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public int VerifyAuthentication(Users user)
        {
            try
            {
                var spName = "dbo.usp_UsersLogin_VerifyAuthentication";

                var parameterValues = new object[3];
                parameterValues[0] = user.UserName;
                parameterValues[1] = user.Password;
                SqlHelper.ExecuteNonQuery(_connString, spName, parameterValues);
                return (int)parameterValues[3];
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public async Task<List<Users>> List()
        {
            try
            {
                var spName = "dbo.usp_Users_List";
                var thisTask = Task.Run(() => SqlHelper.ExecuteDatasetAsync(_connString, spName, null));
                var result = await thisTask;
                
                return result.Tables[0].ToList<Users>();
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        public async Task<Users> Get(int id)
        {
            try
            {
                var spName = "dbo.usp_Users_Get";
                var parameterValues = new object[1];
                parameterValues[0] = id;
                var thisTask = Task.Run(() => SqlHelper.ExecuteDatasetAsync(_connString, spName, parameterValues));
                var result = await thisTask;

                return result.Tables[0].ToList<Users>().FirstOrDefault();
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
                var spName = "dbo.usp_Users_UpdateStatus";
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
        public async Task<int> Delete(int id)
        {
            try
            {
                var spName = "dbo.usp_Users_Delete";
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
