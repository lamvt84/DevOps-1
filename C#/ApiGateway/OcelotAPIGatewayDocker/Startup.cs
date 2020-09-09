using System;
using Microsoft.Extensions.Configuration;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.DependencyInjection;
using Ocelot.Middleware;
using Ocelot.DependencyInjection;
using Ocelot.Cache.CacheManager;

namespace OcelotAPIGatewayDocker
{
    public class Startup
    {
        // This method gets called by the runtime. Use this method to add services to the container.
        // For more information on how to configure your application, visit https://go.microsoft.com/fwlink/?LinkID=398940
        //public Startup(IHostingEnvironment env)
        //{
        //    var builder = new Microsoft.Extensions.Configuration.ConfigurationBuilder();
        //    builder.SetBasePath(env.ContentRootPath)
        //           .AddJsonFile("configuration.json", optional: false, reloadOnChange: true)
        //           .AddEnvironmentVariables();

        //    Configuration = builder.Build();
        //}
        //public IConfigurationRoot Configuration { get; }

        //public void ConfigureServices(IServiceCollection services)
        //{
        //    //Action<ConfigurationBuilderCachePart> settings = (x) =>
        //    //{
        //    //    x.WithMicrosoftLogging(log =>
        //    //    {
        //    //        log.AddConsole(LogLevel.Debug);

        //    //    }).WithDictionaryHandle();
        //    //};
        //    services.AddOcelot(Configuration).AddCacheManager(x => { x.WithDictionaryHandle(); });
        //}

        //// This method gets called by the runtime. Use this method to configure the HTTP request pipeline.
        //public async Task ConfigureAsync(IApplicationBuilder app, IHostingEnvironment env)
        //{
        //    await app.UseOcelot();
        //}
    }
}
