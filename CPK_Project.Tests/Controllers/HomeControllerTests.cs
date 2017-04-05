using Microsoft.VisualStudio.TestTools.UnitTesting;
using CPK_Project.Controllers;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Web.Mvc;
/// <summary>
/// Home Controller test
/// Create: 2017-04-05
/// Author: Moonjoon Park
/// </summary>
namespace CPK_Project.Controllers.Tests
{
    /// <summary>
    /// test for index
    /// </summary>
    [TestClass()]
    public class HomeControllerTests
    {
        [TestMethod()]
        public void HomeControllerIndexTest()
        {
            var controller = new HomeController();
            var result = controller.Index() as ViewResult;
            Assert.AreEqual("", result.ViewName);
        }
    }
}