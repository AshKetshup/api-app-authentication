# stringFromResult(result:length:)

Converts the HMAC given in `UnsafeMutablePointer<CUnsignedChar>` to a hex string

``` swift
internal func stringFromResult(result: UnsafeMutablePointer<CUnsignedChar>, length: Int) -> String 
```

## Parameters

  - result: The value of the HMAC
  - length: The length of the HMAC

## Returns

The HMAC in hex format as string
