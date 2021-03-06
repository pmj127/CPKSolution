﻿using System;
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
/// common controller
/// Create: 2017-02-05
/// Author: Moonjoon Park
/// </summary>
namespace CPK_Project.Controllers
{
    public class CommonController : Controller
    {
        [HttpPost]
        [AJaxAuthorize(Roles = "Admin")]
        public JsonResult SetReportGroup(List<ReportGroup> reportGroups )
        {
            try
            {
                using (DBManager db = new DBManager())
                {
                    int result = 0;
                    string procedureName = "CPK.uspReportGroupInsert";
                    List<List<SqlParameter>> paraList = Common.ListToParameters<ReportGroup>(reportGroups);

                    result = db.GetExecuteNonQuery(paraList, procedureName);

                    return Json("Success", JsonRequestBehavior.DenyGet);
                }

            }
            catch (Exception ex)
            {
                JsonError e = new JsonError(ex.Message);
                return Json(e, JsonRequestBehavior.DenyGet);
            }

        }
        [HttpPost]
        [AJaxAuthorize(Roles = "Admin")]
        public JsonResult DeleteReportGroup(List<ReportGroup> reportGroups)
        {
            try
            {
                using (DBManager db = new DBManager())
                {
                    int result = 0;
                    string procedureName = "CPK.uspReportGroupDelete";
                    List<List<SqlParameter>> paraList = Common.ListToParameters<ReportGroup>(reportGroups);

                    result = db.GetExecuteNonQuery(paraList, procedureName);

                    return Json("Success", JsonRequestBehavior.DenyGet);
                }

            }
            catch (Exception ex)
            {
                JsonError e = new JsonError(ex.Message);
                return Json(e, JsonRequestBehavior.DenyGet);
            }

        }

        [HttpPost]
        [AJaxAuthorize(Roles = "Admin")]
        public JsonResult SetUserGroup(List<UserGroup> UserGroups)
        {
            try
            {
                using (DBManager db = new DBManager())
                {
                    int result = 0;
                    string procedureName = "CPK.uspUserGroupInsert";
                    List<List<SqlParameter>> paraList = Common.ListToParameters<UserGroup>(UserGroups);

                    result = db.GetExecuteNonQuery(paraList, procedureName);

                    return Json("Success", JsonRequestBehavior.DenyGet);
                }

            }
            catch (Exception ex)
            {
                JsonError e = new JsonError(ex.Message);
                return Json(e, JsonRequestBehavior.DenyGet);
            }

        }
        [HttpPost]
        [AJaxAuthorize(Roles = "Admin")]
        public JsonResult DeleteUserGroup(List<UserGroup> UserGroups)
        {
            try
            {
                using (DBManager db = new DBManager())
                {
                    int result = 0;
                    string procedureName = "CPK.uspUserGroupDelete";
                    List<List<SqlParameter>> paraList = Common.ListToParameters<UserGroup>(UserGroups);

                    result = db.GetExecuteNonQuery(paraList, procedureName);

                    return Json("Success", JsonRequestBehavior.DenyGet);
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