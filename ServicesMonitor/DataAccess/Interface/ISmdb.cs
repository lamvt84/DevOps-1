using System;
using System.Collections.Generic;
using System.Data;
using System.Text;
using System.Threading.Tasks;
using DataAccess.SMDB;

namespace DataAccess.Interface
{
    public interface IUsers
    {
        Task<int> Add(Users user);
        Task<int> Update(Users user);
        Task<int> Delete(int id);
        Task<int> UpdateStatus(int id);
        int VerifyAuthentication(Users user);
        Task<List<Users>> List();
        Task<Users> Get(int id);
    }
    public interface IGroups
    {
        Task<int> Add(Groups group);
        Task<int> Update(Groups group);
        Task<int> Delete(int id);
        Task<List<Groups>> List();
        Task<Groups> Get(int id);
    }
    public interface IServices
    {
        Task<int> Add(Services service);
        Task<int> Update(Services service);
        Task<int> Delete(int id);
        Task<List<Services>> ListByGroupId(int groupId);
        Task<List<Services>> ListByEnable(int enable);
        Task<Services> Get(int id);
        Task<int> UpdateStatus(Services service);
        Task<DataTable> GetServiceSummary();
    }

    public interface IServicesLog
    {
        Task<int> Add(ServicesLog service);
    }
}
