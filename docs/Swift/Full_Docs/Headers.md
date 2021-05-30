# Headers

Headers required for the authentication

``` swift
public enum Headers: String, CaseIterable 
```

## Inheritance

`CaseIterable`, `String`

## Enumeration Cases

### `sig`

``` swift
case sig = "X-Req-Sig"
```

### `appId`

``` swift
case appId = "X-App-Id"
```

### `nonce`

``` swift
case nonce = "X-Req-Nonce"
```

### `timestamp`

``` swift
case timestamp = "X-Req-Timestmap"
```
