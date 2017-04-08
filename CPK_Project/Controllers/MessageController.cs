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
/// Message controller
/// Create: 2017-04-07
/// Author: Moonjoon Park
/// </summary>
namespace CPK_Project.Controllers
{
    public class MessageController : Controller
    {
        // GET: Message
        public ActionResult Index()
        {
            return View();
        }

        [HttpPost]
        public JsonResult GetListSend(int pageNo, int pageSize, string searchText, string filterText, string orderColumn, string orderDesc)
        {
            try
            {
                using (DBManager db = new DBManager())
                {
                    string UserID = User.Identity.Name;
                    string procedureName = "CPK.uspMessageSendList";
                    List<SqlParameter> paraList = new List<SqlParameter>();
                    paraList.Add(Common.GetParameter("PageNo", DbType.Int32, Convert.ToInt32(pageNo), ParameterDirection.Input));
                    paraList.Add(Common.GetParameter("PageSize", DbType.Int32, Convert.ToInt32(pageSize), ParameterDirection.Input));
                    if (User.IsInRole("Admin"))
                        UserID = "Administrator";
                    paraList.Add(Common.GetParameter("UserID", DbType.String, UserID, ParameterDirection.Input));

                    DataSet DbSet = db.GetSelectQuery(paraList, procedureName);
                    ListViewModel<MessageSendModel> listView = Common.DataToClass<ListViewModel<MessageSendModel>>(DbSet.Tables[0].Rows[0]);
                    List<MessageSendModel> MessageList = Common.DataToList<MessageSendModel>(DbSet.Tables[1]);
                    listView.Rows = MessageList;
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
        public JsonResult GetListReceive(int pageNo, int pageSize, string searchText, string filterText, string orderColumn, string orderDesc)
        {
            try
            {
                using (DBManager db = new DBManager())
                {
                    string UserID = User.Identity.Name;
                    string procedureName = "CPK.uspMessageReceiveList";
                    List<SqlParameter> paraList = new List<SqlParameter>();
                    paraList.Add(Common.GetParameter("PageNo", DbType.Int32, Convert.ToInt32(pageNo), ParameterDirection.Input));
                    paraList.Add(Common.GetParameter("PageSize", DbType.Int32, Convert.ToInt32(pageSize), ParameterDirection.Input));
                    if (User.IsInRole("Admin"))
                        UserID = "Administrator";
                    paraList.Add(Common.GetParameter("UserID", DbType.String, UserID, ParameterDirection.Input));

                    DataSet DbSet = db.GetSelectQuery(paraList, procedureName);
                    ListViewModel<MessageReceiveModel> listView = Common.DataToClass<ListViewModel<MessageReceiveModel>>(DbSet.Tables[0].Rows[0]);
                    List<MessageReceiveModel> MessageList = Common.DataToList<MessageReceiveModel>(DbSet.Tables[1]);
                    listView.Rows = MessageList;
                    return Json(listView, JsonRequestBehavior.DenyGet);
                }
            }
            catch (Exception ex)
            {
                JsonError e = new JsonError(ex.Message);
                return Json(e, JsonRequestBehavior.DenyGet);
            }
        }
        // GET: Message/Details/5
        public ActionResult Details(int id)
        {
            MessageDetail messageDetail = null;
            using (DBManager db = new DBManager())
            {
                string UserID = User.Identity.Name;
                string procedureName = "CPK.uspMessageDetail";
                List<SqlParameter> paraList = new List<SqlParameter>();
                paraList.Add(Common.GetParameter("MessageID", DbType.String, id, ParameterDirection.Input));
                if (User.IsInRole("Admin"))
                    UserID = "Administrator";
                paraList.Add(Common.GetParameter("UserID", DbType.String, UserID, ParameterDirection.Input));
                DataSet DbSet = db.GetSelectQuery(paraList, procedureName);
                messageDetail = Common.DataToClass<MessageDetail>(DbSet.Tables[0].Rows[0]);
                if (!User.IsInRole("Admin"))
                    messageDetail.Recipients = string.Empty;
                else
                {
                    string temp = messageDetail.Recipients;
                    messageDetail.Recipients = temp.Remove(temp.Length - 1);
                }
            }
            return View(messageDetail);
        }

        // for user
        // GET: Message/Create
        public ActionResult Create()
        {
            return View();
        }

        //for user
        // POST: Message/Create
        [HttpPost]
        public ActionResult Create(MessageModel model)
        {
            try
            {
                // TODO: Add insert logic here
                if (!ModelState.IsValid)
                {
                    return View(model);
                }
                using (DBManager db = new DBManager())
                {
                    int result;
                    string procedureName = "CPK.uspMessageUserInsert";
                    List<SqlParameter> paraList = new List<SqlParameter>();
                    paraList.Add(Common.GetParameter("Title", DbType.String, model.Title, ParameterDirection.Input));
                    paraList.Add(Common.GetParameter("Content", DbType.String, model.Content, ParameterDirection.Input));
                    paraList.Add(Common.GetParameter("UserID", DbType.String, User.Identity.Name, ParameterDirection.Input));
                    paraList.Add(Common.GetParameter("Recipient", DbType.String, "Administrator", ParameterDirection.Input));

                    result = db.GetExecuteNonQuery(paraList, procedureName);
                }
                TempData["message"] = "Successfully Created!";
                TempData["messageType"] = "Success";
                return RedirectToAction("Index");
            }
            catch
            {
                TempData["message"] = "Error occured while Creating!";
                TempData["messageType"] = "Error";
                return RedirectToAction("Index");
            }
        }


        // GET: Message/Create
        [Authorize(Roles = "Admin")]
        public ActionResult Send()
        {
            return View();
        }
        //for user
        // POST: Message/Create
        [HttpPost]
        [Authorize(Roles = "Admin")]
        public ActionResult Send(MessageSendModel model)
        {
            try
            {
                // TODO: Add insert logic here
                if (!ModelState.IsValid)
                {
                    return View(model);
                }
                using (DBManager db = new DBManager())
                {
                    int result;
                    string sXml = model.UserID.ToString();
                    sXml = sXml.Remove(sXml.Length - 1, 1);
                    sXml = sXml.Replace(";", "</ID><ID>");
                    sXml = "<IDs><ID>" + sXml + "</ID></IDs>";
                    string procedureName = "CPK.uspMessageInsert";
                    List<SqlParameter> paraList = new List<SqlParameter>();
                    paraList.Add(Common.GetParameter("Title", DbType.String, model.Title, ParameterDirection.Input));
                    paraList.Add(Common.GetParameter("Content", DbType.String, model.Content, ParameterDirection.Input));
                    paraList.Add(Common.GetParameter("UserID", DbType.String, "Administrator", ParameterDirection.Input));
                    paraList.Add(Common.GetParameter("Recipient", DbType.String, sXml, ParameterDirection.Input));

                    result = db.GetExecuteNonQuery(paraList, procedureName);
                }
                TempData["message"] = "Successfully Created!";
                TempData["messageType"] = "Success";
                return RedirectToAction("Index");
            }
            catch
            {
                TempData["message"] = "Error occured while Creating!";
                TempData["messageType"] = "Error";
                return RedirectToAction("Index");
            }
        }

    }
}
