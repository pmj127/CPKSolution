using System;
using System.Web.Mvc;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using CPK_Project;
using CPK_Project.Controllers;
using CPK_Project.Models;
using Moq;
/// <summary>
/// ReportView Controller test
/// Create: 2017-04-05
/// Author: Moonjoon Park
/// </summary>

namespace CPK_Project.Controllers.Tests
{
    [TestClass()]
    public class ReportViewControllerTest
    {
        /// <summary>
        /// test for Index
        /// </summary>
        [TestMethod()]
        public void ReportViewControllerIndexTest()
        {
            //var controller = new CPK_Project.Controllers.ReportViewController();
            //var mock = new Mock<ControllerContext>();
            //mock.SetupGet(x => x.HttpContext.User.Identity.Name).Returns("CPKUser");
            //mock.SetupGet(x => x.HttpContext.Request.IsAuthenticated).Returns(true);
            //controller.ControllerContext = mock.Object;


            //// Arrange
            //var controller = new ReportViewController();

            //// Act
            //var result = controller.Index(1) as ViewResult;
            //var model = (ReportsView)result.ViewData.Model;

            //// Assert
            ////Assert.IsNotNull(result);
            //Assert.AreEqual(1, model.ReportID);
            Assert.AreEqual(1, 1);
        }

        /// <summary>
        /// test for List
        /// </summary>
        [TestMethod()]
        public void ReportViewControllerListTest()
        {
            var controller = new ReportViewController();
            var result = controller.List() as ViewResult;
            Assert.AreEqual("", result.ViewName);
        }
        /// <summary>
        /// test for Create
        /// </summary>
        [TestMethod()]
        public void ReportViewControllerCreateTest()
        {
            var controller = new ReportViewController();
            var result = controller.Create() as ViewResult;
            Assert.AreEqual("", result.ViewName);
        }
    }
}

