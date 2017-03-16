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
            string a = Common.Encrypt("CPKUser");
            //List<Address> addressList = null;
            //List<List<SqlParameter>> paras = null;
            //List<SqlParameter> paraList = new List<SqlParameter>();

            //using (DBManager db = new DBManager())
            //{
            //    paraList.Add(Common.GetParameter("PostalCode", DbType.String, "98028", ParameterDirection.Input));
            //    DataSet DbSet =  db.GetSelectQuery(paraList, "Person.uspGetAddress1");
            //    addressList = Common.DataToList<Address>(DbSet.Tables[0]);
            //    paras = Common.ListToParameters(addressList);
            //    paraList.Add(Common.GetParameter(nameof(Address.AddressID), addressList[0]));
            //    paraList.Add(Common.GetParameter("test", DbType.Int16, 3, ParameterDirection.Input));
            //}
            return View();
        }


    }
}