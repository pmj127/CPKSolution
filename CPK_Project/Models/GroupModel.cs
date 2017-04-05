using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace CPK_Project.Models
{
    public class GroupModel
    {
        [Display(Name = "Group Name")]
        public string text { get; set; }

        public int id { get; set; }

        public GroupModel children { get; set; }
    }
}