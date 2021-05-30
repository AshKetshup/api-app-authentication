# replacePlaceholders(signature:values:)

Replaces the placeholders with the propper values

``` swift
internal func replacePlaceholders(signature: inout String, values: [String: String]) 
```

The replacement of the placeholders with the propper values is done "in place" thus not requiring a return value

## Parameters

  - signature: The string with the placeholders
  - values: A dictionary with the values to replace
