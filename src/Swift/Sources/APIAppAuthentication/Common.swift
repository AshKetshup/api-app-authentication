//
//  Common.swift
//  api-app-authentication
//
//  Created by Pedro Cavaleiro on 29/05/2021.
//

import Foundation

/**
 Replaces the placeholders with the propper values
 
 The replacement of the placeholders with the propper values is done "in place" thus not requiring a return value
 
 - parameters:
    - signature: The string with the placeholders
    - values: A dictionary with the values to replace
 */
internal func replacePlaceholders(signature: inout String, values: [String: String]) {
    for value in values {
        signature = signature.replacingOccurrences(of: "{\(value.key)}", with: value.value)
    }
}

/**
 Converts the HMAC given in `UnsafeMutablePointer<CUnsignedChar>` to a hex string
 
 - parameters:
    - result: The value of the HMAC
    - length: The length of the HMAC
 - returns: The HMAC in hex format as string
 */
internal func stringFromResult(result: UnsafeMutablePointer<CUnsignedChar>, length: Int) -> String {
    let hash = NSMutableString()
    for i in 0..<length {
        hash.appendFormat("%02x", result[i])
    }
    return String(hash).lowercased()
}
