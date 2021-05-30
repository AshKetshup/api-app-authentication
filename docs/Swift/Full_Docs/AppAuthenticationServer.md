# AppAuthenticationServer

``` swift
public class AppAuthenticationServer 
```

## Initializers

### `init(authorizedApps:)`

Initializer

``` swift
public init(authorizedApps: [String: String]) throws 
```

Initializes the AppAuthenticationServer with a list of authorized apps

> 

#### Parameters

  - authorizedApps: A list of authorized apps as a dictionary containing the appId and appKey

#### Throws

  - CompareErrors.NoAppsProvided:​ When `authorizedApps` contains zero elements.

## Properties

### `authorizedApps`

Global variable holding all the authorized apps

``` swift
private var authorizedApps: [String: String] 
```

## Methods

### `authenticateApp(headers:method:customSig:)`

Authenticates the app with the api

``` swift
public func authenticateApp(headers: [String: String], method: GetMethods = .GET, customSig: String = "{appid}{method}{timestamp}{nonce}") throws -> Bool 
```

Tries to authenticate the app with the api for the methods "GET", "HEAD" and "DELETE"

> 

#### Parameters

  - headers: The headers of the request, must be at least the headers mentioned on the `Headers` enum
  - method: The method of the request, optional, defaults to `.GET`
  - customSig: The signature format that will be used to generate the request signature, optional, defaults to "{appid}{method}{timestamp}{nonce}"

#### Throws

  - `AuthenticationError.HeadersNotFound(missingHeader:​)`:​ When some header is missing, the missing header is referenced
  - `AuthenticationError.AppIdNotFound`:​ The appid was not found in the `authorizedApps`

#### Returns

True if authenticated, no other return as all other paths lead to exceptions

### `authenticateApp(headers:body:method:isJson:customSig:)`

Authenticates the app with the api

``` swift
public func authenticateApp<T: Codable>(headers: [String: String], body: T, method: PostMethods = .POST, isJson: Bool = true, customSig: String = "{appid}{method}{timestamp}{nonce}{bodyhash}") throws -> Bool 
```

Tries to authenticate the app with the api for the methods "POST", "PATCH" and "PUT"

> 

> 

#### Parameters

  - headers: The headers of the request, must be at least the headers mentioned on the `Headers` enum
  - body: The body of the request, must be a codable struct or a `String` if body is a `String` parameter `isJson` must be set to `false`
  - method: The method of the request, optional, defaults to `.POST`
  - isJson: Sets if the body is a JSON dictionary `[String: String]` or a `String`
  - customSig: The signature format that will be used to generate the request signature, optional, defaults to "{appid}{method}{timestamp}{nonce}{bodyhash}"

#### Throws

  - `AuthenticationError.HeadersNotFound(missingHeader:​)`:​ When some header is missing, the missing header is referenced
  - `AuthenticationError.AppIdNotFound`:​ The appid was not found in the `authorizedApps`

#### Returns

True if authenticated, no other return as all other paths lead to exceptions

### `headersPresent(headers:)`

Checks if required headers are present

``` swift
private func headersPresent(headers: [String: String]) throws 
```

  - Throws
    
      - `AuthenticationError.HeadersNotFound(missingHeader: header)`: When there's a missing header

#### Parameters

  - headers: A dictionary of the request headers
