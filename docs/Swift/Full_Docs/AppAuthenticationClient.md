# AppAuthenticationClient

``` swift
public class AppAuthenticationClient 
```

## Initializers

### `init(appId:appKey:)`

Initializer

``` swift
public init(appId: String, appKey: String) 
```

Initializes the AppAuthenticationServer with the app id and app key

#### Parameters

  - appId: The id of the app to authenticate with the API
  - appKey: The key of the app to authenticate with the API

## Properties

### `appId`

Global variable holding the app id

``` swift
private var appId: String = ""
```

### `appKey`

Global variable holding the app key

``` swift
private var appKey: String = ""
```

## Methods

### `generateHeader(body:method:isJson:customSig:)`

Generates the headers required to authenticate with the API

``` swift
public func generateHeader<T: Codable>(body: T, method: PostMethods, isJson: Bool = true, customSig: String = "{appid}{method}{timestamp}{nonce}{bodyhash}") -> [String: String] 
```

Generates the headers required to authenticate with the API for the methods "POST", "PATCH" and "PUT"

> 

#### Parameters

  - body: The body of the request, must be a codable struct or a `String` if body is a `String` parameter `isJson` must be set to `false`
  - method: The method of the request, optional, defaults to `.POST`
  - isJson: Sets if the body is a JSON dictionary `[String: String]` or a `String`
  - customSig: The signature format that will be used to generate the request signature, optional, defaults to "{appid}{method}{timestamp}{nonce}"

#### Returns

The dictionary with the headers required for the authentication

### `generateHeader(method:customSig:)`

Generates the headers required to authenticate with the API

``` swift
public func generateHeader(method: GetMethods, customSig: String = "{appid}{method}{timestamp}{nonce}") -> [String: String] 
```

Generates the headers required to authenticate with the API for the methods "GET", "HEAD" and "DELETE"

> 

#### Parameters

  - method: The method of the request, optional, defaults to `.POST`
  - customSig: The signature format that will be used to generate the request signature, optional, defaults to "{appid}{method}{timestamp}{nonce}"

#### Returns

The dictionary with the headers required for the authentication
