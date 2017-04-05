using Microsoft.VisualStudio.TestTools.UnitTesting;
using CPK_Project.Controllers;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Web.Mvc;
using Moq;
/// <summary>
///  Account Controller test
/// Create: 2017-04-05
/// Author: Moonjoon Park
/// </summary>
namespace CPK_Project.Controllers.Tests
{
    [TestClass()]
    public class AccountControllerTests
    {
        /// <summary>
        /// test for index
        /// </summary>
        [TestMethod()]
        public void AccountControllerIndexTest()
        {
            var controller = new AccountController();
            var result = controller.Index() as ViewResult;
            Assert.AreEqual("", result.ViewName);
        }
        /// <summary>
        /// test for register
        /// </summary>
        [TestMethod()]
        public void AccountControllerRegisterTest()
        {
            var controller = new AccountController();
            var result = controller.Register() as ViewResult;
            Assert.AreEqual("", result.ViewName);
        }
        /// <summary>
        /// test for login
        /// </summary>
        [TestMethod()]
        public void AccountControllerLoginTest()
        {
            var controller = new AccountController();
            var result = controller.Login("~/Account/index") as ViewResult;
            Assert.AreEqual("", result.ViewName);
        }
    }
}