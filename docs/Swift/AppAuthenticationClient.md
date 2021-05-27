# AppAuthenticationClient

``` swift
class AppAuthenticationClient 
```

## Initializers

### `init(appId:appKey:)`

Initializer

``` swift
init(appId: String, appKey: String) 
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
func generateHeader<T: Codable>(body: T, method: PostMethods, isJson: Bool = true, customSig: String = "{appid}{method}{timestamp}{nonce}{bodyhash}") -> [String: String] 
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
func generateHeader(method: GetMethods, customSig: String = "{appid}{method}{timestamp}{nonce}") -> [String: String] 
```

Generates the headers required to authenticate with the API for the methods "GET", "HEAD" and "DELETE"

> 

#### Parameters

  - method: The method of the request, optional, defaults to `.POST`
  - customSig: The signature format that will be used to generate the request signature, optional, defaults to "{appid}{method}{timestamp}{nonce}"

#### Returns

The dictionary with the headers required for the authentication

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
