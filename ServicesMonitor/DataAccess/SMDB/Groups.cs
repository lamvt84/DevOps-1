using System;
using System.ComponentModel.DataAnnotations;

namespace DataAccess.SMDB
{
    public partial class Groups
    {
        [Key]
        public int Id { get; set; }
        [Required]
        public string Name { get; set; }
        public string Description { get; set; }
        public DateTimeOffset CreatedTime { get; set; }
        public DateTimeOffset UpdatedTime { get; set; }
    }
}
