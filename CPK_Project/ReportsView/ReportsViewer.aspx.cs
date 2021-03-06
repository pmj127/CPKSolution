﻿using Microsoft.Reporting.WebForms;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Configuration;
using CPK_DAL;
using System.Data;
using System.Data.SqlClient;
using CPK_Project.Models;
using CPK_Project.Classes;

namespace CPK_Project.ReportView
{
    public partial class ReportsViewer : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if(User.Identity.IsAuthenticated)
            {
                if (!IsPostBack)
                {
                    try
                    {
                        ReportsViewUser report = new ReportsViewUser();
                        using (DBManager db = new DBManager())
                        {
                            DataSet DbSet;
                            if (User.IsInRole("Admin"))
                            {
                                DbSet = db.GetSelectQuery(Common.GetParameter("ReportID", DbType.Int32, Convert.ToInt32(Request["ReportID"])),"CPK.uspGetReportInfo");
                            }
                            else
                            {
                                List<SqlParameter> list = new List<SqlParameter>();
                                list.Add(Common.GetParameter("ReportID", DbType.Int32, Convert.ToInt32(Request["ReportID"])));
                                list.Add(Common.GetParameter("UserID", DbType.String, User.Identity.Name));
                                DbSet = db.GetSelectQuery(list, "CPK.uspGetReportInfoUser");
                            }

                            report = Common.DataToClass<ReportsViewUser>(DbSet.Tables[0].Rows[0]);
                        }


                        String reportServer = ConfigurationManager.AppSettings["ReportServer"].ToString();

                        reportViewer.Height = Unit.Pixel(Convert.ToInt32(Request["Height"]) - 58);
                        reportViewer.ProcessingMode = ProcessingMode.Remote;

                        reportViewer.ServerReport.ReportServerUrl = new Uri(reportServer); 
                        reportViewer.ServerReport.ReportPath = report.ReportPath;

                        try
                        {
                            if(!report.UserType.Equals("Admin"))
                                reportViewer.ServerReport.SetParameters(new ReportParameter("VenderID", report.Account.ToString()));
                        }
                        catch (Exception ex)
                        {

                        }

                        reportViewer.ServerReport.Refresh();
                    }
                    catch (Exception ex)
                    {
                        Response.Redirect("Error.html", false);
                    }
                }
            }
            else
            {
                //redirect login page
                Response.Redirect("Error.html", false);
            }
        }
    }
}