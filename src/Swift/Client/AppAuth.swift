import Foundation
import CommonCrypto

class AppAuthenticationClient {
    
    private enum CryptoAlgorithm {
        case MD5, SHA1, SHA224, SHA256, SHA384, SHA512
        
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
    
    enum PostMethods: String {
        case POST = "POST"
        case PATCH = "PATCH"
        case PUT = "PUT"
    }
    
    enum GetMethods: String {
        case GET = "GET"
        case HEAD = "HEAD"
        case DELETE = "DELETE"
    }
    
    private var appId: String = ""
    private var appKey: String = ""
    
    init(appId: String, appKey: String) {
        self.appId = appId
        self.appKey = appKey
    }
    
    func generateHeaderWithBody<T>(body: T, method: PostMethods, isJson: Bool = true, customSig: String = "{appid}{method}{timestamp}{nonce}{bodyhash}") -> [String: String] {
        let timestamp = String(Int(Date().timeIntervalSince1970))
        let nonce = UUID().uuidString
        var signature = customSig
        let values = [
            "timestamp": timestamp,
            "nonce": nonce,
            "appid": self.appId,
            "method": method.rawValue,
            "bodyhash": isJson ? String(data: (try! JSONEncoder().encode(body as! [String: String])), encoding: .utf8)! : sha256(value: (body as! String))
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
    
    func generateHeaderWithoutBody(method: GetMethods, customSig: String = "{appid}{method}{timestamp}{nonce}") -> [String: String] {
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
    
    private func sha256(value: String) -> String {
        let data = Data(value.utf8)
        var hash = [UInt8](repeating: 0,  count: Int(CC_SHA256_DIGEST_LENGTH))
        data.withUnsafeBytes {
            _ = CC_SHA256($0.baseAddress, CC_LONG(data.count), &hash)
        }
        return hash.map { String(format: "%02x", $0) }.joined()
    }
    
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
    
    private func stringFromResult(result: UnsafeMutablePointer<CUnsignedChar>, length: Int) -> String {
        let hash = NSMutableString()
        for i in 0..<length {
            hash.appendFormat("%02x", result[i])
        }
        return String(hash).lowercased()
    }
    
    private func replacePlaceholders(signature: inout String, values: [String: String]) {
        for value in values {
            signature = signature.replacingOccurrences(of: "{\(value.key)}", with: value.value)
        }
    }
    
}
