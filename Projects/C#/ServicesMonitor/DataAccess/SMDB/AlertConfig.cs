using System;
using System.Collections.Generic;
using System.Text;

namespace DataAccess.SMDB
{
    public partial class AlertConfig
    {
        public int Id { get; set; }
        public string Name { get; set; }
        public int PauseStatus { get; set; }
        public int PausePeriod { get; set; }
        public DateTimeOffset CreatedTime { get; set; }
        public DateTimeOffset UpdatedTime { get; set; }
    }
}
