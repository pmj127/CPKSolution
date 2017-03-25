using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;

namespace CPK_Project.Models
{
    public class LoginModel
    {
        [Required]
        [Display(Name = "ID")]
        public string UserID { get; set; }

        [Required]
        [DataType(DataType.Password)]
        [Display(Name = "Password")]
        public string Password { get; set; }
    }

    public class UserInfoModel
    {
        [Required]
        [Display(Name = "ID")]
        [StringLength(30, ErrorMessage = "The {0} must be between {2} and {1} characters long.", MinimumLength = 5)]
        public string UserID { get; set; }
        [Required]
        [Display(Name ="Full Name")]
        [StringLength(50)]
        public string FullName { get; set; }
        [Display(Name = "Phone")]
        [StringLength(20)]
        public string Phone { get; set; }
        [Required]
        [StringLength(50)]
        [RegularExpression(@"^[a-zA-Z][\w\.-]*[a-zA-Z0-9]@[a-zA-Z0-9][\w\.-]*[a-zA-Z0-9]\.[a-zA-Z][a-zA-Z\.]*[a-zA-Z]$", ErrorMessage = "Not a valid email")]
        [Display(Name = "Email")]
        public string Email { get; set; }
        [Required]
        [StringLength(20)]
        [EmailAddress]
        //[RegularExpression(@"Admin|User",ErrorMessage ="Only Admin or User are allowed")]
        public string UserRole { get; set; }
        [Required]
        [Display(Name = "User Type")]
        [StringLength(20)]
        [RegularExpression(@"Customer|Employee|Vendor", ErrorMessage = "the {0} must be one among Customer, Employee, and Vendor ")]
        public string UserType { get; set; }
        [Required]
        [Display(Name = "Account")]
        [StringLength(50)]
        public string Account { get; set; }
        public string Status { get; set; }
    }
    public class UserRegisterInfo
    {
        public string UserID { get; set; }
        public string Password { get; set; }
        public string FullName { get; set; }
        public string Phone { get; set; }
        public string Email { get; set; }
        public string UserRole { get; set; }
        public string UserType { get; set; }
        public string Account { get; set; }
        public string Status { get; set; }
    }

    public class UserRegisterModel : UserInfoModel
    {
        [Required]
        [StringLength(30, ErrorMessage = "The {0} must be between {2} and {1} characters long.", MinimumLength = 6)]
        [Display(Name ="Password")]
        [DataType(DataType.Password)]
        public string Password { get; set; }
        [Required]
        [Display(Name = "Confirm Password")]
        [DataType(DataType.Password)]
        [Compare("Password", ErrorMessage = "The password and confirmation password do not match.")]
        public string ConfirmPassword { get; set; }
    }
}