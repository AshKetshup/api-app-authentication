# API APP Authentication for Swift

## Table of Contents

* [Dependencies](#Dependencies)
* Installation
    * [Server Side](#Installation-Server-Side)
    * [Client Side](#Installation-Client-Side)
* Usage
    * [Server Side](#Usage-Server-Side)
        * **[Class Documentation](AppAuthenticationServer.md)**
    * [Client Side](#Usage-Client-Side)
        * **[Class Documentation](AppAuthenticationClient.md)**
    * [Advanced Usage](#Advanced-Usage)

## Dependencies

_None_

## Installation Server Side

Get the latest [release](https://github.com/PedroCavaleiro/api-app-authentication/releases) for Swift

Import the file `AppAuth.swift` located on the `Server` folder onto your project

## Installation Client Side

Import the file `AppAuth.swift` located on the `Client` folder onto your project

## Usage Server Side

**Full documentation for the [server side](AppAuthenticationServer.md)**

The example provided below is using [Vapor](https://vapor.codes/) Server

After having imported the file onto your project import the class and initialize the library

```swift
import Fluent // not required for this library, it's only part of the example
import Vapor  // not required for this library, it's only part of the example
import AppAuthenticationServer

struct YourController: RouteCollection {
    let app: Application
    let appAuth: AppAuthenticationServer

    init(app: Application) {
        self.app = app
        // during the initialization of the class we must pass a dictionary containing the APPID and APPKey
        // we assume that `apps` is a existing dictionary with the appid and appkey this should be fetched from the database
        // this initialization should be performed before the request
        do {
            self.appAuth = try AppAuthenticationServer(authorizedApps: apps)
        catch AppAuthenticationServer.CompareErrors.NoAppsProvided {
            print("no authorized apps")
        }
    }

}
```

Now that we have the library initialized we can start using it, you might want to create a middleware for this stage, we will not be creating one in this example so in one of the endpoints

```swift
// method with body (in this example a POST)
private func loginUser(_ req: Request) throws -> EventLoopFuture<Response> {
    // This conversion is required because Vapor gives us an array of type HTTPHeaders this converts them into `[String: String]`
    // as required by the library.
    var headers = Dictionary(uniqueKeysWithValues: req.headers.map { ($0.name, $0.value) })
    // This holds the post data for the login data, as it comes in json we can decode it immediately and pass it to the body argument
    let loginData = try req.content.decode(LoginRequest.self)
    
    do {
        try self.appAuth.authenticateApp(headers: headers, body: loginData, method: .POST)
    }
    catch AppAuthenticationServer.AuthenticationError.AppIdNotFound { print("app id not found") }
    catch AppAuthenticationServer.AuthenticationError.InvalidChallenge { print("invalid challenge") }
    catch AppAuthenticationServer.AuthenticationError.HeadersNotFound(let missingHeader) { print("Missing headers \(missingHeader.rawValue)") }
}

// method without body (in this example a GET)
private func getEmail(_ req: Request) throws -> EventLoopFuture<Response> {
    // This conversion is required because Vapor gives us an array of type HTTPHeaders this converts them into `[String: String]`
    // as required by the library.
    var headers = Dictionary(uniqueKeysWithValues: req.headers.map { ($0.name, $0.value) })

    do {
        try self.appAuth.authenticateApp(headers: headers, method: .GET)
    }
    catch AppAuthenticationServer.AuthenticationError.AppIdNotFound { print("app id not found") }
    catch AppAuthenticationServer.AuthenticationError.InvalidChallenge { print("invalid challenge") }
    catch AppAuthenticationServer.AuthenticationError.HeadersNotFound(let missingHeader) { print("Missing headers \(missingHeader.rawValue)") }
}
```

## Usage Client Side

**File documentation for [client side](AppAuthenticationClient.md)**

After having imported the file onto your project import the class and initialize the library

```swift
import AppAuthenticationClient

class YourClass {

    let appAuth: AppAuthenticationClient

    init(app: Application) {
        // It's up to the developer to keep the AppID and AppKey secure
        self.appAuth = try AppAuthenticationClient(appId: appid, appKey: String)
    }

}
```

Now that we have the library initialized we can start using it, now for each request you must follow the following process (the below example is using the native `URLSession`)

```swift
func somePostRequest<T: Codable>(body: T) {
    // ...
    var request = URLRequest(url: url!)
    request.httpMethod = "POST"
    // Get the authorization headers
    // We are using the default signature template
    // For a custom signature template check the advanced usage
    let authorizationHeaders = appAuth.generateHeader(body: body, method: .POST)
    // Add all required headers to the request
    authorizationHeaders.forEach {
        request.setValue($0.value, forHTTPHeaderField: $0.key)
    }
    // ...
}

func someGetRequest() {
    // ...
    var request = URLRequest(url: url!)
    request.httpMethod = "GET"
    // Get the authorization headers
    // We are using the default signature template
    // For a custom signature template check the advanced usage
    let authorizationHeaders = appAuth.generateHeader(method: .GET)
    // Add all required headers to the request
    authorizationHeaders.forEach {
        request.setValue($0.value, forHTTPHeaderField: $0.key)
    }
    // ...
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