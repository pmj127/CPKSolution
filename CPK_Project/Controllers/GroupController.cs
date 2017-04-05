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


        public ActionResult List()
        {
            return View();




        }


        public JsonResult GetList(int groupID, string userID)
        {
            try
            {
                using (DBManager db = new DBManager())
                {
                    string nameOfProcedure = "CPK.uspGroupList";
                    List<SqlParameter> paraList = new List<SqlParameter>();
                    paraList.Add(Common.GetParameter("GroupID", DbType.Int32, Convert.ToInt32(groupID), ParameterDirection.Input));
                    paraList.Add(Common.GetParameter("UserID", DbType.String, userID, ParameterDirection.Input));
                    DataSet DbSet = db.GetSelectQuery(paraList, nameOfProcedure);
                    List<GroupModel> listView = Common.DataToList<GroupModel>(DbSet.Tables[0]);
                    
                    return Json(listView, JsonRequestBehavior.AllowGet);
                }
            }
            catch (Exception ex)
            {
                JsonError e = new JsonError(ex.Message);
                return Json(e, JsonRequestBehavior.AllowGet);
            }

        }

    }
}