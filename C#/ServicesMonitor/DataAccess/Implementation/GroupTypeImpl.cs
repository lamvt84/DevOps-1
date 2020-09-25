using System;
using System.Collections.Generic;
using System.Text;
using System.Threading.Tasks;
using CommonLibs;
using DataAccess.Interface;
using DataAccess.SMDB;

namespace DataAccess.Implementation
{
    public class GroupTypeImpl: IGroupType
    {
        private readonly string _connString;

        public GroupTypeImpl(string connString)
        {
            _connString = connString;
        }
        public async Task<List<GroupType>> List()
        {
            try
            {
                var spName = "dbo.usp_GroupType_List";
                var thisTask = Task.Run(() => SqlHelper.ExecuteDatasetAsync(_connString, spName, null));
                var result = await thisTask;

                return result.Tables[0].ToList<GroupType>();
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
    }
}
