
using CPK_Project.Models;
using System;
using System.Data;

namespace CPK_Project.Classes
{
    public static class AccountHelper
    {
        public static bool isEmpty(string s)
        {
            return (s == null || s.Length == 0) ? true : false;
        }

        public static RegisterViewModel getRegisterViewModel(DataRow row)
        {
            return new RegisterViewModel
            {
                Account = row["Account"].ToString(),
                Email = (String)row["Email"],
                FullName = (String)row["FullName"],
                Password = (String)row["password"],
                Phone = (String)row["Phone"],
                Status = (String)row["Status"],
                UserID = (String)row["UserID"],
                UserRole = (String)row["UserRole"],
                UserType = (String)row["UserType"],
            };
        }

        public static UserRegisterInfo getUserRegisterInfo(RegisterViewModel rv)
        {
            return new UserRegisterInfo
            {
                Account = rv.Account,
                Email = rv.Email,
                FullName = rv.FullName,
                Password = rv.Password,
                Phone = rv.Phone,
                Status = rv.Status,
                UserID = rv.UserID,
                UserRole = rv.UserRole,
                UserType = rv.UserType
            };
        }

        public static DataRowCollection getUserRowByID(CPK_DAL.DBManager db, string id)
        {
            var sql = "SELECT * FROM [CPK].[Users] WHERE UserID = '" + id + "'";
            return db.GetSelectQuery(sql).Tables[0].Rows; 
        }
    }
}