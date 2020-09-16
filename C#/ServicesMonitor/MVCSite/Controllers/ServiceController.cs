using System.Threading.Tasks;
using DataAccess.Implementation;
using DataAccess.SMDB;
using Microsoft.AspNetCore.Mvc;

namespace MVCSite.Controllers
{
    public class ServiceController : Controller
    {
        [BindProperty] 
        public Services Service { get; set; }

        public IActionResult Index()
        {
            return View();
        }

        public IActionResult InsertOrUpdate(int? id)
        {
            Service = new Services();
            if (id == null)
            {
                return View(Service);
            }

            Service = (new ServicesImpl(Startup.ConnectionString).Get(id ?? default(int))).Result;
            if (Service == null)
            {
                return NotFound();
            }

            return View(Service);
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
                if (Service.Id == 0)
                {
                    //create
                    await new ServicesImpl(Startup.ConnectionString).Add(Service);
                }
                else
                {
                    await new ServicesImpl(Startup.ConnectionString).Update(Service);
                }

                return RedirectToAction("Index");
            }

            return View(Service);
        }

        [HttpGet]
        public async Task<ActionResult> GetList(int? id)
        {
            var groupId = id ?? 0;
            return Json(new {data = await new ServicesImpl(Startup.ConnectionString).ListByGroupId(groupId) });
        }

        [HttpDelete]
        public async Task<IActionResult> Delete(int id)
        {
            var service = await new ServicesImpl(Startup.ConnectionString).Get(id);
            if (service == null)
            {
                return Json(new {success = false, message = "Error while Deleting"});
            }

            await new ServicesImpl(Startup.ConnectionString).Delete(id);
            return Json(new {success = true, message = "Delete successful"});
        }

        #endregion
    }
}
