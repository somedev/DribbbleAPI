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

    
    public func getToken(name aName:String = DBTokenParameterName) -> String? {
        return keychain.getString(forKey: aName)
    }
    
    public func setToken(name aName:String = DBTokenParameterName, value:String)  {
        keychain.set(string: value, forKey: aName)
    }
    
    public func deleteToken(name aName:String = DBTokenParameterName) {
        keychain.delete(forKey: aName)
    }
}
