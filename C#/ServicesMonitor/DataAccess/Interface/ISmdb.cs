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
        Task<List<Services>> ListByStatus(int status);
    }

    public interface IServicesLog
    {
        Task<int> Add(ServicesLog service);
    }

    public interface IAlertConfig
    {
        Task<int> UpdateWarningStatus(AlertConfig alertConfig);
        Task<AlertConfig> Get(int id);
    }

    public interface IEmailConfig
    {
        Task<EmailConfig> Get(int id);
        Task<List<EmailConfig>> ListByAlertConfigId(int alertConfigId);
        Task<int> Update(EmailConfig emailConfig);
        Task<int> Delete(int id);
        Task<int> UpdateStatus(int id);
    }

    public interface ISmsConfig
    {
        Task<SmsConfig> Get(int id);
        Task<List<SmsConfig>> ListByAlertConfigId(int alertConfigId);
        Task<int> Update(SmsConfig smsConfig);
        Task<int> Add(SmsConfig smsConfig);
        Task<int> Delete(int id);
        Task<int> UpdateStatus(int id);
    }

    public interface IAlertLog
    {
        Task<int> Add(AlertLog alertLog);
    }

    public interface ITaskSchedulerLog
    {
        Task<int> Add(TaskSchedulerLog taskSchedulerLog);
    }
}
