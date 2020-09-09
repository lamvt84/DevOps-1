using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

namespace MVCSite.Controllers
{
    public class TestController : Controller
    {
        public StringBuilder sb = new StringBuilder();
        public IActionResult Index()
        {
            return View();
        }
        public async Task<string> MakeTeaAsync()
        {
            var boilingWater = BoilWaterAsync();
            sb.Append("Take cup out\n");
            sb.Append("Put Tea\n");
            //var water = await boilingWater;
            var water = "!";
            var tea = $"pour {water} in cups\n";
          //  await boilingWater;
            sb.Append(tea);
            await boilingWater;
            return sb.ToString();
        }

        //public async Task GetString1()
        //{
            
        //}

        public async Task<string> BoilWaterAsync()
        {
            sb.Append("Start boiling\n");
            await Task.Delay(5000);
            sb.Append("Finish boiling\n");
            return "water";
        }

        public string MakeTea()
        {
            var water = BoilWater();
            sb.Append("Take cup out\n");
            sb.Append("Put Tea\n");
            var tea = $"pour {water} in cups\n";
            sb.Append(tea);
            return sb.ToString();
        }

        //public async Task GetString1()
        //{

        //}

        public string BoilWater()
        {
            sb.Append("Start boiling\n");
            Task.Delay(2000).GetAwaiter().GetResult();
            sb.Append("Finish boiling\n");
            return "water";
        }

        [HttpPost("[action]")]
        public async Task<ActionResult> GetMakeTeaAsync()
        {
            var j = await MakeTeaAsync();
            return Content(j);
        }

        [HttpGet]
        public ActionResult GetMakeTea()
        {
            var j = MakeTeaAsync();
            return Content(j.Result);
        }
    }
}
