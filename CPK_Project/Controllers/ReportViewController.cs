using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using CPK_Project.Models;
using CPK_Project.Classes;
using CPK_DAL;
using System.Data.SqlClient;
using System.Data;
/// <summary>
/// ReportView controller
/// Create: 2017-02-05
/// Author: Moonjoon Park
/// </summary>
namespace CPK_Project.Controllers
{
  
    public class ReportViewController : Controller
    {
        [Authorize]
        public ActionResult Index(int reportID, int width = 100, int height = 650)
        {
            int countGroup = 0;
            if(!User.IsInRole("Admin"))
            {
                using (DBManager db = new DBManager())
                {
                    string procedureName = "CPK.uspCheckReportAuthority";
                    List<SqlParameter> paraList = new List<SqlParameter>();

                    paraList.Add(Common.GetParameter("ReportID", DbType.Int32, Convert.ToInt32(reportID), ParameterDirection.Input));
                    paraList.Add(Common.GetParameter("UserID", DbType.String, User.Identity.Name, ParameterDirection.Input));
                    paraList.Add(Common.GetParameter("GroupCount", DbType.String, User.Identity.Name, ParameterDirection.Output));
                    countGroup = Int16.Parse(db.GetExecuteNonQuery(paraList, procedureName, "GroupCount"));
                }
            }
            else
            {
                countGroup = 1;
            }
            
            if (countGroup > 0)
            {
                var reporstView = new ReportsView
                {
                    ReportID = reportID,
                    Width = width,
                    Height = height,
                    ViewerURL = String.Format("/ReportsView/ReportsViewer.aspx?ReportID={0}&Height={1}", reportID, height)
                };

                return View(reporstView);
            }
            else // when user does not have authority for reportID
            {
                TempData["message"] = "You do not have an authority for the report!";
                TempData["messageType"] = "Error";
                if(Request.UrlReferrer != null)
                    return Redirect(Request.UrlReferrer.ToString());
                else
                    return RedirectToAction("Index", "Home");
            }

        }

        [HttpPost]
        [AJaxAuthorize(Roles = "Admin")]
        public JsonResult GetList(int pageNo, int pageSize, string searchText, string filterText, string orderColumn, string orderDesc)
        {
            try
            {
                using (DBManager db = new DBManager())
                {
                    
                    string procedureName = "CPK.uspReportList";
                    List<SqlParameter> paraList = new List<SqlParameter>();
                    paraList.Add(Common.GetParameter("PageNo", DbType.Int32, Convert.ToInt32(pageNo), ParameterDirection.Input));
                    paraList.Add(Common.GetParameter("PageSize", DbType.Int32, Convert.ToInt32(pageSize), ParameterDirection.Input));
                    paraList.Add(Common.GetParameter("ReportName", DbType.String, searchText, ParameterDirection.Input));
                    paraList.Add(Common.GetParameter("IsActive", DbType.String, filterText, ParameterDirection.Input));
                    if(orderColumn != null && orderColumn.Length != 0)
                    {
                        paraList.Add(Common.GetParameter("Sort", DbType.String, orderColumn+ orderDesc, ParameterDirection.Input));
                        procedureName = "CPK.uspReportListSort";
                    }

                    DataSet DbSet = db.GetSelectQuery(paraList, procedureName);
                    ListViewModel<ReportAdmin> listView = Common.DataToClass<ListViewModel<ReportAdmin>>(DbSet.Tables[0].Rows[0]);
                    List<ReportAdmin> reportList = Common.DataToList<ReportAdmin>(DbSet.Tables[1]);
                    listView.Rows= reportList;
                    return Json(listView, JsonRequestBehavior.DenyGet);
                }

            }
            catch (Exception ex)
            {
                JsonError e = new JsonError(ex.Message);
                return Json(e, JsonRequestBehavior.DenyGet);
            }

        }


        [HttpPost]
        [AJaxAuthorize]
        public JsonResult GetUserList(int pageNo, int pageSize, string searchText, string filterText, string orderColumn, string orderDesc)
        {
            try
            {
                using (DBManager db = new DBManager())
                {

                    string procedureName = "CPK.uspReportUserList";
                    string userID = User.Identity.Name;
                    List<SqlParameter> paraList = new List<SqlParameter>();
                    paraList.Add(Common.GetParameter("PageNo", DbType.Int32, Convert.ToInt32(pageNo), ParameterDirection.Input));
                    paraList.Add(Common.GetParameter("PageSize", DbType.Int32, Convert.ToInt32(pageSize), ParameterDirection.Input));
                    paraList.Add(Common.GetParameter("ReportName", DbType.String, searchText, ParameterDirection.Input));
                    paraList.Add(Common.GetParameter("IsActive", DbType.String, filterText, ParameterDirection.Input));
                    paraList.Add(Common.GetParameter("UserID", DbType.String, userID, ParameterDirection.Input));
                    if (orderColumn != null && orderColumn.Length != 0)
                    {
                        paraList.Add(Common.GetParameter("Sort", DbType.String, orderColumn + orderDesc, ParameterDirection.Input));
                        procedureName = "CPK.uspReportUserListSort";
                    }

                    DataSet DbSet = db.GetSelectQuery(paraList, procedureName);
                    ListViewModel<ReportAdmin> listView = Common.DataToClass<ListViewModel<ReportAdmin>>(DbSet.Tables[0].Rows[0]);
                    List<ReportAdmin> reportList = Common.DataToList<ReportAdmin>(DbSet.Tables[1]);
                    listView.Rows = reportList;
                    return Json(listView, JsonRequestBehavior.DenyGet);
                }

            }
            catch (Exception ex)
            {
                JsonError e = new JsonError(ex.Message);
                return Json(e, JsonRequestBehavior.DenyGet);
            }

        }


        [HttpPost]
        [Authorize]
        public JsonResult GetListByGroup(string filterText)
        {
            try
            {
                using (DBManager db = new DBManager())
                {

                    string procedureName = "CPK.uspReportListByGroup";
                    List<SqlParameter> paraList = new List<SqlParameter>();
                    paraList.Add(Common.GetParameter("GroupId", DbType.String, Convert.ToInt32(filterText), ParameterDirection.Input));

                    DataSet DbSet = db.GetSelectQuery(paraList, procedureName);
                    ListViewModel<ReportAdmin> listView = Common.DataToClass<ListViewModel<ReportAdmin>>(DbSet.Tables[0].Rows[0]);
                    List<ReportAdmin> reportList = Common.DataToList<ReportAdmin>(DbSet.Tables[1]);
                    listView.Rows = reportList;
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
        public ActionResult List()
        {
            //TempData["ActionName"] = "List";
            //TempData["ControllerName"] = "ReportView";
            return View();
        }
        // GET: ReportView/Details/5
        [Authorize(Roles = "Admin")]
        public ActionResult Details(int id)
        { 

            ReportAdmin reportAdmin = null;
            using (DBManager db = new DBManager())
            {
                string procedureName = "CPK.uspReportDetail";
                List<SqlParameter> paraList = new List<SqlParameter>();
                paraList.Add(Common.GetParameter("ReportID", DbType.String, id, ParameterDirection.Input));

                DataSet DbSet = db.GetSelectQuery(paraList, procedureName);
                reportAdmin = Common.DataToClass<ReportAdmin>(DbSet.Tables[0].Rows[0]);
            }
            return View(reportAdmin);
        }

        // GET: ReportView/Create
        [Authorize(Roles = "Admin")]
        public ActionResult Create()
        {
            ViewBag.Status = Common.GetSelectList(Common.SelectListType.Inactive);
            return View();
        }

        // POST: ReportView/Create
        [HttpPost]
        [Authorize(Roles ="Admin")]
        [ValidateAntiForgeryToken]
        //public ActionResult Create(FormCollection collection)
        public ActionResult Create(ReportAdmin model)
        {
            try
            {

                // TODO: Add insert logic here
                if (!ModelState.IsValid)
                {
                    ViewBag.Status = Common.GetSelectList(Common.SelectListType.Inactive);
                    return View(model);
                }
                using (DBManager db = new DBManager())
                {
                    int result;
                    string procedureName = "CPK.uspReportInsert";
                    List<SqlParameter> paraList = new List<SqlParameter>();
                    paraList.Add(Common.GetParameter("ReportName", DbType.String, model.ReportName, ParameterDirection.Input));
                    paraList.Add(Common.GetParameter("ReportPath", DbType.String, model.ReportPath, ParameterDirection.Input));
                    paraList.Add(Common.GetParameter("Description", DbType.String, model.Description, ParameterDirection.Input));
                    paraList.Add(Common.GetParameter("IsActive", DbType.String, model.IsActive, ParameterDirection.Input));

                    result = db.GetExecuteNonQuery(paraList, procedureName);
                }
                TempData["message"] = "Successfully Created!";
                TempData["messageType"] = "Success";
                return RedirectToAction("List");
            }
            catch
            {
                TempData["message"] = "Error occured while Creating!";
                TempData["messageType"] = "Error";
                return RedirectToAction("List");
            }
        }


        // GET: ReportView/Edit/5
        [Authorize(Roles = "Admin")]
        public ActionResult Edit(int id)
        {
            ReportAdmin reportAdmin = null;
            using (DBManager db = new DBManager())
            {
                string procedureName = "CPK.uspReportDetail";
                List<SqlParameter> paraList = new List<SqlParameter>();
                paraList.Add(Common.GetParameter("ReportID", DbType.String, id, ParameterDirection.Input));

                DataSet DbSet = db.GetSelectQuery(paraList, procedureName);
                reportAdmin = Common.DataToClass<ReportAdmin>(DbSet.Tables[0].Rows[0]);
            }
            ViewBag.Status = Common.GetSelectList(Common.SelectListType.Inactive, reportAdmin.IsActive);
            return View(reportAdmin);
        }

        // POST: ReportView/Edit/5
        [HttpPost]
        [Authorize(Roles = "Admin")]
        //public ActionResult Edit(int id, FormCollection collection)
        public ActionResult Edit(ReportAdmin model)
        {
            try
            {
                if (!ModelState.IsValid)
                {
                    ViewBag.Status = Common.GetSelectList(Common.SelectListType.Inactive);
                    return View(model);
                }
                using (DBManager db = new DBManager())
                {
                    int result;
                    string procedureName = "CPK.uspReportUpdate";
                    List<SqlParameter> paraList = new List<SqlParameter>();
                    paraList.Add(Common.GetParameter("ReportID", DbType.String, model.ReportID, ParameterDirection.Input));
                    paraList.Add(Common.GetParameter("ReportName", DbType.String, model.ReportName, ParameterDirection.Input));
                    paraList.Add(Common.GetParameter("ReportPath", DbType.String, model.ReportPath, ParameterDirection.Input));
                    paraList.Add(Common.GetParameter("Description", DbType.String, model.Description, ParameterDirection.Input));
                    paraList.Add(Common.GetParameter("IsActive", DbType.String, model.IsActive, ParameterDirection.Input));

                    result = db.GetExecuteNonQuery(paraList, procedureName);

                }
                TempData["message"] = "Successfully Updated!";
                TempData["messageType"] = "Success"; ViewBag.messageType = "Information";
                return RedirectToAction("List");
            }
            catch
            {
                TempData["message"] = "Error occured while updating!";
                TempData["messageType"] = "Error";
                return RedirectToAction("List");
            }
        }
    }
}
