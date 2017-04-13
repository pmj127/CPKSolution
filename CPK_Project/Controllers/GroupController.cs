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
/// <summary>
/// Group controller
/// Create: 2017-04-02
/// Author: Yoonsuk Cho
/// </summary>
namespace CPK_Project.Controllers
{
    public class GroupController : Controller
    {

        [Authorize]
        public ActionResult Reports()
        {
            return View();

        }

        [Authorize]
        public ActionResult List()
        {
            return View();

        }

        [Authorize]
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
                    List<GroupTreeModel> groupList = Common.DataToList<GroupTreeModel>(DbSet.Tables[0]);

                    DataTable table = DbSet.Tables[1];
                    int rowCnt = table.Rows.Count;
                    for (int i = 0; i < table.Rows.Count; i++)
                    {
                        bool doAdded = false;
                        DataRow row = table.Rows[i];
                        groupList = AddNodeToParentNode(groupList, row, out doAdded);
                        if (doAdded)
                        {
                            table.Rows.Remove(row);
                            i--;
                        }
                    }
                    rowCnt = table.Rows.Count;

                    JsonResult jResult = Json(groupList, JsonRequestBehavior.AllowGet);
                    return jResult;
                }
            }
            catch (Exception ex)
            {
                JsonError e = new JsonError(ex.Message);
                return Json(e, JsonRequestBehavior.AllowGet);
            }

        }

        private List<GroupTreeModel> AddNodeToParentNode(List<GroupTreeModel> groupList, DataRow row, out bool doAdded)
        {
            doAdded = false;
            GroupTreeModel groupNode = Common.DataToClass<GroupTreeModel>(row);
            foreach (GroupTreeModel oneNode in groupList)
            {
                if (oneNode.id == groupNode.parentId)
                {
                    if (oneNode.children == null)
                    {
                        oneNode.children = new List<GroupTreeModel>();
                    }
                    oneNode.children.Add(groupNode);
                    doAdded = true;
                    break;
                }
                else
                {
                    if (oneNode.children != null)
                    {
                        foreach (GroupTreeModel oneSubNode in oneNode.children)
                        {
                            if (oneSubNode.id == groupNode.parentId)
                            {
                                if (oneSubNode.children == null)
                                {
                                    oneSubNode.children = new List<GroupTreeModel>();
                                }
                                oneSubNode.children.Add(groupNode);
                                doAdded = true;
                                break;
                            }
                            else
                            {
                                if (oneSubNode.children != null)
                                {
                                    foreach (GroupTreeModel oneSub2Node in oneSubNode.children)
                                    {
                                        if (oneSub2Node.id == groupNode.parentId)
                                        {
                                            if (oneSub2Node.children == null)
                                            {
                                                oneSub2Node.children = new List<GroupTreeModel>();
                                            }
                                            oneSub2Node.children.Add(groupNode);
                                            doAdded = true;
                                            break;
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
            return groupList;

        }

        [Authorize]
        public int Add(string groupName, string description, string parentGroup)
        {
            int returnValue = -1;

            if (ModelState.IsValid)
            {
                try
                {
                    using (DBManager db = new DBManager())
                    {

                        List<SqlParameter> paraList = new List<SqlParameter>();
                        paraList.Add(Common.GetParameter("GroupName", DbType.String, groupName, ParameterDirection.Input));
                        paraList.Add(Common.GetParameter("Description", DbType.String, description, ParameterDirection.Input));
                        paraList.Add(Common.GetParameter("ParentGroup", DbType.String, parentGroup, ParameterDirection.Input));

                        returnValue = db.GetExecuteNonQuery(paraList, "CPK.uspGroupAdd");

                    }
                }
                catch (Exception ex)
                {
                    ModelState.AddModelError("", ex.Message);
                }
            }
            // If we got this far, something failed, redisplay form
            return returnValue;
        }


        [Authorize]
        public int Remove(string selectedGroup)
        {
            int returnValue = -1;
            if (ModelState.IsValid)
            {
                try
                {
                    using (DBManager db = new DBManager())
                    {

                        List<SqlParameter> paraList = new List<SqlParameter>();
                        paraList.Add(Common.GetParameter("SelectedGroup", DbType.Int32, Convert.ToInt32(selectedGroup), ParameterDirection.Input));

                        returnValue = db.GetExecuteNonQuery(paraList, "CPK.uspGroupRemove");

                    }
                }
                catch (Exception ex)
                {
                    ModelState.AddModelError("", ex.Message);
                }
            }
            // If we got this far, something failed, redisplay form
            return returnValue;
        }

        [Authorize]
        public int AddReport(string groupID, string reportID)
        {
            int returnValue = -1;

            if (ModelState.IsValid)
            {
                try
                {
                    using (DBManager db = new DBManager())
                    {

                        List<SqlParameter> paraList = new List<SqlParameter>();
                        paraList.Add(Common.GetParameter("GroupID", DbType.String, groupID, ParameterDirection.Input));
                        paraList.Add(Common.GetParameter("ReportID", DbType.String, reportID, ParameterDirection.Input));

                        returnValue = db.GetExecuteNonQuery(paraList, "CPK.uspGroupReportAdd");

                    }
                }
                catch (Exception ex)
                {
                    ModelState.AddModelError("", ex.Message);
                }
            }
            // If we got this far, something failed, redisplay form
            return returnValue;
        }


        [Authorize]
        public int RemoveReport(string groupID, string reportID)
        {
            int returnValue = -1;
            if (ModelState.IsValid)
            {
                try
                {
                    using (DBManager db = new DBManager())
                    {

                        List<SqlParameter> paraList = new List<SqlParameter>();
                        paraList.Add(Common.GetParameter("GroupID", DbType.String, groupID, ParameterDirection.Input));
                        paraList.Add(Common.GetParameter("ReportID", DbType.String, reportID, ParameterDirection.Input));

                        returnValue = db.GetExecuteNonQuery(paraList, "CPK.uspGroupReportRemove");

                    }
                }
                catch (Exception ex)
                {
                    ModelState.AddModelError("", ex.Message);
                }
            }
            // If we got this far, something failed, redisplay form
            return returnValue;
        }

        [Authorize]
        public int AddUser(string groupID, string userID)
        {
            int returnValue = -1;

            if (ModelState.IsValid)
            {
                try
                {
                    using (DBManager db = new DBManager())
                    {

                        List<SqlParameter> paraList = new List<SqlParameter>();
                        paraList.Add(Common.GetParameter("GroupID", DbType.String, groupID, ParameterDirection.Input));
                        paraList.Add(Common.GetParameter("UserID", DbType.String, userID, ParameterDirection.Input));

                        returnValue = db.GetExecuteNonQuery(paraList, "CPK.uspGroupUserAdd");

                    }
                }
                catch (Exception ex)
                {
                    ModelState.AddModelError("", ex.Message);
                }
            }
            // If we got this far, something failed, redisplay form
            return returnValue;
        }


        [Authorize]
        public int RemoveUser(string groupID, string userID)
        {
            int returnValue = -1;
            if (ModelState.IsValid)
            {
                try
                {
                    using (DBManager db = new DBManager())
                    {

                        List<SqlParameter> paraList = new List<SqlParameter>();
                        paraList.Add(Common.GetParameter("GroupID", DbType.String, groupID, ParameterDirection.Input));
                        paraList.Add(Common.GetParameter("UserID", DbType.String, userID, ParameterDirection.Input));

                        returnValue = db.GetExecuteNonQuery(paraList, "CPK.uspGroupUserRemove");

                    }
                }
                catch (Exception ex)
                {
                    ModelState.AddModelError("", ex.Message);
                }
            }
            // If we got this far, something failed, redisplay form
            return returnValue;
        }

    }
}