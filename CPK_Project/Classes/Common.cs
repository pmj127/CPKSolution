using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Data;
using System.Linq;
using System.Web;
using System.Reflection;
using System.Web.UI.WebControls;
using CPK_Project.Models;
using System.Security.Cryptography;
using System.Text;
using System.Configuration;
using System.Globalization;
using System.IO;
using System.Web.Mvc;

/// <summary>
/// Team: Red Binder
/// Common class for static function
/// Create: 2017-02-05
/// Author: Moonjoon Park
/// </summary>
/// 
namespace CPK_Project.Classes
{
    static class Common
    {
        #region Database
        /// <summary>
        /// list for changing properties in class for paramaters
        /// </summary>
        /// <typeparam name="T">any class in model</typeparam>
        /// <param name="list">generic list for classes</param>
        /// <returns></returns>
        public static List<List<SqlParameter>> ListToParameters<T>(List<T> list) where T: class
        {
            List<List<SqlParameter>> returnlist = new List<List<SqlParameter>>();
            foreach (T mClass in list)
            {
                returnlist.Add(ListToParameter<T>(mClass));
            }
            return returnlist;
        }

        /// <summary>
        /// change properties in class for paramaters
        /// </summary>
        /// <typeparam name="T">any class in model</typeparam>
        /// <param name="modelClass">class in model</param>
        /// <returns></returns>
        public static List<SqlParameter> ListToParameter<T>(T modelClass) where T : class
        {
            List<SqlParameter> parameters = new List<SqlParameter>();
            foreach (var property in modelClass.GetType().GetProperties())
            {
                try
                {
                    PropertyInfo propertyInfo = modelClass.GetType().GetProperty(property.Name);
                    parameters.Add(GetParameter(property.Name, propertyInfo.PropertyType, 
                        propertyInfo.GetValue(modelClass)));
                }
                catch
                {
                    continue;
                }
            }

            return parameters;
        }

        /// <summary>
        /// map sqlParameter
        /// </summary>
        /// <param name="parameterName"></param>
        /// <param name="Type"></param>
        /// <param name="parameterValue"></param>
        /// <param name="parameterDirection"></param>
        /// <returns>parameter</returns>
        public static SqlParameter GetParameter(string parameterName, Type type, 
            object parameterValue, ParameterDirection parameterDirection = ParameterDirection.Input)
        {
            return GetParameter(parameterName, Parameter.ConvertTypeCodeToDbType(Type.GetTypeCode(type)),
                parameterValue, parameterDirection);
        }
        public static SqlParameter GetParameter(string parameterName, DbType type,
            object parameterValue, ParameterDirection parameterDirection = ParameterDirection.Input)
        {
            SqlParameter parameter = new SqlParameter("@" + parameterName, type);
            parameter.Direction = parameterDirection;
            parameter.Value = parameterValue;

            return parameter;
        }
        /// <summary>
        /// map sqlParameter
        /// </summary>
        /// <typeparam name="T">any class in model</typeparam>
        /// <param name="parameterName"></param>
        /// <param name="modelClass">T</param>
        /// <param name="parameterDirection"></param>
        /// <returns></returns>
        public static SqlParameter GetParameter<T>(string parameterName, T modelClass,
            ParameterDirection parameterDirection = ParameterDirection.Input) where T : class
        {
            PropertyInfo propertyInfo = modelClass.GetType().GetProperty(parameterName);
            return GetParameter(propertyInfo.Name, propertyInfo.PropertyType,
                        propertyInfo.GetValue(modelClass), parameterDirection);
        }

        /// <summary>
        /// list for change datarows for class in model
        /// </summary>
        /// <typeparam name="T">any class in model</typeparam>
        /// <param name="table">data table</param>
        /// <returns></returns>
        public static List<T> DataToList<T>(DataTable table) where T : class, new()
        {
            try
            {
                List<T> list = new List<T>();

                //foreach (var row in table.AsEnumerable())
                foreach (DataRow row in table.AsEnumerable())
                {
                    //T modelClass = new T();

                    //foreach (var property in modelClass.GetType().GetProperties())
                    //{
                    //    try
                    //    {
                    //        PropertyInfo propertyInfo = modelClass.GetType().GetProperty(property.Name);
                    //        propertyInfo.SetValue(modelClass, Convert.ChangeType(row[property.Name], propertyInfo.PropertyType), null);
                    //    }
                    //    catch
                    //    {
                    //        continue;
                    //    }
                    //}

                    list.Add(DataToClass<T>(row));
                }

                return list;
            }
            catch
            {
                return null;
            }
        }
        public static T DataToClass<T>(DataRow row) where T : class, new()
        {
            try
            {
                T modelClass = new T();
                foreach (var property in modelClass.GetType().GetProperties())
                {
                    try
                    {
                        PropertyInfo propertyInfo = modelClass.GetType().GetProperty(property.Name);
                        propertyInfo.SetValue(modelClass, Convert.ChangeType(row[property.Name], propertyInfo.PropertyType), null);
                    }
                    catch
                    {
                        continue;
                    }
                }
                return modelClass;
            }
            catch
            {
                return null;
            }
        }

        /// <summary>
        /// method for checking dataTable rows
        /// if rows is 0 or null, raise execption
        /// </summary>
        /// <param name="dt">datatable</param>
        /// <param name="errorMessage">retrun error message</param>
        public static void CheckEmptyTable(DataTable dt, string errorMessage)
        {
            if (dt == null || dt.Rows.Count == 0)
            {
                throw new Exception(errorMessage);
            }
        }
        #endregion

        #region security
        public static string GetHash(string value)
        {
            byte[] data;
            using (MD5 md5Hash = MD5.Create())
            {
                data = md5Hash.ComputeHash(Encoding.UTF8.GetBytes(ConfigurationManager.AppSettings["salt"] + value));
            }
            StringBuilder sBulider = new StringBuilder();
            for(int i =0; i < data.Length; i++)
            {
                sBulider.Append(data[i].ToString("x2"));
            }

            return sBulider.ToString().ToUpper();
        }
        public static bool VerifyHash(string input, string hash)
        {
            string hashOfInput = GetHash(input);

            StringComparer comparer = StringComparer.OrdinalIgnoreCase;

            if (0 == comparer.Compare(hashOfInput, hash))
            {
                return true;
            }
            else
            {
                return false;
            }
        }

        // This size of the IV (in bytes) must = (keysize / 8).  Default keysize is 256, so the IV must be
        // 32 bytes long.  Using a 16 character string here gives us 32 bytes when converted to a byte array.
        // This constant is used to determine the keysize of the encryption algorithm
        private const int keysize = 256;
        private const string passPhrase = "^dfe%4Fgh*vf";
        //Encrypt
        public static string Encrypt(string plainText)
        {
            string initVector = ConfigurationManager.AppSettings["CBCKey"];
            byte[] initVectorBytes = Encoding.UTF8.GetBytes(initVector);
            byte[] plainTextBytes = Encoding.UTF8.GetBytes(plainText);
            PasswordDeriveBytes password = new PasswordDeriveBytes(passPhrase, null);
            byte[] keyBytes = password.GetBytes(keysize / 8);
            RijndaelManaged symmetricKey = new RijndaelManaged();
            symmetricKey.Mode = CipherMode.CBC;
            ICryptoTransform encryptor = symmetricKey.CreateEncryptor(keyBytes, initVectorBytes);
            MemoryStream memoryStream = new MemoryStream();
            CryptoStream cryptoStream = new CryptoStream(memoryStream, encryptor, CryptoStreamMode.Write);
            cryptoStream.Write(plainTextBytes, 0, plainTextBytes.Length);
            cryptoStream.FlushFinalBlock();
            byte[] cipherTextBytes = memoryStream.ToArray();
            memoryStream.Close();
            cryptoStream.Close();
            return Convert.ToBase64String(cipherTextBytes);
        }
        //Decrypt
        public static string Decrypt(string cipherText)
        {
            string initVector = ConfigurationManager.AppSettings["CBCKey"];
            byte[] initVectorBytes = Encoding.ASCII.GetBytes(initVector);
            byte[] cipherTextBytes = Convert.FromBase64String(cipherText);
            PasswordDeriveBytes password = new PasswordDeriveBytes(passPhrase, null);
            byte[] keyBytes = password.GetBytes(keysize / 8);
            RijndaelManaged symmetricKey = new RijndaelManaged();
            symmetricKey.Mode = CipherMode.CBC;
            ICryptoTransform decryptor = symmetricKey.CreateDecryptor(keyBytes, initVectorBytes);
            MemoryStream memoryStream = new MemoryStream(cipherTextBytes);
            CryptoStream cryptoStream = new CryptoStream(memoryStream, decryptor, CryptoStreamMode.Read);
            byte[] plainTextBytes = new byte[cipherTextBytes.Length];
            int decryptedByteCount = cryptoStream.Read(plainTextBytes, 0, plainTextBytes.Length);
            memoryStream.Close();
            cryptoStream.Close();
            return Encoding.UTF8.GetString(plainTextBytes, 0, decryptedByteCount);
        }
        #endregion
        /// <summary>
        /// make selectlist
        /// </summary>
        /// <param name="type">SelectListType</param>
        /// <returns>selectlist</returns>
        # region SelectList return
        public static SelectList GetSelectList(SelectListType type)
        {
            List<SelectListItem> SelectListITems = new List<SelectListItem>();
            switch (type)
            {

                case SelectListType.Waiting:
                    SelectListITems.Add(new SelectListItem { Text = "Active", Value = "A" });
                    SelectListITems.Add(new SelectListItem { Text = "Inactive", Value = "I" });
                    SelectListITems.Add(new SelectListItem { Text = "Wating", Value = "W" });
                    break;
                case SelectListType.Inactive:
                    SelectListITems.Add(new SelectListItem { Text = "Active", Value = "A" });
                    SelectListITems.Add(new SelectListItem { Text = "Inactive", Value = "I" });
                    break;
                case SelectListType.Active:
                    SelectListITems.Add(new SelectListItem { Text = "Active", Value = "A" });
                    break;
            }

            return new SelectList(SelectListITems, "Value", "Text");
        }
        
        public enum SelectListType
        {
            Active,
            Inactive,
            Waiting
        }
        #endregion
    }
}