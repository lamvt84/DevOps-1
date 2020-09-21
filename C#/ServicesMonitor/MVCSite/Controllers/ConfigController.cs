using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection.Metadata;
using System.Threading.Tasks;
using DataAccess.Implementation;
using DataAccess.SMDB;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Options;
using MVCSite.Libs;

namespace MVCSite.Controllers
{
    public class ConfigController : Controller
    {
        private string ConnectionString { get; }
        private ExtendSettings Settings { get; }
        public ConfigController(IOptions<ExtendSettings> settings = null)
        {
            if (settings != null) Settings = settings.Value;
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
            mUsers = (new UsersImpl(Startup.ConnectionString).Get(id ?? default(int))).Result;
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

            mService = (new ServicesImpl(Startup.ConnectionString).Get(id ?? default(int))).Result;
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
            Groups mGroups = new Groups();
            if (id == null)
            {
                return View(mGroups);
            }
            mGroups = new GroupsImpl(Startup.ConnectionString).Get(id ?? default(int)).Result;
            if (mGroups == null)
            {
                return NotFound();
            }
            return View(mGroups);
        }
        public IActionResult Alert()
        {
            return View();
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
        public async Task<IActionResult> GroupInsertOrUpdate([Bind(include: "Id,Name,Description")] Groups mGroup)
        {
            if (!ModelState.IsValid) return View(mGroup);
            if (mGroup.Id == 0)
            {
                //create
                await new GroupsImpl(ConnectionString).Add(mGroup);
            }
            else
            {
                await new GroupsImpl(ConnectionString).Update(mGroup);
            }
            return RedirectToAction("Group");
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> ServiceInsertOrUpdate([Bind(include: "Id,Name,Description,GroupId,Url,Params,ResponseCode,Enable")] Services mService)
        {
            if (ModelState.IsValid)
            {
                if (mService.Id == 0)
                {
                    //create
                    await new ServicesImpl(Startup.ConnectionString).Add(mService);
                }
                else
                {
                    await new ServicesImpl(Startup.ConnectionString).Update(mService);
                }

                return RedirectToAction("Service");
            }

            return View(mService);
        }
        #endregion
    }
}
