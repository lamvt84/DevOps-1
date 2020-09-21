using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Options;
using MVCSite.Libs;

namespace MVCSite.Controllers
{
    public class ServicesController : Controller
    {
        private string ConnectionString { get; }
        private ExtendSettings Settings { get; }
        public ServicesController(IOptions<ExtendSettings> settings = null)
        {
            if (settings != null) Settings = settings.Value;
            ConnectionString = Startup.ConnectionString;
        }
        public IActionResult Index()
        {
            return View();
        }
    }
}
