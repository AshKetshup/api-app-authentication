# Extensions on String

## Methods

### `sha256()`

Creates the SHA256 hash of the string and returns it in hex format as string

``` swift
internal func sha256() -> String 
```

#### Parameters

  - value: The string from which will be generated the hash

#### Returns

The hash in hex format as string

### `hmac(algorithm:key:)`

Creates the HMAC of the string and returns it in hex format as string

``` swift
internal func hmac(algorithm: CryptoAlgorithm, key: String) -> String 
```

#### Parameters

  - value: The string from which will be generated the HMAC
  - algorithm: The algorithm of the HMAC, reffer to `CryptoAlgorithm` for the supported algorithms
  - key: The key as string to generate the HMAC

#### Returns

The HMAC in hex format as string
