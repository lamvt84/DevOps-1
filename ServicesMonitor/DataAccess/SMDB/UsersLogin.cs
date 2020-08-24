using System;

namespace DataAccess.SMDB
{
    public partial class UsersLogin
    {
        public int Id { get; set; }
        public string UserName { get; set; }
        public string Password { get; set; }
        public DateTimeOffset CreatedTime { get; set; }
        public DateTimeOffset UpdatedTime { get; set; }
        public DateTimeOffset LastLoginTime { get; set; }
    }
}
