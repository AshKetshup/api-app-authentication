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

After having the library imported create a new class, this class will work as middleware to authenticate the application.

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

namespace YourApiNameSpace {

    // This can be a name of your choice, just remember to change it's references if you don't use this one
    public class AppAuthMiddleware {

        private readonly RequestDelegate _next;
        private readonly AppAuthMiddlewareOptions _options;
        private YourDb dbContext; // this is required to fetch the authorized apps

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

            // A model called AppAuths was created, this model represents the table containing the apps
            var apps = dbContext.AppAuths.ToList();

            var valid = await ExecuteAppAuthAsync(context, apps);

            if (valid)
                await _next(context);
            else
            {
                if (errResponse == null)
                    errResponse = responseGenerator.DefaultError(IResponseGenerator.ErrorDescript.InvalidAppAuthChalenge);

                context.Response.StatusCode = 200;
                byte[] byteArray = Encoding.UTF8.GetBytes(errResponse);
                MemoryStream stream = new MemoryStream(byteArray);
                await stream.CopyToAsync(context.Response.Body);
            }

            scope.Dispose();
        }


    }

}

```