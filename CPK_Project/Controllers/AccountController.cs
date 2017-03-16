using System;
using System.Globalization;
using System.Linq;
using System.Security.Claims;
using System.Threading.Tasks;
using System.Web;
using System.Web.Mvc;
using Microsoft.AspNet.Identity;
using Microsoft.AspNet.Identity.Owin;
using Microsoft.Owin.Security;
using CPK_Project.Models;
using CPK_DAL;
using System.Data.SqlClient;
using System.Collections.Generic;
using CPK_Project.Classes;
using System.Data;
using System.Web.Security;

namespace CPK_Project.Controllers
{
    [Authorize]
    public class AccountController : Controller
    {

        //
        // GET: /Account/Login
        [AllowAnonymous]
        public ActionResult Login(string returnUrl)
        {
            ViewBag.ReturnUrl = returnUrl;
            return View();
        }

        //
        // POST: /Account/Login
        [HttpPost]
        [AllowAnonymous]
        [ValidateAntiForgeryToken]
        public ActionResult Login(LoginModel model, string returnUrl)
        {
            string message = "The login is invalid.";
            if (ModelState.IsValid)
            {
                try
                {
                    using ( DBManager db = new DBManager())
                    {
                        UserInfoModel userInfo = new UserInfoModel();
                        model.Password = Common.Encrypt(model.Password);
                        List<SqlParameter> paraList = Common.ListToParameter<LoginModel>(model);
                        //paraList.Add(Common.GetParameter("UserID", DbType.String, model.UserID, ParameterDirection.Input));
                        //paraList.Add(Common.GetParameter("Password", DbType.String, model.Password, ParameterDirection.Input));

                        DataSet DbSet = db.GetSelectQuery(paraList, "CPK.uspLogin");
                        DataTable dataTable = DbSet.Tables[0];
                        Common.CheckEmptyTable(dataTable, message);
                        userInfo = Common.DataToClass<UserInfoModel>(dataTable.Rows[0]);

                        FormsAuthenticationTicket ticket =
                               new FormsAuthenticationTicket(1, userInfo.UserID, DateTime.Now, DateTime.Now.AddMinutes(30), false
                                   , userInfo.UserRole + "|" + userInfo.UserType, FormsAuthentication.FormsCookiePath);
                        string encTicket = FormsAuthentication.Encrypt(ticket);
                        Response.Cookies.Add(new HttpCookie(FormsAuthentication.FormsCookieName, encTicket));
              
                        //Session["User"] = userInfo;

                        if (!String.IsNullOrEmpty(returnUrl))
                        {
                            return Redirect(returnUrl);
                        }
                        else
                        {
                            return RedirectToAction("Index", "Home");
                        }
                    }
                }
                catch (Exception ex)
                {
                    message = ex.Message;
                }
            }

            // If we got this far, something failed, redisplay form
            ModelState.AddModelError("", message);
            return View(model);
        }

       
        //
        // GET: /Account/Register
        [AllowAnonymous]
        public ActionResult Register()
        {
            return View();
        }

        //
        // POST: /Account/Register
        [HttpPost]
        [AllowAnonymous]
        [ValidateAntiForgeryToken]
        public ActionResult Register(UserRegisterModel model)
        {
            if (ModelState.IsValid)
            {
                //var user = new ApplicationUser { UserName = model.Email, Email = model.Email };
                //var result = await UserManager.CreateAsync(user, model.Password);
                //if (result.Succeeded)
                //{
                //    await SignInManager.SignInAsync(user, isPersistent:false, rememberBrowser:false);
                    
                //    // For more information on how to enable account confirmation and password reset please visit http://go.microsoft.com/fwlink/?LinkID=320771
                //    // Send an email with this link
                //    // string code = await UserManager.GenerateEmailConfirmationTokenAsync(user.Id);
                //    // var callbackUrl = Url.Action("ConfirmEmail", "Account", new { userId = user.Id, code = code }, protocol: Request.Url.Scheme);
                //    // await UserManager.SendEmailAsync(user.Id, "Confirm your account", "Please confirm your account by clicking <a href=\"" + callbackUrl + "\">here</a>");

                //    return RedirectToAction("Index", "Home");
                //}
                //AddErrors(result);
            }

            // If we got this far, something failed, redisplay form
            return View(model);
        }


        //
        // POST: /Account/LogOff
        [HttpPost]
        public ActionResult LogOff()
        {
            //Session.Abandon();
            FormsAuthentication.SignOut();
            return RedirectToAction("Index", "Home");
        }

     
    }
}