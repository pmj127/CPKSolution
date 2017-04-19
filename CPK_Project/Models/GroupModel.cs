using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace CPK_Project.Models
{
    public class GroupTreeModel
    {
        [Display(Name = "Group Name")]
        public string text { get; set; }

        public int id { get; set; }

        public int parentId { get; set; }

        public string currentUserId { get; set; }

        public List<GroupTreeModel> children { get; set; }
    }

    public class GroupModel
    {
        public string groupName { get; set; }

        public string description { get; set; }

        public string isActive { get; set; }

        public int groupId { get; set; }

    }

    public class ChildGroupModel
    {
        public int groupId { get; set; }

        public int childGroupId { get; set; }
    }

    public class ReportGroupModel
    {
        public int groupId { get; set; }

        public int reportId { get; set; }
    }

    public class UserGroupModel
    {
        public int groupId { get; set; }

        public string userId { get; set; }

    }
}