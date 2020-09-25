using System;
using System.ComponentModel.DataAnnotations;

namespace DataAccess.SMDB
{
    public partial class Groups
    {
        public int Id { get; set; }
        public int GroupTypeId { get; set; }
        public string GroupTypeName { get; set; }
        public string Name { get; set; }
        public string Description { get; set; }
        public DateTimeOffset CreatedTime { get; set; }
        public DateTimeOffset UpdatedTime { get; set; }
    }
}
