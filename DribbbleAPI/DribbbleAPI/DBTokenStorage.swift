//
//  DBKeychain.swift
//  DribbbleAPI
//
//  Created by Eduard Panasiuk on 8/29/16.
//  Copyright © 2016 somedev. All rights reserved.
//

import Foundation

internal final class DBTokenStorage {
    
    private let keychain:DBKeychain = DBKeychain()
    private var tokenKey:String = DBTokenParameterName
    
    public static var shared:DBTokenStorage = DBTokenStorage()
    
    public func setup(client aClient:String, secret:String) {
        tokenKey = "\(aClient)\(secret)\(DBTokenParameterName)"
    }
    
    public func getToken() -> String? {
        return keychain.getString(forKey: tokenKey)
    }
    
    public func setToken(token value:String)  {
        keychain.set(string: value, forKey: tokenKey)
    }
    
    public func deleteToken() {
        keychain.delete(forKey: tokenKey)
    }
}
