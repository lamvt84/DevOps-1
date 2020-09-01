using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using DataAccess.Implementation;
using DataAccess.SMDB;
using Microsoft.AspNetCore.Mvc;
using Microsoft.CodeAnalysis.CSharp.Syntax;

namespace MVCSite.Controllers
{
    public class UserController : Controller
    {
        [BindProperty]
        public new Users User { get; set; }
        public IActionResult Index()
        {
            return View();
        }

        public IActionResult InsertOrUpdate(int? id)
        {
            User = new Users();
            if (id == null)
            {
                return View(User);
            }
            User = (new UsersImpl(Startup.ConnectionString).Get(id ?? default(int))).Result;
            if (User == null)
            {
                return NotFound();
            }
            return View(User);
        }

        //private async Task<Users> GetUser(int id)
        //{
        //    var mUser = await new UsersImpl(Startup.ConnectionString).Get(id);
        //    return mUser;
        //}

        #region API Calls
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> InsertOrUpdate()
        {
            if (ModelState.IsValid)
            {
                if (User.Id == 0)
                {
                    //create
                    await new UsersImpl(Startup.ConnectionString).Add(User);
                }
                else
                {
                    await new UsersImpl(Startup.ConnectionString).Update(User);
                }
                return RedirectToAction("Index");
            }
            return View(User);
        }
        [HttpGet]
        public async Task<ActionResult> GetList()
        {
            return Json(new {data = await new UsersImpl(Startup.ConnectionString).List() });
        }
        [HttpPost]
        public async Task<IActionResult> UpdateStatus(int id)
        {
            await new UsersImpl(Startup.ConnectionString).UpdateStatus(id);
            return Json(new { success = true, message = "update successful" });
        }
        [HttpDelete]
        public async Task<IActionResult> Delete(int id)
        {
            var user = await new UsersImpl(Startup.ConnectionString).Get(id);
            if (user == null)
            {
                return Json(new { success = false, message = "Error while Deleting" });
            }
            await new UsersImpl(Startup.ConnectionString).Delete(id);
            return Json(new { success = true, message = "Delete successful" });
        }
        #endregion
    }
}
