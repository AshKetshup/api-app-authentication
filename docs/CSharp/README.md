# API APP Authentication for C#

## Table of Contents

* [Dependencies](#Dependencies)
 * Installation
    * [From Binaries](#From-Binaries)
    * [From Source Code](#From-source)
* Usage
    * [Server Side](#Usage-Server-Side)
        * **[Full Docs .NET 5](net5_fulldoc.md)**
        * **[Full Docs .NET Core](netcore_fulldoc.md)**
    * [Client Side](#Usage-Client-Side)
        * **[Class Documentation](AppAuthenticationClient.md)**
    * [Advanced Usage](#Advanced-Usage)

## Dependencies

**if using the binary**

* **if using .NET 5 or newer**
    * _None_
* **if using other versions (.NET Core or .NET Framework)**
    * [Newtonsoft.Json](https://www.newtonsoft.com/json)

**if compiling the source**
* [Vsxmd](https://www.nuget.org/packages/Vsxmd/) - Generates the documentation in markdown in compilation time
* **if using .NET 5 or newer**
    * _None_
* **if using other versions (.NET Core or .NET Framework)**
    * [Newtonsoft.Json](https://www.newtonsoft.com/json)

## Installation

_Dependencies should be automatically installed_

### From Binaries

**if using .NET 5 or newer**
    
* Import the `AppApiAuthenticator.dll` into your project

**if using .NET Core or .NET Framework**

* Import the `AppApiAuthenticator.dll` into your project
* If not using JSON in your project also import the `Newtonsoft.Json.dll`

### From source

**if using .NET 5 or newer**

* Add the project to your solution ".sln" or build the source code and import `AppApiAuthenticator.dll` onto your project.

**if using .NET Core**

* Add the project to your solution ".sln" or build the source code and import `AppApiAuthenticator.dll` onto your project.

**if using .NET Framework**

* Open the project for `.NET Core`
* Change the target framework for `net46` or `.NET Framework 4.6`
* Save the project
* Add the project to your solution ".sln" or build the source code and import `AppApiAuthenticator.dll`

## Usage Server Side

* Library Documentation
    * **[Full Docs .NET 5](net5_fulldoc.md)**
    * **[Full Docs .NET Core](netcore_fulldoc.md)**

The example provided below is using ASP.NET Core Project built with `.NET Core 3`

After having the library imported create a new class, this class will be a model for your database
```csharp
using AppApiAuthenticator.Interfaces; // the model must conform with the interface IAppDbModel

// It's assumed that this class will be placed in a folder called Models the namespace can be changed
namespace YourApiNameSpace.Models {
    class AppAuths: IAppDbModel {
        public System.Guid AppAuthID { get; set; }
        public string Key { get; set; }
    }
}
```

Create a new class, we will put it in a folder called `Middlewares` this class will work as middleware to authenticate the application, it's also assumed that EntityFramework is used.

```csharp
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Security.Cryptography;
using System.Text;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Options;
using Newtonsoft.Json.Linq;
using AppApiAuthenticator.Server; // this is the library for the app authorization on the server side
using AppApiAuthenticator;

namespace YourApiNameSpace.Middlewares {

    // This can be a name of your choice, just remember to change it's references if you don't use this one
    public class AppAuthMiddleware {

        private readonly RequestDelegate _next;
        private readonly AppAuthMiddlewareOptions _options;
        private YourDb dbContext; // this is required to fetch the authorized apps
        private Authorizor appAuth = null;

        public AppAuthMiddleware(RequestDelegate next, IOptions<AppAuthMiddlewareOptions> options) {
            _next = next;
            _options = options;
        }

        public async Task InvokeAsync(HttpContext context)
        {

            var serviceScopeFactory = (IServiceScopeFactory)context.RequestServices.GetService(typeof(IServiceScopeFactory));
            var scope = serviceScopeFactory.CreateScope();
            var services = scope.ServiceProvider;
            dbContext = services.GetRequiredService<YourDb>(); // Get the DB Context required to fetch the apps

            // AppAuths is the model created above, this is fetched from the database using EntityFramework
            var apps = dbContext.AppAuths.ToList();
            // We initialize the class that will perform the authorization
            appAuth = Authorizor<AppAuths>(apps);

            var result = await ExecuteAppAuthAsync(context, apps);

            if (result.Item1)
                await _next(context);
            else {
                // we return the error 401 (unauthorized)
                context.Response.StatusCode = 401;
                byte[] byteArray = Encoding.UTF8.GetBytes(result.Item2);
                MemoryStream stream = new MemoryStream(byteArray);
                await stream.CopyToAsync(context.Response.Body);
            }

            scope.Dispose();
        }

        private async Task<(bool, string)> ExecuteAppAuthAsync(HttpContext context, List<AppAuth> apps)
        {
            var headers = GetHeaders(context);
            
            // as we don't have a model as body at this point we must set the isJson argument as false
            try {
                if (context.Request.Method == "POST")
                    return (appAuth.authenticateApp(headers, await ReadBodyAsync(context), Common.PostMethods.POST, false), String.Empty);
                else if (context.Request.Method == "PATCH") 
                    return (appAuth.authenticateApp(headers, await ReadBodyAsync(context), Common.PostMethods.PATCH, false), String.Empty);
                else if (context.Request.Method == "PUT")
                    return (appAuth.authenticateApp(headers, await ReadBodyAsync(context), Common.PostMethods.PUT, false), String.Empty);
                else if (context.Request.Method == "GET")
                    return (appAuth.authenticateApp(headers, Common.GetMethods.GET, false), String.Empty);
                else if (context.Request.Method == "HEAD")
                    return (appAuth.authenticateApp(headers, Common.GetMethods.HEAD, false), String.Empty);
                else if (context.Request.Method == "DELETE")
                    return (appAuth.authenticateApp(headers, Common.GetMethods.DELETE, false), String.Empty);
            } catch (Exception e) {
                return (false, e.Message);
            }            
        }

        private Dictionary<string, string> GetHeaders(HttpContext httpContext)
        {
            var req = httpContext.Request;
            var headers = Dictionary<string, string>();

            foreach (var header in req.Headers)
                headers.Add(entry.Key, entry.Value.FirstOrDefault());

            return headers;
        }

        private async Task<string> ReadBodyAsync(HttpContext context)
        {
            string body = "";
            using (var reader = new StreamReader(
                context.Request.Body,
                Encoding.UTF8,
                false,
                leaveOpen: true))
            {
                body = await reader.ReadToEndAsync();

                context.Request.Body.Position = 0;
            }
            return body;
        }

    }

    public class AppAuthMiddlewareOptions
    {
        public YourDb DatabaseContext { get; set; } = null;
    }

}
```

With the middleware class complete we need to setup the custom options for it, for that we create a extension, I will create under the `Extensions` folder, this class will also allow us to use the class we created previously as a middleware
```csharp
using System;
using Microsoft.AspNetCore.Builder;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;

namespace YourApiNameSpace.Extensions
{
    
    public static class AppAuthMiddlewareWithOptionsExtensions
    {
        public static IServiceCollection AddAppAuthMiddlewareWithOptions(this IServiceCollection service, 
            Action<Middleware.AppAuthMiddlewareOptions> options = default)
        {
            options ??= (opts => { });

            service.Configure(options);
            return service;
        }

        public static IApplicationBuilder UseAppAuthMiddleware(this IApplicationBuilder builder)
        {
            return builder.UseMiddleware<Middleware.AppAuthMiddleware>();
        }
    }

}

```

We can, finally, add to the set of middlewares, for that on the `Startup.cs` in the `Configure` method we add the following line

```csharp
/// add the following line right after the UseCors middleware
app.UseAppAuthMiddleware();
```

The API is now catching all unauthorized apps without any further configuration.

## Usage Client Side

* Library Documentation
    * **[Full Docs .NET 5](net5_fulldoc.md)**
    * **[Full Docs .NET Core](netcore_fulldoc.md)**

Using this library for the client is fairly simple, the bellow example is using all native libraries of .NET Framework / .NET Core / .NET 5 (or above)

```csharp
using System;
using System.Net.Http;
using System.Threading.Tasks;
using AppApiAuthenticator.Client;
using AppApiAuthenticator;
using Newtonsoft.Json;

namespace WebAPIClient
{
    class Program
    {
        private static readonly HttpClient client = new HttpClient();
        
        // Entrypoint of the program, only calls one Get Request and one Post Request
        static async Task Main(string[] args) {
            GetReq();
            PostReq()
        }

        static async Task GetReq() {
            using var client = new HttpClient();
            var appAuth = Authorizor("appId", "appKey");
            var authorizationHeaders = appAuth.generateHeader(Common.GetMethods.GET);
            foreach (var header in authorizationHeaders)
                client.DefaultRequestHeaders(header.Key, header.Value);
            var result = await client.GetAsync("http://yourapiurl.com/get");
        }

        static async Task PostReq() {
            // a exemple of a model
            var person = new Person("John Doe", "gardener");
            
            var json = JsonConvert.SerializeObject(person);
            var data = new StringContent(json, Encoding.UTF8, "application/json");

            var url = "http://yourapiurl.com/post";
            using var client = new HttpClient();

            var appAuth = Authorizor("appId", "appKey");
            var authorizationHeaders = appAuth.generateHeader(person, Common.PostMethods.POST);
            
            foreach (var header in authorizationHeaders)
                client.DefaultRequestHeaders(header.Key, header.Value);
            
            var response = await client.PostAsync(url, data);
        }
    }
}
```

## Advanced Usage

The most advanced usage provided by this library as of now is the support for a custom signature the signature a string must be passed in the `customsig` argument (check the table of arguments below)

The default string is `{appid}{method}{timestamp}{nonce}{bodyhash}` for the "POST", "PATCH" and "PUT" methods and `{appid}{method}{timestamp}{nonce}` for the "GET", "HEAD" and "DELETE"

You can rearrange this fields as you wish even placing more text between them for example
```swift
var sig_str_body = "{method} for: {appid} on {timestamp} with uuid {nonce} with body hash {bodyhash}"
var sig_str = "{method} for: {appid} on {timestamp} with uuid {nonce}"
```

As long as the placeholders for `method`, `appid`, `timestamp` and `nonce` are present for all methods and `bodyhash` is present for "POST", "PATCH" and "PUT" it will generate a valid signature, just need to inform the developers of the client app what signature to use