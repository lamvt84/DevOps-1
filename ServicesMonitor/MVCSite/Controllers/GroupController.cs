using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using DataAccess.Implementation;
using DataAccess.SMDB;
using Microsoft.AspNetCore.Mvc;

namespace MVCSite.Controllers
{
    public class GroupController : Controller
    {
        [BindProperty]
        public Groups Group { get; set; }
        public IActionResult Index()
        {
            return View();
        }
        public IActionResult InsertOrUpdate(int? id)
        {
            Group = new Groups();
            if (id == null)
            {
                return View(Group);
            }
            Group = (new GroupsImpl(Startup.ConnectionString).Get(id ?? default(int))).Result;
            if (Group == null)
            {
                return NotFound();
            }
            return View(Group);
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
                if (Group.Id == 0)
                {
                    //create
                    await new GroupsImpl(Startup.ConnectionString).Add(Group);
                }
                else
                {
                    await new GroupsImpl(Startup.ConnectionString).Update(Group);
                }
                return RedirectToAction("Index");
            }
            return View(Group);
        }
        [HttpGet]
        public async Task<ActionResult> GetList()
        {
            return Json(new { data = await new GroupsImpl(Startup.ConnectionString).List() });
        }
        [HttpDelete]
        public async Task<IActionResult> Delete(int id)
        {
            var group = await new GroupsImpl(Startup.ConnectionString).Get(id);
            if (group == null)
            {
                return Json(new { success = false, message = "Error while Deleting" });
            }
            await new GroupsImpl(Startup.ConnectionString).Delete(id);
            return Json(new { success = true, message = "Delete successful" });
        }
        #endregion
    }
}
