using System;
using System.Collections.Generic;
using System.Text;

namespace DataAccess.SMDB
{
    public partial class TaskSchedulerLog
    {
        public int Id { get; set; }
        public string Source { get; set; }
        public string Name { get; set; }
        public DateTimeOffset CreatedTime { get; set; }
        public int Duration { get; set; }
    }
}
