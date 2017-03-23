using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Data;
using System.Configuration;
using System.Data.SqlClient;

/// <summary>
/// Team: Red Binder
/// Data Access Layer DLL for CPK Project
/// Create: 2017-02-05
/// Author: Moonjoon Park
/// </summary>

namespace CPK_DAL
{
    public class DBManager : IDisposable
    {
        #region variables
        private SqlConnection conn = null;
        private SqlCommand cmd = null;
        private SqlTransaction transaction = null;

        private string connectionString;
        private bool disposeFlag = false;
        private int commandTimeout;

        #endregion

        #region Constructor
        public DBManager(): this(ConfigurationManager.ConnectionStrings["CPK"].ConnectionString
                , Convert.ToInt32(ConfigurationManager.AppSettings["DBCommandTimeout"]))
        { }
        public DBManager(string connectionString, int commandTimeout)
        {
            this.connectionString = connectionString;
            this.commandTimeout = commandTimeout;
            GetConnection();
            GetCommand();
        }
        #endregion

        #region Connection
        private void GetConnection()
        {
            conn = new SqlConnection(connectionString);
            conn.Open();
        }
        #endregion

        #region Command
        private void GetCommand()
        {
            cmd = new SqlCommand();
        }
        private void SetCommand(string sCommandText, CommandType sCommandType)
        {
            cmd.CommandText = sCommandText;
            cmd.Connection = conn;
            cmd.CommandType = sCommandType;
            cmd.Parameters.Clear();
        }
        #endregion

        #region Transaction
        private void SetTransaction()
        {
            transaction = conn.BeginTransaction(IsolationLevel.ReadCommitted);
            cmd.Transaction = transaction;
        }
        private void CommitTrans()
        {
            transaction.Commit();
        }
        private void RollbackTrans()
        {
            transaction.Rollback();
        }
        #endregion

        #region Execute SQL
        /// <summary>
        /// Query for Select with stored procedure
        /// </summary>
        /// <param name="parameters">parameter array</param>
        /// <param name="spName">stored procedure name</param>
        /// <returns>result of select query</returns>
        public DataSet GetSelectQuery(List<SqlParameter> parameters, string spName)
        {
            SqlDataAdapter sdAdapter = null;
            DataSet dataSet = null;
            try
            {
                SetCommand(spName, CommandType.StoredProcedure);
                if(parameters != null)
                    cmd.Parameters.AddRange(parameters.ToArray());

                sdAdapter = new SqlDataAdapter(cmd);
                dataSet = new DataSet();
                sdAdapter.Fill(dataSet);

                return dataSet;
            }
            catch (Exception e)
            {
                if (sdAdapter != null) sdAdapter.Dispose();
                if (dataSet != null) dataSet.Dispose();
                throw e;
            }
        }
        public DataSet GetSelectQuery(SqlParameter parameters, string spName)
        {
            SqlDataAdapter sdAdapter = null;
            DataSet dataSet = null;
            try
            {
                SetCommand(spName, CommandType.StoredProcedure);
                if (parameters != null)
                    cmd.Parameters.Add(parameters);

                sdAdapter = new SqlDataAdapter(cmd);
                dataSet = new DataSet();
                sdAdapter.Fill(dataSet);

                return dataSet;
            }
            catch (Exception e)
            {
                if (sdAdapter != null) sdAdapter.Dispose();
                if (dataSet != null) dataSet.Dispose();
                throw e;
            }
        }
        /// <summary>
        /// Query for Select with SQL Query text
        /// </summary>
        /// <param name="sqlText">SQL Query text</param>
        /// <returns>result of select query</returns>
        public DataSet GetSelectQuery(string sqlText)
        {
            SqlDataAdapter sdAdapter = null;
            DataSet dataSet = null;
            try
            {
                SetCommand(sqlText, CommandType.Text);
                sdAdapter = new SqlDataAdapter(cmd);
                dataSet = new DataSet();
                sdAdapter.Fill(dataSet);
              
                return dataSet;
            }
            catch (Exception e)
            {
                if (sdAdapter != null) sdAdapter.Dispose();
                if (dataSet != null) dataSet.Dispose();
                throw e;
            }
        }

        /// <summary>
        /// MutilRow Query
        /// Query for insert, update, delete, merge with stored procedure
        /// </summary>
        /// <param name="parameters">parameter array</param>
        /// <param name="spName">stored procedure name</param>
        /// <returns>count of affected rows</returns>
        public int GetExecuteNonQuery(List<List<SqlParameter>> parameters, string spName)
        {
            int iResult = 0;
            SetTransaction();
            try
            {
                foreach (List<SqlParameter> para in parameters)
                {
                    iResult += GetExecuteNonQuery(para, spName);
                }
                CommitTrans();
            }
            catch(Exception ex)
            {
                RollbackTrans();
                throw ex;
            }
            return iResult;
        }

        /// <summary>
        ///  Query for insert, update, delete, merge with stored procedure
        /// </summary>
        /// <param name="parameters">parameter array</param>
        /// <param name="spName">stored procedure name</param>
        /// <returns>count of affected rows</returns>
        public int GetExecuteNonQuery(List<SqlParameter> parameters, string spName)
        {
            int iResult = 0;
            SetCommand(spName, CommandType.StoredProcedure);
            cmd.Parameters.AddRange(parameters.ToArray());
            iResult = cmd.ExecuteNonQuery();
            //if (cmd.Parameters.Contains("@SQL_OUTPUT"))
            //    iResult = Convert.ToInt32(cmd.Parameters["@SQL_OUTPUT"].Value.ToString());
            return iResult;
        }

        /// <summary>
        ///  Query for insert, update, delete, merge with stored procedure with output parameter
        /// </summary>
        /// <param name="parameters">parameter array</param>
        /// <param name="spName">stored procedure name</param>
        /// <param name="outParameterName">out put parameter name</param>
        /// <returns>string output parameter value</returns>
        public string GetExecuteNonQuery(List<SqlParameter> parameters, string spName, string outParameterName)
        {
            int iResult = 0;
            SetCommand(spName, CommandType.StoredProcedure);
            cmd.Parameters.AddRange(parameters.ToArray());
            iResult = cmd.ExecuteNonQuery();
            return cmd.Parameters["@" + outParameterName].Value.ToString();
        }
        /// <summary>
        /// Query for insert, update, delete, merge with sql query text
        /// </summary>
        /// <param name="sqlText">SQL Query text</param>
        /// <returns>count of affected row</returns>
        public int GetExecuteNonQuery(string sqlText)
        {
            int iResult = 0;
            SetCommand(sqlText, CommandType.Text);
            iResult = cmd.ExecuteNonQuery();
            return iResult;
        }
        #endregion

        #region Destructor
        public void Dispose()
        {
            if (cmd != null)
            {
                cmd.Dispose();
                cmd = null;
            }
            if (conn != null)
            {
                conn.Close();
                conn.Dispose();
                conn = null;
            }
            disposeFlag = true;
            //GC.SuppressFinalize(this);
        }
        ~ DBManager()
        {
            if (disposeFlag == false)
                this.Dispose();
        }
        #endregion
    }
}
