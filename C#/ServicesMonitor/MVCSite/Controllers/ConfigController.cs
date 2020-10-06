using System.Collections.Generic;
using System.Dynamic;
using System.Linq.Expressions;
using System.Threading.Tasks;
using DataAccess.Implementation;
using DataAccess.SMDB;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging.Abstractions;
using Microsoft.Extensions.Options;
using MVCSite.Models;


namespace MVCSite.Controllers
{
    public class ConfigController : Controller
    {
        private string ConnectionString { get; }
        private ExtendSettings ExtendSettings { get; }
        public ConfigController(IOptionsSnapshot<ExtendSettings> settings = null)
        {
            if (settings != null) ExtendSettings = settings.Value;
            ConnectionString = Startup.ConnectionString;
        }
        public new IActionResult User()
        {
            return View();
        }
        public IActionResult UserInsertOrUpdate(int? id)
        {
            Users mUsers = new Users();
            if (id == null)
            {
                return View(mUsers);
            }
            mUsers = (new UsersImpl(ConnectionString).Get(id ?? default(int))).Result;
            if (mUsers == null)
            {
                return NotFound();
            }
            return View(mUsers);
        }
        public IActionResult Service()
        {
            return View();
        }
        public IActionResult ServiceInsertOrUpdate(int? id)
        {
            Services mService = new Services();
            if (id == null)
            {
                return View(mService);
            }

            mService = (new ServicesImpl(ConnectionString).Get(id ?? default(int))).Result;
            if (mService == null)
            {
                return NotFound();
            }

            return View(mService);
        }
        public IActionResult Group()
        {
            return View();
        }
        public IActionResult GroupInsertOrUpdate(int? id)
        {
            var groupViewModel = new GroupViewModel();
            var groupTag = new List<GroupTag>()
            {
                new GroupTag() {Tag = "API"},
                new GroupTag() {Tag = "TCP"},
                new GroupTag() {Tag = "UDP"}
            };
            groupViewModel.GroupTag = groupTag;
            Groups mGroup = new Groups();
            if (id == null)
            {
                groupViewModel.Groups = mGroup;
                return View(groupViewModel);
            }
            mGroup = new GroupsImpl(ConnectionString).Get(id ?? default(int)).Result;
            if (mGroup == null)
            {
                return NotFound();
            }
            groupViewModel.Groups = mGroup;
            return View(groupViewModel);
        }
        public IActionResult Alert()
        {
            return View();
        }
        public IActionResult SmsInsertOrUpdate(int? id)
        {
            SmsConfig smsConfig = new SmsConfig();
            if (id == null)
            {
                return View(smsConfig);
            }
            smsConfig = new SmsConfigImpl(ConnectionString).Get(id ?? default(int)).Result;
            if (smsConfig == null)
            {
                return NotFound();
            }
            return View(smsConfig);
        }
        public IActionResult EmailInsertOrUpdate(int? id)
        {
            if (id == null)
            {
                return NotFound();
            }
            EmailConfig emailConfig = new EmailConfigImpl(ConnectionString).Get(id ?? default(int)).Result;
            if (emailConfig == null)
            {
                return NotFound();
            }
            return View(emailConfig);
        }


        #region Internal Api
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> UserInsertOrUpdate([Bind(include: "Id,FirstName,LastName,Email,UserName,Password")] Users mUsers)
        {
            if (!ModelState.IsValid) return View(mUsers);
            if (mUsers.Id == 0)
            {
                //create
                await new UsersImpl(ConnectionString).Add(mUsers);
            }
            else
            {
                await new UsersImpl(ConnectionString).Update(mUsers);
            }
            return RedirectToAction("User");
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> GroupInsertOrUpdate(GroupViewModel mGroupViewModel)
        {
            if (!ModelState.IsValid) return View(mGroupViewModel);
            if (mGroupViewModel.Groups.Id == 0)
            {
                //create
                await new GroupsImpl(ConnectionString).Add(mGroupViewModel.Groups);
            }
            else
            {
                await new GroupsImpl(ConnectionString).Update(mGroupViewModel.Groups);
            }
            return RedirectToAction("Group");
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> ServiceInsertOrUpdate([Bind(include: "Id,Name,Description,GroupId,Url,Params,ResponseCode,Enable,Status,SpecialCase")] Services mService)
        {
            if (ModelState.IsValid)
            {
                if (mService.Id == 0)
                {
                    //create
                    await new ServicesImpl(ConnectionString).Add(mService);
                }
                else
                {
                    await new ServicesImpl(ConnectionString).Update(mService);
                }

                return RedirectToAction("Service");
            }

            return View(mService);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> EmailInsertOrUpdate(EmailConfig emailConfig)
        {
            if (ModelState.IsValid)
            {
                emailConfig.DataSign = Encryption
                    .Md5Hash($"{emailConfig.ToMail}-{emailConfig.CCMail}-{ExtendSettings.SecureKey}").ToLower();
                emailConfig.CCMail = (emailConfig.CCMail == null) ? "" : emailConfig.CCMail;

                if (emailConfig.Id == 0)
                {
                    //create
                    // await new ServicesImpl(ConnectionString).Add(emailConfig);
                    return RedirectToAction("Alert");
                }
                else
                {
                    await new EmailConfigImpl(ConnectionString).Update(emailConfig);
                }

                return RedirectToAction("Alert");
            }

            return View(emailConfig);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> SmsInsertOrUpdate(SmsConfig smsConfig)
        {
            if (ModelState.IsValid)
            {
                smsConfig.DataSign = Encryption
                    .Md5Hash($"{smsConfig.AccountName}-{smsConfig.Mobile}-{smsConfig.Message}-{ExtendSettings.SecureKey}").ToLower();
                //smsConfig.AlertConfigId = 1;
                if (smsConfig.Id == 0)
                {
                    //create
                    await new SmsConfigImpl(ConnectionString).Add(smsConfig);
                }
                else
                {
                    await new SmsConfigImpl(ConnectionString).Update(smsConfig);
                }

                return RedirectToAction("Alert");
            }

            return View(smsConfig);
        }
        #endregion
    }
}
