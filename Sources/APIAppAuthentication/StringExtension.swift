//
//  String.swift
//  api-app-authentication
//
//  Created by Pedro Cavaleiro on 29/05/2021.
//

import Foundation
import CommonCrypto

extension String {
    
    /**
     Creates the SHA256 hash of the string and returns it in hex format as string
     
     - parameters:
        - value: The string from which will be generated the hash
     - returns: The hash in hex format as string
     */
    internal func sha256() -> String {
        let data = Data(self.utf8)
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
    internal func hmac(algorithm: CryptoAlgorithm, key: String) -> String {
        let str = self.cString(using: String.Encoding.utf8)
        let strLen = Int(self.lengthOfBytes(using: String.Encoding.utf8))
        let digestLen = algorithm.digestLength
        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen)
        let keyStr = key.cString(using: String.Encoding.utf8)
        let keyLen = Int(key.lengthOfBytes(using: String.Encoding.utf8))
        
        CCHmac(algorithm.HMACAlgorithm, keyStr!, keyLen, str!, strLen, result)
        
        let digest = stringFromResult(result: result, length: digestLen)
        
        result.deallocate()
        
        return digest
    }
}
