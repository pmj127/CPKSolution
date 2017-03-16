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

namespace CPK_Project.Controllers
{
    [AJaxAuthorize]
    public class ReportViewController : Controller
    {
        public ActionResult Index(int reportID, int width, int height)
        {
            var reporstView = new ReportsView
            {
                ReportID = reportID,
                Width = width,
                Height = height,
                ViewerURL = String.Format("ReportsView/ReportsViewer.aspx?ReportID={0}&Height={1}", reportID, height)
            };
            return View(reporstView);
        }

        [HttpPost]
        [AJaxAuthorize(Roles = "Admin")]
        public JsonResult GetList(int pageNo, int pageSize, string searchText, string isActive, string orderColumn, string orderDesc)
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
                    paraList.Add(Common.GetParameter("IsActive", DbType.String, isActive, ParameterDirection.Input));
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
        // GET: ReportView/Details/5
        public ActionResult List()
        {
            return View();
        }
        // GET: ReportView/Details/5
        public ActionResult Details(int id)
        {
            return View();
        }

        // GET: ReportView/Create
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
                    string procedureName = "CPK.uspInsertReport";
                    List<SqlParameter> paraList = new List<SqlParameter>();
                    paraList.Add(Common.GetParameter("ReportName", DbType.String, model.ReportName, ParameterDirection.Input));
                    paraList.Add(Common.GetParameter("ReportPath", DbType.String, model.ReportPath, ParameterDirection.Input));
                    paraList.Add(Common.GetParameter("Description", DbType.String, model.Description, ParameterDirection.Input));
                    paraList.Add(Common.GetParameter("IsActive", DbType.String, model.IsActive, ParameterDirection.Input));

                    result = db.GetExecuteNonQuery(paraList, procedureName);
                }

                return RedirectToAction("List");
            }
            catch
            {
                return View();
            }
        }


        // GET: ReportView/Edit/5
        public ActionResult Edit(int id)
        {
            return View();
        }

        // POST: ReportView/Edit/5
        [HttpPost]
        public ActionResult Edit(int id, FormCollection collection)
        {
            try
            {
                // TODO: Add update logic here

                return RedirectToAction("Index");
            }
            catch
            {
                return View();
            }
        }

        // GET: ReportView/Delete/5
        public ActionResult Delete(int id)
        {
            return View();
        }

        // POST: ReportView/Delete/5
        [HttpPost]
        public ActionResult Delete(int id, FormCollection collection)
        {
            try
            {
                // TODO: Add delete logic here

                return RedirectToAction("Index");
            }
            catch
            {
                return View();
            }
        }
    }
}
