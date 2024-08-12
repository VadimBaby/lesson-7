//
//  KeychainManager.swift
//  lesson-7
//
//  Created by Вадим Мартыненко on 09.08.2024.
//

import Foundation

protocol KeychainManagerProtocol {
    var token: String? { get set }
}

enum KeychainKey: String {
    case token
}

final class KeychainManager: KeychainManagerProtocol  {
    var token: String? {
        get {
            guard let tokenData = get(forKey: .token) else { return nil }
            guard let token = String(data: tokenData, encoding: .utf8) else { return nil }
            
            return token
        } set {
            if let newValue {
                save(newValue, forKey: .token)
            }
        }
    }
}

private extension KeychainManager {
    func save(_ token: String, forKey key: KeychainKey) {
        guard let tokenData = token.data(using: .utf8) else { return }
        
        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key.rawValue,
            kSecValueData: tokenData
        ]
        
        SecItemAdd(query as CFDictionary, nil)
    }
    
    func get(forKey key: KeychainKey) -> Data? {
        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key.rawValue,
            kSecReturnData: kCFBooleanTrue as Any
        ]
        
        var result: AnyObject?
        
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        
        guard status == errSecSuccess else { return nil }
        
        return result as? Data
    }
}
