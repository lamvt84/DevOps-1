using System;
using System.ComponentModel.DataAnnotations;

namespace DataAccess.SMDB
{
    public partial class ServicesLog
    {
        [Key]
        public long Id { get; set; }
        public System.Guid JournalGuid { get; set; }
        public DateTimeOffset CreatedTime { get; set; }
        public int ServiceId { get; set; }
        public string ServiceUrl { get; set; }
        public string ServiceStatus { get; set; }
    }
}