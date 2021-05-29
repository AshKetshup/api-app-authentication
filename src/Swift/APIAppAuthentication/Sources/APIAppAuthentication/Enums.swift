//
//  Enums.swift
//  api-app-authentication
//
//  Created by Pedro Cavaleiro on 29/05/2021.
//

import Foundation
import CommonCrypto

/// Natively supported crypto algorithms
internal enum CryptoAlgorithm {
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
public enum Headers: String, CaseIterable {
    case sig = "X-Req-Sig"
    case appId = "X-App-Id"
    case nonce = "X-Req-Nonce"
    case timestamp = "X-Req-Timestmap"
}

/// Allowed methods with body
public enum PostMethods: String {
    case POST = "POST"
    case PATCH = "PATCH"
    case PUT = "PUT"
}

/// Allowed methods without body
public enum GetMethods: String {
    case GET = "GET"
    case HEAD = "HEAD"
    case DELETE = "DELETE"
}

/// Errors related with the authentication of the app and api
public enum AuthenticationError: Error {
    case AppIdNotFound
    case HeadersNotFound(missingHeader: Headers)
    case InvalidChallenge
}

/// Internal errors not triggered by the app authentication
public enum CompareErrors: Error {
    case NoAppsProvided
}
