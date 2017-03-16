using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Security;

namespace CPK_Project.Classes
{
    public class CheckAuthorizeAttribute : ActionFilterAttribute, IAuthorizationFilter
    {
        public string Names { get; set; }
        public void OnAuthorization(AuthorizationContext filterContext)
        {
            if(this.Names != null)
            {
                foreach (string role in this.Names.Split(','))
                {
                    if (HttpContext.Current.User.IsInRole(role.Trim()))
                    {
                        return;
                    }
                }
                throw new SecurityException("Access Denied!");
            }
            return;
            //filterContext.Result = new ViewResult();//new RedirectResult("/Project");
            //throw new SecurityException("Access Denied!");
        }

        //public override void OnActionExecuting(ActionExecutingContext filterContext)
        //{
        //    HttpContextBase context = filterContext.HttpContext;
        //    if (context.Session != null)
        //    {
        //        if (context.Session.IsNewSession)
        //        {
        //            string cookie = context.Request.Headers["Cookie"];
        //            if (cookie != null && cookie.IndexOf("ASP.NET_SessionId") >= 0)
        //            {
        //                //filterContext.Result = RedirectToAction("MoveToSessionExpired", "Account");
        //                //return;
        //                string redirectTo = "~/Account/Login";
        //                if (!string.IsNullOrEmpty(context.Request.RawUrl))
        //                {
        //                    redirectTo = string.Format("~/Account/Login?ReturnUrl={0}", HttpUtility.UrlEncode(context.Request.RawUrl));
        //                    filterContext.Result = new RedirectResult(redirectTo);
        //                    return;
        //                }
        //            }
        //        }
        //    }
        //    base.OnActionExecuting(filterContext);

        //}
    }

    public class AJaxAuthorizeAttribute: AuthorizeAttribute
    {
  
        protected override void HandleUnauthorizedRequest(AuthorizationContext filterContext)
        {
            if (filterContext.HttpContext.Request.IsAjaxRequest())
            {
                var urlHelper = new UrlHelper(filterContext.RequestContext);
                filterContext.HttpContext.Response.StatusCode = 403;
                filterContext.Result = new JsonResult
                {
                    Data = new
                    {
                        Error = "UnAuthorized",
                        LogInUrl = "/Account/Login"
                    },
                    JsonRequestBehavior = JsonRequestBehavior.AllowGet
                };
            }
            else
            {
                base.HandleUnauthorizedRequest(filterContext);
            }
        }
    }
}