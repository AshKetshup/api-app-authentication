using System;
using System.Collections.Generic;
using Newtonsoft.Json;

namespace AppApiAuthenticator.Client {

    /// <summary>
    /// Class containing the methods to generate the headers
    /// </summary>
    public class Authorizor {

        /// <summary>
        /// Holds the appId on the current instance
        /// </summary>
        private string appId = "";

        /// <summary>
        /// Holds the appKey on the current instance
        /// </summary>
        private string appKey = "";

        /// <summary>
        /// Initializes the class, requires the appId and appKey
        /// </summary>
        /// <param name="appId">The appId to be authorized</param>
        /// <param name="appKey">The appKey to use on the authorization</param>
        public Authorizor(string appId, string appKey) {
            this.appId = appId;
            this.appKey = appKey;
        }

        /// <summary>
        /// Generates the headers required for the app authentication with the API for the methods "POST", "PATCH" and "PUT"
        /// </summary>
        /// <typeparam name="T">The type of the body, this is inferred by the parameter</typeparam>
        /// <param name="body">The body of the request, must be a codable struct or a `string` if body is a `string` parameter `isJson` must be set to `false`</param>
        /// <param name="method">The method of the request, optional, defaults to `PostMethods.POST`</param>
        /// <param name="isJson">Sets if the body is a conformable json class or a `string`</param>
        /// <param name="customSig">The signature format that will be used to generate the request signature, optional, defaults to "{appid}{method}{timestamp}{nonce}{bodyhash}"</param>
        /// <returns>The dictionary with the headers required for the authentication</returns>
        public Dictionary<string, string> generateHeader<T>(T body, Common.PostMethods method = Common.PostMethods.POST, bool isJson = true, string customSig = "{appid}{method}{timestamp}{nonce}{bodyhash}") {
            string timestamp = ((DateTimeOffset)DateTime.Now).ToUnixTimeSeconds().ToString();
            string nonce = Guid.NewGuid().ToString();
            string signature = customSig;
            var values = new Dictionary<string, string> {
                { "timestamp", timestamp },
                { "nonce", nonce },
                { "appid", this.appId },
                { "method",  method.getDescription() },
                { "bodyhash", isJson ? Crypto.calculateSha256(JsonConvert.SerializeObject(body)) : Crypto.calculateSha256(body.ToString()) }
            };

            Common.replacePlaceholders(ref signature, values);

            var hmac = Crypto.calculateHMACSha256(signature, this.appKey);
            return new Dictionary<string, string> {
                { "X-Req-Timestamp", timestamp },
                { "X-Req-Nonce", nonce },
                { "X-Req-Sig", hmac },
                { "X-App-Id", this.appId }
            };
        }

        /// <summary>
        /// Generates the headers required for the app authentication with the API for the methods "GET", "HEAD" and "DELETE"
        /// </summary>
        /// <param name="method">The method of the request</param>
        /// <param name="customSig">The signature format that will be used to generate the request signature, optional, defaults to "{appid}{method}{timestamp}{nonce}"</param>
        /// <returns>The dictionary with the headers required for the authentication</returns>
        public Dictionary<string, string> generateHeader(Common.GetMethods method = Common.GetMethods.GET, string customSig = "{appid}{method}{timestamp}{nonce}") {
            string timestamp = ((DateTimeOffset)DateTime.Now).ToUnixTimeSeconds().ToString();
            string nonce = Guid.NewGuid().ToString();
            string signature = customSig;
            var values = new Dictionary<string, string> {
                { "timestamp", timestamp },
                { "nonce", nonce },
                { "appid", this.appId },
                { "method",  method.getDescription() }
            };

            Common.replacePlaceholders(ref signature, values);

            var hmac = Crypto.calculateHMACSha256(signature, this.appKey);
            return new Dictionary<string, string> {
                { "X-Req-Timestamp", timestamp },
                { "X-Req-Nonce", nonce },
                { "X-Req-Sig", hmac },
                { "X-App-Id", this.appId }
            };
        }

    }
}