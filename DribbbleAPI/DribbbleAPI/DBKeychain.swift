//
//  DBKeychain.swift
//  DribbbleAPI
//
//  Created by Eduard Panasiuk on 8/29/16.
//  Copyright © 2016 somedev. All rights reserved.
//

import Foundation
import Security

public final class DBKeychain {
    private let keyPrefix = "com-dribble-api-keychain"
    
    public func set(string value:String, forKey key:String) -> Bool {
        guard let value = value.data(using: String.Encoding.utf8) else {
            return false
        }
        
        let _ = delete(forKey: key)
        
        let query: [String: Any]  = [
            kSecClass as String      : kSecClassGenericPassword,
            kSecAttrAccount as String : keyWithPrefix(key: key),
            kSecValueData as String   : value,
            kSecAttrAccessible as String  : kSecAttrAccessibleAlways
        ]
        
        return SecItemAdd(query as CFDictionary, nil) == noErr
    }
    
    public func delete(forKey key:String) -> Bool {
        let query: [String: Any] = [
            kSecClass as String       : kSecClassGenericPassword,
            kSecAttrAccount as String : keyWithPrefix(key:key),
            kSecAttrSynchronizable as String : kSecAttrSynchronizableAny
        ]
        
        return SecItemDelete(query as CFDictionary) == noErr
    }
    
    public func getString(forKey key:String) -> String? {
        
        let query: [String: Any] = [
            kSecClass as String : kSecClassGenericPassword,
            kSecAttrAccount as String : keyWithPrefix(key: key),
            kSecReturnData as String  : kCFBooleanTrue,
            kSecMatchLimit as String  : kSecMatchLimitOne
        ]
        
        var result: AnyObject?
        
        let resultCode = withUnsafeMutablePointer(to: &result) {
            SecItemCopyMatching(query as CFDictionary, UnsafeMutablePointer($0))
        }
        
        guard let data = result as? Data, resultCode == noErr, let finalResult = NSString(data: data, encoding: String.Encoding.utf8.rawValue) as? String else {
            return nil
        }
    
        return finalResult
    }
    
    //MARK: - private
    private func keyWithPrefix(key aKey:String) -> String {
        return "\(keyPrefix)\(aKey)"
    }
    
    
    
}
