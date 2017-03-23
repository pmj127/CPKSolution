using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;

namespace CPK_Project.Models
{
    public class ReportModel
    {
  
        [Display(Name ="Report ID")]
        public int ReportID { get; set; }
        [Required]
        [Display(Name = "Report Name")]
        [StringLength(50, ErrorMessage = "The {0} must be between {2} and {1} characters long.", MinimumLength = 3)]
        public string ReportName { get; set; }

        [Display(Name = "Description")]
        [DataType(DataType.MultilineText)]
        [StringLength(400)]
        public string Description { get; set; }
        [Required]
        [Display(Name = "Report Path")]
        [StringLength(100, ErrorMessage = "The {0} must be between {2} and {1} characters long.", MinimumLength = 3)]
        public string ReportPath { get; set; }

    }

    public class ReportsView : ReportModel
    {
        public int? Width { get; set; }
        public int? Height { get; set; }

        [Required]
        public string ViewerURL { get; set; }
    }

    public class ReportAdmin : ReportModel
    {
        [Required(ErrorMessage ="The {0} field must be selected")]
        [Display(Name ="Status")]
        public string IsActive { get; set; }
        public string ModifyDate { get; set; }
    }

}