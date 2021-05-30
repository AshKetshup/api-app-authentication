# Types

  - [AppAuthenticationClient](/AppAuthenticationClient)
  - [AppAuthenticationServer](/AppAuthenticationServer)
  - [APIAppAuthenticationTests](/APIAppAuthenticationTests)
  - [CryptoAlgorithm](/CryptoAlgorithm):
    Natively supported crypto algorithms
  - [Headers](/Headers):
    Headers required for the authentication
  - [PostMethods](/PostMethods):
    Allowed methods with body
  - [GetMethods](/GetMethods):
    Allowed methods without body
  - [AuthenticationError](/AuthenticationError):
    Errors related with the authentication of the app and api
  - [CompareErrors](/CompareErrors):
    Internal errors not triggered by the app authentication

# Global Functions

  - [replacePlaceholders(signature:​values:​)](/replacePlaceholders\(signature_values_\)):
    Replaces the placeholders with the propper values
  - [stringFromResult(result:​length:​)](/stringFromResult\(result_length_\)):
    Converts the HMAC given in `UnsafeMutablePointer<CUnsignedChar>` to a hex string

# Global Variables

  - [package](/package)

# Extensions

  - [String](/String)
