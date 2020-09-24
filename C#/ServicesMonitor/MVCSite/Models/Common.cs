using System;
using System.Security.Cryptography;
using System.Text;

namespace MVCSite.Models
{
    public class ExtendSettings
    {
        public string SecureKey { get; set; }
        public string SendMailUrl { get; set; }
        public string SendSmsUrl { get; set; }
    }

    public static class Encryption
    {
        public static string Md5Hash(string input)
        {
            using var md5Hash = MD5.Create();
            // Byte array representation of source string
            var sourceBytes = Encoding.UTF8.GetBytes(input);

            // Generate hash value(Byte Array) for input data
            var hashBytes = md5Hash.ComputeHash(sourceBytes);

            // Convert hash byte array to string
            var hash = BitConverter.ToString(hashBytes).Replace("-", string.Empty);

            // Output the MD5 hash
            return hash;
        }
    }
}
