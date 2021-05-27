# AppAuthenticationServer

``` swift
class AppAuthenticationServer 
```

## Initializers

### `init(authorizedApps:)`

Initializer

``` swift
init(authorizedApps: [String: String]) throws 
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
func authenticateApp(headers: [String: String], method: GetMethods = .GET, customSig: String = "{appid}{method}{timestamp}{nonce}") throws -> Bool 
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
func authenticateApp<T: Codable>(headers: [String: String], body: T, method: PostMethods = .POST, isJson: Bool = true, customSig: String = "{appid}{method}{timestamp}{nonce}{bodyhash}") throws -> Bool 
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

### `sha256(value:)`

Creates the SHA256 hash of the string and returns it in hex format as string

``` swift
private func sha256(value: String) -> String 
```

#### Parameters

  - value: The string from which will be generated the hash

#### Returns

The hash in hex format as string

### `hmac(_:algorithm:key:)`

Creates the HMAC of the string and returns it in hex format as string

``` swift
private func hmac(_ value: String, algorithm: CryptoAlgorithm, key: String) -> String 
```

#### Parameters

  - value: The string from which will be generated the HMAC
  - algorithm: The algorithm of the HMAC, reffer to `CryptoAlgorithm` for the supported algorithms
  - key: The key as string to generate the HMAC

#### Returns

The HMAC in hex format as string

### `stringFromResult(result:length:)`

Converts the HMAC given in `UnsafeMutablePointer<CUnsignedChar>` to a hex string

``` swift
private func stringFromResult(result: UnsafeMutablePointer<CUnsignedChar>, length: Int) -> String 
```

#### Parameters

  - result: The value of the HMAC
  - length: The length of the HMAC

#### Returns

The HMAC in hex format as string

### `replacePlaceholders(signature:values:)`

Replaces the placeholders with the propper values

``` swift
private func replacePlaceholders(signature: inout String, values: [String: String]) 
```

The replacement of the placeholders with the propper values is done "in place" thus not requiring a return value

#### Parameters

  - signature: The string with the placeholders
  - values: A dictionary with the values to replace
