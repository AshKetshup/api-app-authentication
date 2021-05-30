# AuthenticationError

Errors related with the authentication of the app and api

``` swift
public enum AuthenticationError: Error 
```

## Inheritance

`Error`

## Enumeration Cases

### `AppIdNotFound`

``` swift
case AppIdNotFound
```

### `HeadersNotFound`

``` swift
case HeadersNotFound(missingHeader: Headers)
```

### `InvalidChallenge`

``` swift
case InvalidChallenge
```
