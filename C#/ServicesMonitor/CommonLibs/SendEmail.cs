using System;
using System.Collections.Generic;
using System.Text;

namespace CommonLibs
{
    public class MailRequest
    {
        public string SenderName { get; set; }
        public string ToMail { get; set; }
        public string CCMail { get; set; }
        public string Subject { get; set; }
        public string Message { get; set; }
        public bool IsResend { get; set; }
        public int ServiceID { get; set; } 
        public int smsEMailID { get; set; }
        public int langID { get; set; }
        public string DataSign { get; set; }
    }

    public class BasicResponse
    {
        public string Result { get; set; }
        public int Status { get; set; }
        public string AddData { get; set; }
        public string DataSign { get; set; }
    }
}
