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
                var outputParameter = new SqlParameter("@ResponseCode", SqlDbType.Int)
                {
                    Direction = ParameterDirection.Output
                };

                var parameterValues = new object[6]
                {
                    user.FirstName,
                    user.LastName,
                    user.Email,
                    user.UserName,
                    user.Password,
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
        public async Task<int> Update(Users user)
        {
            try
            {
                var spName = "dbo.usp_Users_Update";
                var outputParameter = new SqlParameter("@ResponseCode", SqlDbType.Int)
                {
                    Direction = ParameterDirection.Output
                };

                var parameterValues = new object[7]
                {
                    user.Id,
                    user.FirstName,
                    user.LastName,
                    user.Email,
                    user.UserName,
                    user.Password,
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

        public int VerifyAuthentication(Users user)
        {
            try
            {
                var spName = "dbo.usp_UsersLogin_VerifyAuthentication";
                var outputParameter = new SqlParameter("@ResponseCode", SqlDbType.Int)
                {
                    Direction = ParameterDirection.Output
                };

                var parameterValues = new object[3]
                {
                    user.UserName,
                    user.Password,
                    outputParameter
                };
                
                SqlHelper.ExecuteNonQuery(_connString, spName, parameterValues);
                return (int)outputParameter.Value;
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
                var parameterValues = new object[1] {id};
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
        public async Task<int> Delete(int id)
        {
            try
            {
                var spName = "dbo.usp_Users_Delete";
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
