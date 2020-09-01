using System;
using System.ComponentModel.DataAnnotations;

namespace DataAccess.SMDB
{
    public partial class Services
    {
        [Key]
        public int Id { get; set; }
        public int GroupId { get; set; }
        [Required]
        public string Name { get; set; }
        public string Description { get; set; }
        [Required]
        public string Url { get; set; }
        [Required]
        public string Params { get; set; }
        [Required]
        public string ResponseCode { get; set; }
        public DateTimeOffset CreatedTime { get; set; }
        public DateTimeOffset UpdatedTime { get; set; }
        public int Enable { get; set; }
        public int Status { get; set; }
    }
}
