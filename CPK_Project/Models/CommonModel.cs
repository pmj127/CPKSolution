using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
/// <summary>
/// common model
/// Create: 2017-02-05
/// Author: Moonjoon Park
/// </summary>
namespace CPK_Project.Models
{
    public class ListViewModel<T>
    {
        public int TotalRows { get; set; }
        public int PageNo { get; set; }
        public int PageSize { get; set; }

        public List<T> Rows;

    }

    public class JsonError
    {
        public JsonError() { }
        public JsonError(string message)
        {
            this.ErrorMessage = message;
        }
        public string ErrorMessage { get; set; }
    }

    public class ReportGroup
    {
        [Required]
        public int GroupID { get; set; }
        [Required]
        public int ReportID { get; set; }
    }

    public class UserGroup
    {
        [Required]
        public int GroupID { get; set; }
        [Required]
        public string UserID { get; set; }
    }

}