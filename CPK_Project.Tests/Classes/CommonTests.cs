using Microsoft.VisualStudio.TestTools.UnitTesting;
using CPK_Project.Classes;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using CPK_Project.Models;
using System.Data.SqlClient;
using System.Data;
using System.Web.Mvc;
/// <summary>
///  common class test
/// Create: 2017-04-05
/// Author: Moonjoon Park
/// </summary>
namespace CPK_Project.Classes.Tests
{
    [TestClass()]
    public class CommonTests
    {
        /// <summary>
        /// test for make parameter list of list
        /// </summary>
        [TestMethod()]
        public void ListToParametersTest()
        {
            RegisterViewModel rv = new RegisterViewModel
            {
                Account = "1234",
                Email = "1234",
                FullName = "1234",
                Password = "1234",
                Phone = "1234",
                Status = "1234",
                UserID = "1234",
                UserRole = "1234",
                UserType = "1234"
            };
            List<RegisterViewModel> list = new List<RegisterViewModel>();
            list.Add(rv);

            List<List<SqlParameter>> result = Common.ListToParameters(list);
            Assert.IsInstanceOfType(result, typeof(List<List<SqlParameter>>));

        }
        /// <summary>
        /// test for make parameter list
        /// </summary>
        [TestMethod()]
        public void ListToParameterTest()
        {
            RegisterViewModel rv = new RegisterViewModel
            {
                Account = "1234",
                Email = "1234",
                FullName = "1234",
                Password = "1234",
                Phone = "1234",
                Status = "1234",
                UserID = "1234",
                UserRole = "1234",
                UserType = "1234"
            };


            List<SqlParameter> result = Common.ListToParameter(rv);
            Assert.IsInstanceOfType(result, typeof(List<SqlParameter>));
        }
        /// <summary>
        /// test for make parameter
        /// </summary>
        [TestMethod()]
        public void GetParameterTestWithDbType()
        {
            SqlParameter result = Common.GetParameter("test", DbType.String, "1234", ParameterDirection.Input);
            Assert.IsInstanceOfType(result, typeof(SqlParameter));
        }
        /// <summary>
        /// test for make parameter
        /// </summary>
        [TestMethod()]
        public void GetParameterTestWithType()
        {
            SqlParameter result = Common.GetParameter("test", typeof(string), "1234", ParameterDirection.Input);
            Assert.IsInstanceOfType(result, typeof(SqlParameter));
        }
        /// <summary>
        /// test for Datatable To List
        /// </summary>
        [TestMethod()]
        public void DataToListTest()
        {
            DataTable table = new DataTable();
            // Add three column objects to the table.
            DataColumn Account = new DataColumn();
            Account.DataType = System.Type.GetType("System.String");
            Account.ColumnName = "Account";
            table.Columns.Add(Account);

            DataColumn Email = new DataColumn();
            Email.DataType = System.Type.GetType("System.String");
            Email.ColumnName = "Email";
            table.Columns.Add(Email);

            DataColumn FullName = new DataColumn();
            FullName.DataType = System.Type.GetType("System.String");
            FullName.ColumnName = "FullName";
            table.Columns.Add(FullName);

            DataColumn password = new DataColumn();
            password.DataType = System.Type.GetType("System.String");
            password.ColumnName = "password";
            table.Columns.Add(password);

            DataColumn Phone = new DataColumn();
            Phone.DataType = System.Type.GetType("System.String");
            Phone.ColumnName = "Phone";
            table.Columns.Add(Phone);

            DataColumn Status = new DataColumn();
            Status.DataType = System.Type.GetType("System.String");
            Status.ColumnName = "Status";
            table.Columns.Add(Status);

            DataColumn UserRole = new DataColumn();
            UserRole.DataType = System.Type.GetType("System.String");
            UserRole.ColumnName = "UserRole";
            table.Columns.Add(UserRole);

            DataColumn UserID = new DataColumn();
            UserID.DataType = System.Type.GetType("System.String");
            UserID.ColumnName = "UserID";
            table.Columns.Add(UserID);

            DataColumn UserType = new DataColumn();
            UserType.DataType = System.Type.GetType("System.String");
            UserType.ColumnName = "UserType";
            table.Columns.Add(UserType);

            DataRow dr = table.NewRow();
            dr["Account"] = "1234";
            dr["Email"] = "1234";
            dr["FullName"] = "1234";
            dr["password"] = "1234";
            dr["Phone"] = "1234";
            dr["Status"] = "1234";
            dr["UserID"] = "1234";
            dr["UserRole"] = "1234";
            dr["UserType"] = "1234";
            table.Rows.Add(dr);

            RegisterViewModel expect = new RegisterViewModel
            {
                Account = "1234",
                Email = "1234",
                FullName = "1234",
                Password = "1234",
                Phone = "1234",
                Status = "1234",
                UserID = "1234",
                UserRole = "1234",
                UserType = "1234"
            };
            List<RegisterViewModel> result = Common.DataToList<RegisterViewModel>(table);
            Assert.AreEqual(expect.Account, result[0].Account);

        }
        /// <summary>
        /// test for Datatable To class
        /// </summary>
        [TestMethod()]
        public void DataToClassTest()
        {
            DataTable table = new DataTable();
            // Add three column objects to the table.
            DataColumn Account = new DataColumn();
            Account.DataType = System.Type.GetType("System.String");
            Account.ColumnName = "Account";
            table.Columns.Add(Account);

            DataColumn Email = new DataColumn();
            Email.DataType = System.Type.GetType("System.String");
            Email.ColumnName = "Email";
            table.Columns.Add(Email);

            DataColumn FullName = new DataColumn();
            FullName.DataType = System.Type.GetType("System.String");
            FullName.ColumnName = "FullName";
            table.Columns.Add(FullName);

            DataColumn password = new DataColumn();
            password.DataType = System.Type.GetType("System.String");
            password.ColumnName = "password";
            table.Columns.Add(password);

            DataColumn Phone = new DataColumn();
            Phone.DataType = System.Type.GetType("System.String");
            Phone.ColumnName = "Phone";
            table.Columns.Add(Phone);

            DataColumn Status = new DataColumn();
            Status.DataType = System.Type.GetType("System.String");
            Status.ColumnName = "Status";
            table.Columns.Add(Status);

            DataColumn UserRole = new DataColumn();
            UserRole.DataType = System.Type.GetType("System.String");
            UserRole.ColumnName = "UserRole";
            table.Columns.Add(UserRole);

            DataColumn UserID = new DataColumn();
            UserID.DataType = System.Type.GetType("System.String");
            UserID.ColumnName = "UserID";
            table.Columns.Add(UserID);

            DataColumn UserType = new DataColumn();
            UserType.DataType = System.Type.GetType("System.String");
            UserType.ColumnName = "UserType";
            table.Columns.Add(UserType);

            DataRow dr = table.NewRow();
            dr["Account"] = "1234";
            dr["Email"] = "1234";
            dr["FullName"] = "1234";
            dr["password"] = "1234";
            dr["Phone"] = "1234";
            dr["Status"] = "1234";
            dr["UserID"] = "1234";
            dr["UserRole"] = "1234";
            dr["UserType"] = "1234";
            table.Rows.Add(dr);

            RegisterViewModel expect = new RegisterViewModel
            {
                Account = "1234",
                Email = "1234",
                FullName = "1234",
                Password = "1234",
                Phone = "1234",
                Status = "1234",
                UserID = "1234",
                UserRole = "1234",
                UserType = "1234"
            };
            RegisterViewModel result = Common.DataToClass<RegisterViewModel>(table.Rows[0]);
            Assert.AreEqual(expect.Account, result.Account);
        }
        /// <summary>
        /// test for check empty table
        /// </summary>
        [TestMethod()]
        public void CheckEmptyTableTest()
        {

            try
            {
                DataTable table = new DataTable();
                Common.CheckEmptyTable(table, "empty");
                Assert.Fail();
            }
            catch (Exception ex)
            {
                Assert.AreEqual("empty", ex.Message);
            }
        }
        /// <summary>
        /// test for making select list
        /// </summary>
        [TestMethod()]
        public void GetSelectListTest()
        {
            SelectList result = Common.GetSelectList(Common.SelectListType.Active, "Active");
            Assert.AreEqual("Active", result.SelectedValue);
        }
    }
}