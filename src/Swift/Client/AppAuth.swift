//
// AppAuth.swift
// Authenticate an APP with the API
//
// Created by Pedro cavaleiro on 25/05/2021
// Copyright © 2021 Pedro Cavaleiro. All rights reserved.
//
import Foundation
import CommonCrypto

class AppAuthenticationClient {
    
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
    
    /// Global variable holding the app id
    private var appId: String = ""
    /// Global variable holding the app key
    private var appKey: String = ""
    
    /**
     Initializer
     
     Initializes the AppAuthenticationServer with the app id and app key
     
     - parameters:
        - appId: The id of the app to authenticate with the API
        - appKey: The key of the app to authenticate with the API
     */
    init(appId: String, appKey: String) {
        self.appId = appId
        self.appKey = appKey
    }
    
    /**
     Generates the headers required to authenticate with the API
     
     Generates the headers required to authenticate with the API for the methods "POST", "PATCH" and "PUT"
     
     - parameters:
        - body: The body of the request, must be a codable struct or a `String` if body is a `String` parameter `isJson` must be set to `false`
        - method: The method of the request, optional, defaults to `.POST`
        - isJson: Sets if the body is a JSON dictionary `[String: String]` or a `String`
        - customSig: The signature format that will be used to generate the request signature, optional, defaults to "{appid}{method}{timestamp}{nonce}"
     - Precondition: The `body` must be a codable struct or a `String`, when the type is `String` the parameter `isJson` must be set to `false`
     - returns: The dictionary with the headers required for the authentication
     */
    func generateHeader<T: Codable>(body: T, method: PostMethods, isJson: Bool = true, customSig: String = "{appid}{method}{timestamp}{nonce}{bodyhash}") -> [String: String] {
        let timestamp = String(Int(Date().timeIntervalSince1970))
        let nonce = UUID().uuidString
        var signature = customSig
        let values = [
            "timestamp": timestamp,
            "nonce": nonce,
            "appid": self.appId,
            "method": method.rawValue,
            "bodyhash": isJson ? sha256(value: String(data: (try! JSONEncoder().encode(body)), encoding: .utf8)!) : sha256(value: (body as! String))
        ]
        replacePlaceholders(signature: &signature, values: values)
        let hmac = hmac(signature, algorithm: .SHA256, key: self.appKey)
        return [
            "X-Req-Timestamp": timestamp,
            "X-Req-Nonce": nonce,
            "X-Req-Sig": hmac,
            "X-App-Id": self.appId
        ]
    }
    
    /**
     Generates the headers required to authenticate with the API
     
     Generates the headers required to authenticate with the API for the methods "GET", "HEAD" and "DELETE"
     
     - parameters:
        - method: The method of the request, optional, defaults to `.POST`
        - customSig: The signature format that will be used to generate the request signature, optional, defaults to "{appid}{method}{timestamp}{nonce}"
     - Precondition: The `body` must have one of the following types `[String: String]` or `String` when the type is `String` the parameter `isJson` must be set to `false`
     - returns: The dictionary with the headers required for the authentication
     */
    func generateHeader(method: GetMethods, customSig: String = "{appid}{method}{timestamp}{nonce}") -> [String: String] {
        let timestamp = String(Int(Date().timeIntervalSince1970))
        let nonce = UUID().uuidString
        var signature = customSig
        let values = [
            "timestamp": timestamp,
            "nonce": nonce,
            "appid": self.appId,
            "method": method.rawValue
        ]
        replacePlaceholders(signature: &signature, values: values)
        let hmac = hmac(signature, algorithm: .SHA256, key: self.appKey)
        return [
            "X-Req-Timestamp": timestamp,
            "X-Req-Nonce": nonce,
            "X-Req-Sig": hmac,
            "X-App-Id": self.appId
        ]
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
