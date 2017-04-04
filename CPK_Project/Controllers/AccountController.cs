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
                    using (DBManager db = new DBManager())
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
        public ActionResult Register(RegisterViewModel model)
        {
            if (ModelState.IsValid)
            {
                try
                {
                    using (DBManager db = new DBManager())
                    {
                        model.Password = Common.Encrypt(model.Password);
                        List<SqlParameter> paraList = Common.ListToParameter<UserRegisterInfo>
                            (AccountHelper.getUserRegisterInfo(model));
                        db.GetExecuteNonQuery(paraList, "CPK.uspRegister");

                        return RedirectToAction("index", "home");
                    }
                }
                catch (Exception ex)
                {
                    ModelState.AddModelError("", ex.Message);
                }

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

        [Authorize(Roles = "Admin")]
        public ActionResult Index()
        {
            return View();
        }

        [Authorize(Roles = "Admin")]
        [HttpPost]
        public JsonResult GetList(int pageNo, int pageSize, string searchText, string userID, string orderColumn, string orderDesc)
        {
            try
            {
                using (DBManager db = new DBManager())
                {
                    string nameOfProcedure = "CPK.uspUserList";
                    List<SqlParameter> paraList = new List<SqlParameter>();
                    paraList.Add(Common.GetParameter("PageNo", DbType.Int32, Convert.ToInt32(pageNo), ParameterDirection.Input));
                    paraList.Add(Common.GetParameter("PageSize", DbType.Int32, Convert.ToInt32(pageSize), ParameterDirection.Input));
                    paraList.Add(Common.GetParameter("FullName", DbType.String, searchText, ParameterDirection.Input));

                    if (!AccountHelper.isEmpty(orderColumn))
                    {
                        paraList.Add(Common.GetParameter("Sort", DbType.String, orderColumn + orderDesc, ParameterDirection.Input));
                        nameOfProcedure = "CPK.uspUserListSort";
                    }

                    DataSet DbSet = db.GetSelectQuery(paraList, nameOfProcedure);
                    ListViewModel<UserListViewModel> listView = Common.DataToClass<ListViewModel<UserListViewModel>>(DbSet.Tables[0].Rows[0]);
                    List<UserListViewModel> userList = Common.DataToList<UserListViewModel>(DbSet.Tables[1]);
                    listView.Rows = userList;
                    return Json(listView, JsonRequestBehavior.DenyGet);
                }
            }
            catch (Exception ex)
            {
                JsonError e = new JsonError(ex.Message);
                return Json(e, JsonRequestBehavior.DenyGet);
            }
        }

        [Authorize(Roles = "Admin")]
        public ActionResult UserInfo(string id)
        {
            string message;
            RegisterViewModel model;

            if (AccountHelper.isEmpty(id))
            {
                return RedirectToAction("Index");
            }

            using (DBManager db = new DBManager())
            {
                DataRowCollection rows = AccountHelper.getUserRowByID(db, id);

                if (rows.Count == 0)
                {
                    message = "User is not found";
                    return RedirectToAction("Index");
                }
                else
                {
                    model = AccountHelper.getRegisterViewModel(rows[0]);
                    model.Password = Common.Decrypt(model.Password);
                }
            }

            return View(model);
        }

        [Authorize(Roles = "Admin")]
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult UserInfo(RegisterViewModel model, string trigger)
        {

            if (model == null) return RedirectToAction("Index");

            ActionResult returnPage = View(model);
            if ("reset".Equals(trigger))
            {
                try
                {
                    using (DBManager db = new DBManager())
                    {
                        DataRowCollection rows = AccountHelper.getUserRowByID(db, model.UserID);
                        model = AccountHelper.getRegisterViewModel(rows[0]);
                        model.ConfirmPassword = model.Password = "CPKUser";
                    }
                }
                catch (Exception e)
                {
                    setError(e);
                }
            }
            else if ("save".Equals(trigger))
            {
                model.ConfirmPassword = model.Password;
            }

            if (ViewBag.Message == null)
            {
                ModelState.Clear();
                if (TryValidateModel(model))
                {
                    try
                    {
                        using (DBManager db = new DBManager())
                        {
                            string nameOfProcedure = "[CPK].[uspUpdateUser]";
                            model.Password = Common.Encrypt(model.Password);
                            List<SqlParameter> paramList = Common.ListToParameter<UserRegisterInfo>(
                                AccountHelper.getUserRegisterInfo(model));
                            db.GetExecuteNonQuery(paramList, nameOfProcedure);
                            if ("reset".Equals(trigger)) returnPage = RedirectToAction("UserInfo", new { id = model.UserID });
                            else if ("save".Equals(trigger)) returnPage = RedirectToAction("Index");
                        }
                    }
                    catch(Exception e)
                    {
                        setError(e);
                    }
                }
            }

            return returnPage;
        }

        private void setError(Exception e)
        {
            ViewBag.Message = "Fatal: " + e.GetBaseException().Message;
        }
    }
}
