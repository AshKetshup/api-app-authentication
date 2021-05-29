using System;
using System.IO;
using System.Linq;
using System.Security.Cryptography;
using System.Text;

namespace AppApiAuthenticator {
    
    internal static class Crypto {

        /// <summary>
        /// Calculates the SHA256 of a string
        /// </summary>
        /// <param name="text">String from which will be generate the hash</param>
        /// <returns></returns>
        internal static string calculateSha256(string text)
        {
            string hashString = string.Empty;
            
            using (SHA256Managed hasher = new SHA256Managed())
            {
                byte[] bytes = Encoding.UTF8.GetBytes(text);
                byte[] hash = hasher.ComputeHash(bytes);
                foreach (byte x in hash) {
                    hashString += String.Format("{0:x2}", x);
                }
            }
            return hashString;
        }

        /// <summary>
        /// Calculates the HMAC-SHA256 of a string
        /// </summary>
        /// <param name="text">The string from which will be calculated the authenticated message</param>
        /// <param name="key">The key to create the authenticated message</param>
        /// <returns></returns>
        internal static string calculateHMACSha256(string text, string key) {
            byte[] _key = Encoding.UTF8.GetBytes(key);
            using (HMACSHA256 hasher = new HMACSHA256(_key)) {
                byte[] byteArray = Encoding.UTF8.GetBytes(text);
                using (MemoryStream stream = new MemoryStream(byteArray))
                    return hasher.ComputeHash(stream).Aggregate("", (s, e) => s + String.Format("{0:x2}",e), s => s );
            }
        }

    }

}