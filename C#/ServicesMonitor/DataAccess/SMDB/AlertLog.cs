using System;
using System.Collections.Generic;
using System.Text;

namespace DataAccess.SMDB
{
    public partial class AlertLog
    {
        public int Id { get; set; }
        public string AlertType { get; set; }
        public string AlertUrl { get; set; }
        public string RequestMessage { get; set; }
        public string ResponseMessage { get; set; }
        public DateTimeOffset CreatedTime { get; set; }
    }
}
