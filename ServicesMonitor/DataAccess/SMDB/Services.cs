﻿using System;

namespace DataAccess.SMDB
{
    public partial class Services
    {
        public int Id { get; set; }
        public int GroupId { get; set; }
        public string Name { get; set; }
        public string Description { get; set; }
        public string Url { get; set; }
        public string Params { get; set; }
        public string ResponseCode { get; set; }
        public DateTimeOffset CreatedTime { get; set; }
        public DateTimeOffset UpdatedTime { get; set; }
        public int Enable { get; set; }
        public int Status { get; set; }
    }
}
