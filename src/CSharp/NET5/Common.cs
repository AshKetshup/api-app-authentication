using System.Collections.Generic;
using System.ComponentModel;

namespace AppApiAuthenticator {
    
    /// <summary>
    /// Class containing shared methods and enums
    /// </summary>
    public static class Common {

        /// <summary>
        /// The allowed methods for requests with body
        /// </summary>
        public enum PostMethods {
            /// <summary>
            /// Method POST
            /// </summary>
            [Description("POST")]
            POST,
            /// <summary>
            /// Method PATCH
            /// </summary>
            [Description("PATCH")]
            PATCH,
            /// <summary>
            /// Method PUT
            /// </summary>
            [Description("PUT")]
            PUT
        }

        /// <summary>
        /// The allowed methods for requests without body
        /// </summary>
        public enum GetMethods {
            /// <summary>
            /// Method GET
            /// </summary>
            [Description("GET")]
            GET,
            /// <summary>
            /// Method HEAD
            /// </summary>
            [Description("HEAD")]
            HEAD,
            /// <summary>
            /// Method DELETE
            /// </summary>
            [Description("DELETE")]
            DELETE
        }

        /// <summary>
        /// Replaces the signature format with the proper signature values 
        /// The signature format must be passed as reference to it's done "in place" thus not returning any value
        /// </summary>
        /// <param name="signature">The signature format</param>
        /// <param name="values">The values to replace on the signature</param>
        internal static void replacePlaceholders(ref string signature, Dictionary<string, string> values) {
            foreach (var value in values) {
                signature = signature.Replace("{" + value.Key + "}", value.Value);
            }
        }
    }

}