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
                    List<GroupModel> groupList = Common.DataToList<GroupModel>(DbSet.Tables[0]);

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

        private List<GroupModel> AddNodeToParentNode(List<GroupModel> groupList, DataRow row, out bool doAdded)
        {
            doAdded = false;
            GroupModel groupNode = Common.DataToClass<GroupModel>(row);
            foreach (GroupModel oneNode in groupList)
            {
                if (oneNode.id == groupNode.parentId)
                {
                    if (oneNode.children == null)
                    {
                        oneNode.children = new List<GroupModel>();
                    }
                    oneNode.children.Add(groupNode);
                    doAdded = true;
                    break;
                }
                else
                {
                    if (oneNode.children != null)
                    {
                        foreach (GroupModel oneSubNode in oneNode.children)
                        {
                            if (oneSubNode.id == groupNode.parentId)
                            {
                                if (oneSubNode.children == null)
                                {
                                    oneSubNode.children = new List<GroupModel>();
                                }
                                oneSubNode.children.Add(groupNode);
                                doAdded = true;
                                break;
                            }
                            else
                            {
                                if (oneSubNode.children != null)
                                {
                                    foreach (GroupModel oneSub2Node in oneSubNode.children)
                                    {
                                        if (oneSub2Node.id == groupNode.parentId)
                                        {
                                            if (oneSub2Node.children == null)
                                            {
                                                oneSub2Node.children = new List<GroupModel>();
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

    }
}