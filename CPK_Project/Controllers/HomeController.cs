using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using CPK_DAL;
using CPK_Project.Models;
using System.Data;
using System.Data.SqlClient;
using CPK_Project.Classes;

namespace CPK_Project.Controllers
{
    public class HomeController : Controller
    {
        public ActionResult Index()
        {
            return View();
        }

        public ActionResult Help()
        {
            return View();
        }

        [ChildActionOnly]
        public PartialViewResult LoginPartial()
        {
            if(User.Identity.IsAuthenticated)
            {
                using (DBManager db = new DBManager())
                {
                    string UserID = User.Identity.Name;
                    string procedureName = "CPK.uspMessageUnreadCount";
                    List<SqlParameter> paraList = new List<SqlParameter>();
                    if (User.IsInRole("Admin"))
                        UserID = "Administrator";
                    paraList.Add(Common.GetParameter("UserID", DbType.String, UserID, ParameterDirection.Input));
                    DataSet DbSet = db.GetSelectQuery(paraList, procedureName);
                    ViewBag.count = Int16.Parse( DbSet.Tables[0].Rows[0]["MessageCount"].ToString());
                }
            }
            return PartialView("~/Views/Shared/_LoginPartial.cshtml");
        }

    }
}