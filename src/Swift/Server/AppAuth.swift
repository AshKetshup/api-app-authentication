//
// AppAuth.swift
// Authenticate an APP with the API
//
// Created by Pedro cavaleiro on 25/05/2021
// Copyright © 2021 Pedro Cavaleiro. All rights reserved.
//
import Foundation
import CommonCrypto

class AppAuthenticationServer {

    /// Errors related with the authentication of the app and api
    enum AuthenticationError: Error {
        case AppIdNotFound
        case HeadersNotFound(missingHeader: Headers)
        case InvalidChallenge
    }

    /// Internal errors not triggered by the app authentication
    enum CompareErrors: Error {
        case NoAppsProvided
    }

    /// Allowed methods with body
    enum PostMethods: String {
        case POST = "POST"
        case PATCH = "PATCH"
        case PUT = "PUT"
    }

    /// Allowed methods without body
    enum GetMethods: String {
        case GET = "GET"
        case HEAD = "HEAD"
        case DELETE = "DELETE"
    }

    /// Natively supported crypto algorithms
    private enum CryptoAlgorithm {
        case MD5, SHA1, SHA224, SHA256, SHA384, SHA512

        /// Natively supported HMAC algorithms
        var HMACAlgorithm: CCHmacAlgorithm {
            var result: Int = 0
            switch self {
            case .MD5:      result = kCCHmacAlgMD5
            case .SHA1:     result = kCCHmacAlgSHA1
            case .SHA224:   result = kCCHmacAlgSHA224
            case .SHA256:   result = kCCHmacAlgSHA256
            case .SHA384:   result = kCCHmacAlgSHA384
            case .SHA512:   result = kCCHmacAlgSHA512
            }
            return CCHmacAlgorithm(result)
        }

        /// Length for each algorithm
        var digestLength: Int {
            var result: Int32 = 0
            switch self {
            case .MD5:      result = CC_MD5_DIGEST_LENGTH
            case .SHA1:     result = CC_SHA1_DIGEST_LENGTH
            case .SHA224:   result = CC_SHA224_DIGEST_LENGTH
            case .SHA256:   result = CC_SHA256_DIGEST_LENGTH
            case .SHA384:   result = CC_SHA384_DIGEST_LENGTH
            case .SHA512:   result = CC_SHA512_DIGEST_LENGTH
            }
            return Int(result)
        }
    }

    /// Headers required for the authentication
    enum Headers: String, CaseIterable {
        case sig = "X-Req-Sig"
        case appId = "X-App-Id"
        case nonce = "X-Req-Nonce"
        case timestamp = "X-Req-Timestmap"
    }

    /// Global variable holding all the authorized apps
    private var authorizedApps: [String: String] = [String: String]()

    /**
     Initializer
     
     Initializes the AppAuthenticationServer with a list of authorized apps
     
     - parameters:
        - authorizedApps: A list of authorized apps as a dictionary containing the appId and appKey
     - Precondition: The `authorizedApps` must contain at least one element.
     - Throws:
        - CompareErrors.NoAppsProvided: When `authorizedApps` contains zero elements.
     */
    init(authorizedApps: [String: String]) throws {
        if authorizedApps.isEmpty {
            throw CompareErrors.NoAppsProvided
        }
        self.authorizedApps = authorizedApps
    }

    /**
     Authenticates the app with the api
     
     Tries to authenticate the app with the api for the methods "GET", "HEAD" and "DELETE"
     
     - parameters:
        - headers: The headers of the request, must be at least the headers mentioned on the `Headers` enum
        - method: The method of the request, optional, defaults to `.GET`
        - customSig: The signature format that will be used to generate the request signature, optional, defaults to "{appid}{method}{timestamp}{nonce}"
     - Precondition: The headers dictionary must contain all the headers mentioned on the `Headers` enum
     - Throws:
        - `AuthenticationError.HeadersNotFound(missingHeader:)`: When some header is missing, the missing header is referenced
        - `AuthenticationError.AppIdNotFound`: The appid was not found in the `authorizedApps`
     - returns: True if authenticated, no other return as all other paths lead to exceptions
     */
    func authenticateApp(headers: [String: String], method: GetMethods = .GET, customSig: String = "{appid}{method}{timestamp}{nonce}") throws -> Bool {
        try headersPresent(headers: headers)
        
        let appId = headers.first(where: { $0.key == Headers.appId.rawValue })!
        let timestamp = headers.first(where: { $0.key == Headers.timestamp.rawValue })!
        let nonce = headers.first(where: { $0.key == Headers.nonce.rawValue })!
        let sig = headers.first(where: { $0.key == Headers.sig.rawValue })!
        
        guard let appKey = authorizedApps.first(where: { $0.key == appId.value }) else { throw AuthenticationError.AppIdNotFound }
        
        var signature = customSig
        let values = [
            "timestamp": timestamp.value,
            "nonce": nonce.value,
            "appid": appId.value,
            "method": method.rawValue
        ]
        
        replacePlaceholders(signature: &signature, values: values)
        
        if hmac(signature, algorithm: .SHA256, key: appKey.value) == sig.value {
            return true
        }
        throw AuthenticationError.InvalidChallenge
    }
    
    /**
     Authenticates the app with the api
     
     Tries to authenticate the app with the api for the methods "POST", "PATCH" and "PUT"
     
     - parameters:
        - headers: The headers of the request, must be at least the headers mentioned on the `Headers` enum
        - body: The body of the request, must be a codable struct or a `String` if body is a `String` parameter `isJson` must be set to `false`
        - method: The method of the request, optional, defaults to `.POST`
        - isJson: Sets if the body is a JSON dictionary `[String: String]` or a `String`
        - customSig: The signature format that will be used to generate the request signature, optional, defaults to "{appid}{method}{timestamp}{nonce}{bodyhash}"
     - Precondition: The headers dictionary must contain all the headers mentioned on the `Headers` enum
     - Precondition: The `body` must be a codable struct or a `String`, when the type is `String` the parameter `isJson` must be set to `false`
     - Throws:
        - `AuthenticationError.HeadersNotFound(missingHeader:)`: When some header is missing, the missing header is referenced
        - `AuthenticationError.AppIdNotFound`: The appid was not found in the `authorizedApps`
     - returns: True if authenticated, no other return as all other paths lead to exceptions
     */
    func authenticateApp<T: Codable>(headers: [String: String], body: T, method: PostMethods = .POST, isJson: Bool = true, customSig: String = "{appid}{method}{timestamp}{nonce}{bodyhash}") throws -> Bool {
        try headersPresent(headers: headers)
        
        let appId = headers.first(where: { $0.key == Headers.appId.rawValue })!
        let timestamp = headers.first(where: { $0.key == Headers.timestamp.rawValue })!
        let nonce = headers.first(where: { $0.key == Headers.nonce.rawValue })!
        let sig = headers.first(where: { $0.key == Headers.sig.rawValue })!
        
        guard let appKey = authorizedApps.first(where: { $0.key == appId.value }) else { throw AuthenticationError.AppIdNotFound }
        
        var signature = customSig
        let values = [
            "timestamp": timestamp.value,
            "nonce": nonce.value,
            "appid": appId.value,
            "method": method.rawValue,
            "bodyhash": isJson ? sha256(value: String(data: (try! JSONEncoder().encode(body)), encoding: .utf8)!) : sha256(value: (body as! String))
        ]
        
        replacePlaceholders(signature: &signature, values: values)
        
        if hmac(signature, algorithm: .SHA256, key: appKey.value) == sig.value {
            return true
        }
        throw AuthenticationError.InvalidChallenge
    }

    /**
     Checks if required headers are present
     
     - parameters:
        - headers: A dictionary of the request headers
     - Throws
        - `AuthenticationError.HeadersNotFound(missingHeader: header)`: When there's a missing header
     */
    private func headersPresent(headers: [String: String]) throws {
        for header in Headers.AllCases() {
            guard (headers.first(where: { $0.key == header.rawValue }) != nil) else { throw AuthenticationError.HeadersNotFound(missingHeader: header) }
        }
    }

    /**
     Creates the SHA256 hash of the string and returns it in hex format as string
     
     - parameters:
        - value: The string from which will be generated the hash
     - returns: The hash in hex format as string
     */
    private func sha256(value: String) -> String {
        let data = Data(value.utf8)
        var hash = [UInt8](repeating: 0,  count: Int(CC_SHA256_DIGEST_LENGTH))
        data.withUnsafeBytes {
            _ = CC_SHA256($0.baseAddress, CC_LONG(data.count), &hash)
        }
        return hash.map { String(format: "%02x", $0) }.joined()
    }

    /**
     Creates the HMAC of the string and returns it in hex format as string
     
     - parameters:
        - value: The string from which will be generated the HMAC
        - algorithm: The algorithm of the HMAC, reffer to `CryptoAlgorithm` for the supported algorithms
        - key: The key as string to generate the HMAC
     - returns: The HMAC in hex format as string
     */
    private func hmac(_ value: String, algorithm: CryptoAlgorithm, key: String) -> String {
        let str = value.cString(using: String.Encoding.utf8)
        let strLen = Int(value.lengthOfBytes(using: String.Encoding.utf8))
        let digestLen = algorithm.digestLength
        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen)
        let keyStr = key.cString(using: String.Encoding.utf8)
        let keyLen = Int(key.lengthOfBytes(using: String.Encoding.utf8))

        CCHmac(algorithm.HMACAlgorithm, keyStr!, keyLen, str!, strLen, result)

        let digest = stringFromResult(result: result, length: digestLen)

        result.deallocate()

        return digest
    }

    /**
     Converts the HMAC given in `UnsafeMutablePointer<CUnsignedChar>` to a hex string
     
     - parameters:
        - result: The value of the HMAC
        - length: The length of the HMAC
     - returns: The HMAC in hex format as string
     */
    private func stringFromResult(result: UnsafeMutablePointer<CUnsignedChar>, length: Int) -> String {
        let hash = NSMutableString()
        for i in 0..<length {
            hash.appendFormat("%02x", result[i])
        }
        return String(hash).lowercased()
    }

    /**
     Replaces the placeholders with the propper values
     
     The replacement of the placeholders with the propper values is done "in place" thus not requiring a return value
     
     - parameters:
        - signature: The string with the placeholders
        - values: A dictionary with the values to replace
     */
    private func replacePlaceholders(signature: inout String, values: [String: String]) {
        for value in values {
            signature = signature.replacingOccurrences(of: "{\(value.key)}", with: value.value)
        }
    }

}
