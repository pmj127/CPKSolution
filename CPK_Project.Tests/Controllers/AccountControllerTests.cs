using Microsoft.VisualStudio.TestTools.UnitTesting;
using CPK_Project.Controllers;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Web.Mvc;
using Moq;

namespace CPK_Project.Controllers.Tests
{
    [TestClass()]
    public class AccountControllerTests
    {

        [TestMethod()]
        public void AccountControllerIndexTest()
        {
            var controller = new AccountController();
            var result = controller.Index() as ViewResult;
            Assert.AreEqual("", result.ViewName);
        }

        [TestMethod()]
        public void AccountControllerRegisterTest()
        {
            var controller = new AccountController();
            var result = controller.Register() as ViewResult;
            Assert.AreEqual("", result.ViewName);
        }

        [TestMethod()]
        public void AccountControllerLoginTest()
        {
            var controller = new AccountController();
            var result = controller.Login("~/Account/index") as ViewResult;
            Assert.AreEqual("", result.ViewName);
        }
    }
}