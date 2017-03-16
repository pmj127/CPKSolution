using Microsoft.Owin;
using Owin;

[assembly: OwinStartupAttribute(typeof(CPK_Project.Startup))]
namespace CPK_Project
{
    public partial class Startup
    {
        public void Configuration(IAppBuilder app)
        {
            ConfigureAuth(app);
        }
    }
}
