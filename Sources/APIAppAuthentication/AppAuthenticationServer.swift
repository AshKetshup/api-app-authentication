//
//  AppAuthServer.swift
//  api-app-authentication
//
//  Created by Pedro Cavaleiro on 29/05/2021.
//

import Foundation

public class AppAuthenticationServer {

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
    public init(authorizedApps: [String: String]) throws {
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
    public func authenticateApp(headers: [String: String], method: GetMethods = .GET, customSig: String = "{appid}{method}{timestamp}{nonce}") throws -> Bool {
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
        
        if signature.hmac(algorithm: .SHA256, key: appKey.value) == sig.value {
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
    public func authenticateApp<T: Codable>(headers: [String: String], body: T, method: PostMethods = .POST, isJson: Bool = true, customSig: String = "{appid}{method}{timestamp}{nonce}{bodyhash}") throws -> Bool {
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
            "bodyhash": isJson ? String(data: (try! JSONEncoder().encode(body)), encoding: .utf8)!.sha256() : (body as! String).sha256()
        ]
        
        replacePlaceholders(signature: &signature, values: values)
        
        if signature.hmac(algorithm: .SHA256, key: appKey.value) == sig.value {
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

}

