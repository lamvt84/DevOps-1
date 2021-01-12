using System;
using System.Collections.Generic;
using System.Text;

namespace DataAccess.SMDB
{
    public partial class EmailConfig
    {
        public int Id { get; set; }
        public int AlertConfigId { get; set; }
        public string SenderName { get; set; }
        public string ToMail { get; set; }
        public string CCMail { get; set; }
        public string Subject { get; set; }
        public string Message { get; set; }
        public bool IsResend { get; set; }
        public int ServiceId { get; set; }
        public int SmsEmailId { get; set; }
        public int LangId { get; set; }
        public string DataSign { get; set; }
        public bool IsEnable { get; set; }
        public DateTimeOffset CreatedTime { get; set; }
        public DateTimeOffset UpdatedTime { get; set; }
    }
}
