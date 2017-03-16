using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;

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

}