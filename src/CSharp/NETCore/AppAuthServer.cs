using System;
using System.Collections.Generic;
using System.ComponentModel;
using Newtonsoft.Json;

namespace AppApiAuthenticator.Server {

    /// <summary>
    /// Class containing the methods to authenticate the app with the API
    /// </summary>
    public class Authorizor {

        /// <summary>
        /// Required headers for the authorization
        /// </summary>
        private enum Header {
            [Description("X-Req-Sig")]
            sig,
            [Description("X-App-Id")]
            appId,
            [Description("X-Req-Nonce")]
            nonce,
            [Description("X-Req-Timestmap")]
            timestamp
        }

        /// <summary>
        /// Holds the dictionary contaning the authorized apps id's and keys
        /// </summary>
        private Dictionary<string, string> apps = new Dictionary<string, string>();

        /// <summary>
        /// Initializes the authorizor for the server side, requires a dictionary of apps containing the AppID and AppKey
        /// If the dictionary is empty the exception `NoAuthorizedApps` is thrown
        /// </summary>
        /// <param name="apps">Dictionary of authorized apps</param>
        /// <exception cref="NoAuthorizedAppsException">The dictionary of authorized apps is empty</exception>
        public Authorizor(Dictionary<string, string> apps) {
            if(apps.Count <= 0) {
                throw new NoAuthorizedAppsException("No authorized apps, there must be at least one authorized app");
            }
        }

        /// <summary>
        /// Tries to authenticate the app with the api for the methods "POST", "PATCH" and "PUT"
        /// </summary>
        /// <typeparam name="T">The type of the body, this is inferred by the parameter</typeparam>
        /// <param name="headers">The headers of the request, must be at least the headers mentioned on the `Header` enum</param>
        /// <param name="body">The body of the request, must be a codable struct or a `string` if body is a `string` parameter `isJson` must be set to `false`</param>
        /// <param name="method">The method of the request, optional, defaults to `PostMethods.POST`</param>
        /// <param name="isJson">Sets if the body is a conformable json class or a `string`</param>
        /// <param name="customSig">The signature format that will be used to generate the request signature, optional, defaults to "{appid}{method}{timestamp}{nonce}{bodyhash}"</param>
        /// <exception cref="MissingHeaderException">Missing required header for the authorization (the missing header is described in the Message)</exception>
        /// <exception cref="InvalidChallengeException">Missing required header for the authorization (the missing header is described in the Message)</exception>
        /// <returns>true if authenticated, no other return as all other paths lead to exceptions</returns>
        public bool authenticateApp<T>(Dictionary<string, string> headers, T body, Common.PostMethods method = Common.PostMethods.POST, bool isJson = true, string customSig = "{appid}{method}{timestamp}{nonce}{bodyhash}") {
            string hsig = headers[Header.sig.getDescription()];
            string appid = headers[Header.appId.getDescription()];
            string nonce = headers[Header.nonce.getDescription()];
            string timestamp = headers[Header.timestamp.getDescription()];

            var key = String.Empty;
            try {
                key = apps[appid];
            } catch (KeyNotFoundException) {
                throw new AppIdNotFoundException("The App trying to access is not an authorized app");
            }

            string signature = customSig;
            var values = new Dictionary<string, string> {
                { "timestamp", timestamp },
                { "nonce", nonce },
                { "appid", appid },
                { "method",  method.getDescription() },
                { "bodyhash", isJson ? Crypto.calculateSha256(JsonConvert.SerializeObject(body)) : Crypto.calculateSha256(body.ToString()) }
            };

            Common.replacePlaceholders(ref signature, values);

            var hmac = Crypto.calculateHMACSha256(signature, key);

            if(hmac == hsig)
                return true;

            throw new InvalidChallengeException();

        }

        /// <summary>
        /// Tries to authenticate the app with the api for the methods "GET", "HEAD" and "DELETE"
        /// </summary>
        /// <param name="headers">The headers of the request, must be at least the headers mentioned on the `Header` enum</param>
        /// <param name="method">The method of the request, optional, defaults to `GetMethods.GET`</param>
        /// <param name="customSig">The signature format that will be used to generate the request signature, optional, defaults to "{appid}{method}{timestamp}{nonce}"</param>
        /// <exception cref="MissingHeaderException">Missing required header for the authorization (the missing header is described in the Message)</exception>
        /// <exception cref="InvalidChallengeException">Missing required header for the authorization (the missing header is described in the Message)</exception>
        /// <returns>true if authenticated, no other return as all other paths lead to exceptions</returns>
        public bool authenticateApp(Dictionary<string, string> headers, Common.PostMethods method = Common.PostMethods.POST, string customSig = "{appid}{method}{timestamp}{nonce}") {
            string hsig = headers[Header.sig.getDescription()];
            string appid = headers[Header.appId.getDescription()];
            string nonce = headers[Header.nonce.getDescription()];
            string timestamp = headers[Header.timestamp.getDescription()];

            var key = String.Empty;
            try {
                key = apps[appid];
            } catch (KeyNotFoundException) {
                throw new AppIdNotFoundException("The App trying to access is not an authorized app");
            }

            string signature = customSig;
            var values = new Dictionary<string, string> {
                { "timestamp", timestamp },
                { "nonce", nonce },
                { "appid", appid },
                { "method",  method.getDescription() }
            };

            Common.replacePlaceholders(ref signature, values);

            var hmac = Crypto.calculateHMACSha256(signature, key);

            if(hmac == hsig)
                return true;

            throw new InvalidChallengeException();

        }

        /// <summary>
        /// Checks if all headers required for the authorization are present
        /// </summary>
        /// <param name="headers">The headers of the request</param>
        /// <exception cref="MissingHeaderException">Missing required header for the authorization (the missing header is described in the Message)</exception>
        public void headersPresent(Dictionary<string, string> headers) {
            foreach (Header e in Enum.GetValues(typeof(Header))) {
                if (!headers.ContainsKey(e.getDescription())) {
                    throw new MissingHeaderException("The header " + e.getDescription() + " required for the authorization is missing");
                }                
            }
        }

    }

    /// <summary>
    /// Exception when there are no authorized apps
    /// </summary>
    public class NoAuthorizedAppsException : Exception
	{
        /// <summary>
        /// Default initializer when there's no data
        /// </summary>
		public NoAuthorizedAppsException() { }

        /// <summary>
        /// Default initializer, for message only
        /// </summary>
        /// <param name="message">Error message</param>
		public NoAuthorizedAppsException(string message) : base(message) { }

        /// <summary>
        /// Default initializer, for message and inner exception
        /// </summary>
        /// <param name="message">Error message</param>
        /// <param name="inner">Inner exception</param>
		public NoAuthorizedAppsException(string message, Exception inner) : base(message, inner) { }
	}

    /// <summary>
    /// Exception when there's one missing header
    /// </summary>
    public class MissingHeaderException : Exception
	{
        /// <summary>
        /// Default initializer when there's no data
        /// </summary>
		public MissingHeaderException() { }

        /// <summary>
        /// Default initializer, for message only
        /// </summary>
        /// <param name="message">Error message</param>
		public MissingHeaderException(string message) : base(message) { }

        /// <summary>
        /// Default initializer, for message and inner exception
        /// </summary>
        /// <param name="message">Error message</param>
        /// <param name="inner">Inner exception</param>
		public MissingHeaderException(string message, Exception inner) : base(message, inner) { }
	}

    /// <summary>
    /// Exception when the app id is not found
    /// </summary>
    public class AppIdNotFoundException : Exception {
        /// <summary>
        /// Default initializer when there's no data
        /// </summary>
		public AppIdNotFoundException() { }

        /// <summary>
        /// Default initializer, for message only
        /// </summary>
        /// <param name="message">Error message</param>
		public AppIdNotFoundException(string message) : base(message) { }

        /// <summary>
        /// Default initializer, for message and inner exception
        /// </summary>
        /// <param name="message">Error message</param>
        /// <param name="inner">Inner exception</param>
		public AppIdNotFoundException(string message, Exception inner) : base(message, inner) { }
    }

    /// <summary>
    /// Exception when the challenge fails
    /// </summary>
    public class InvalidChallengeException : Exception {
        /// <summary>
        /// Default initializer when there's no data
        /// </summary>
		public InvalidChallengeException() { }

        /// <summary>
        /// Default initializer, for message only
        /// </summary>
        /// <param name="message">Error message</param>
		public InvalidChallengeException(string message) : base(message) { }

        /// <summary>
        /// Default initializer, for message and inner exception
        /// </summary>
        /// <param name="message">Error message</param>
        /// <param name="inner">Inner exception</param>
		public InvalidChallengeException(string message, Exception inner) : base(message, inner) { }
    }

}