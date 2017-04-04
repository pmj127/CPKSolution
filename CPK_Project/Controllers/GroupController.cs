using CPK_DAL;
using CPK_Project.Classes;
using CPK_Project.Models;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace CPK_Project.Controllers
{
    public class GroupController : Controller
    {
        // GET: Group
        public ActionResult List()
        {




            return View();
        }

        public JsonResult GetList(int pageNo, int pageSize, string searchText, string isActive, string orderColumn, string orderDesc)
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

    }
}