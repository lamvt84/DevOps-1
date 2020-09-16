using System.Text;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;

namespace MVCSite.Controllers
{
    public class TestController : Controller
    {
        private readonly StringBuilder _sb = new StringBuilder();
        public IActionResult Index()
        {
            return View();
        }
        public async Task<string> MakeTeaAsync()
        {
            var boilingWater = BoilWaterAsync();
            _sb.Append("Take cup out\n");
            _sb.Append("Put Tea\n");
            //var water = await boilingWater;
            var water = "!";
            var tea = $"pour {water} in cups\n";
          //  await boilingWater;
            _sb.Append(tea);
            await boilingWater;
            return _sb.ToString();
        }

        //public async Task GetString1()
        //{
            
        //}

        public async Task<string> BoilWaterAsync()
        {
            _sb.Append("Start boiling\n");
            await Task.Delay(5000);
            _sb.Append("Finish boiling\n");
            return "water";
        }

        public string MakeTea()
        {
            var water = BoilWater();
            _sb.Append("Take cup out\n");
            _sb.Append("Put Tea\n");
            var tea = $"pour {water} in cups\n";
            _sb.Append(tea);
            return _sb.ToString();
        }

        //public async Task GetString1()
        //{

        //}

        public string BoilWater()
        {
            _sb.Append("Start boiling\n");
            Task.Delay(2000).GetAwaiter().GetResult();
            _sb.Append("Finish boiling\n");
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
