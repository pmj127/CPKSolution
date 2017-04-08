using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
/// <summary>
/// Message Model
/// Create: 2017-04-07
/// Author: Moonjoon Park
/// </summary>

namespace CPK_Project.Models
{
    public class MessageModel
    {

        [Display(Name = "Message ID")]
        public int MessageID { get; set; }

        [Required]
        [StringLength(100, ErrorMessage = "The {0} must be between {2} and {1} characters long.", MinimumLength = 1)]
        public string Title { get; set; }

        [Required]
        [DataType(DataType.MultilineText)]
        [StringLength(1000, ErrorMessage = "The {0} must be between {2} and {1} characters long.", MinimumLength = 1)]
        public string Content { get; set; }
    }

    public class MessageSendModel: MessageModel
    {

        [Required]
        [Display(Name = "Recipients")]
        [DataType(DataType.MultilineText)]
        public string UserID { get; set; }

       
        [Display(Name = "Send Date")]
        public string SendDate { get; set; }
    }

    public class MessageReceiveModel: MessageModel
    {

        [Required]
        [Display(Name = "Sender")]
        public string UserID { get; set; }
        [Required]
        [Display(Name = "Receive Date")]
        public string ReceiveDate { get; set; }

        [Display(Name = "Read Date")]
        public string ReadDate { get; set; }
    }

    public class MessageDetail: MessageModel
    {
        [Required]
        [Display(Name = "Sender")]
        public string UserID { get; set; }

        [Required]
        [Display(Name = "Recipients")]
        [DataType(DataType.MultilineText)]
        public string Recipients { get; set; }

        [Required]
        [Display(Name = "Sent/Received")]
        public string SendDate { get; set; }
    }
}