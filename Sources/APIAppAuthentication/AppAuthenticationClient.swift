//
//  AppAuthClient.swift
//  api-app-authentication
//
//  Created by Pedro Cavaleiro on 29/05/2021.
//

import Foundation
import CommonCrypto

public class AppAuthenticationClient {
    
    
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
    public init(appId: String, appKey: String) {
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
    public func generateHeader<T: Codable>(body: T, method: PostMethods, isJson: Bool = true, customSig: String = "{appid}{method}{timestamp}{nonce}{bodyhash}") -> [String: String] {
        let timestamp = String(Int(Date().timeIntervalSince1970))
        let nonce = UUID().uuidString
        var signature = customSig
        let values = [
            "timestamp": timestamp,
            "nonce": nonce,
            "appid": self.appId,
            "method": method.rawValue,
            "bodyhash": isJson ? String(data: (try! JSONEncoder().encode(body)), encoding: .utf8)!.sha256() : (body as! String).sha256()
        ]
        replacePlaceholders(signature: &signature, values: values)
        let hmac = signature.hmac(algorithm: .SHA256, key: self.appKey)
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
    public func generateHeader(method: GetMethods, customSig: String = "{appid}{method}{timestamp}{nonce}") -> [String: String] {
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
        let hmac = signature.hmac(algorithm: .SHA256, key: self.appKey)
        return [
            "X-Req-Timestamp": timestamp,
            "X-Req-Nonce": nonce,
            "X-Req-Sig": hmac,
            "X-App-Id": self.appId
        ]
    }
}
