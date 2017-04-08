using Microsoft.VisualStudio.TestTools.UnitTesting;
using CPK_Project.Controllers;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Web.Mvc;

namespace CPK_Project.Controllers.Tests
{
    [TestClass()]
    public class MessageControllerTests
    {
        [TestMethod()]
        public void MessageControllerIndexTest()
        {
            var controller = new MessageController();
            var result = controller.Index() as ViewResult;
            Assert.AreEqual("", result.ViewName);
        }

        [TestMethod()]
        public void MessageControllerCreateTest()
        {
            var controller = new MessageController();
            var result = controller.Create() as ViewResult;
            Assert.AreEqual("", result.ViewName);
        }

        [TestMethod()]
        public void MessageControllerSendTest()
        {
            var controller = new MessageController();
            var result = controller.Send() as ViewResult;
            Assert.AreEqual("", result.ViewName);
        }
    }
}