//
//  DBScope.swift
//  DribbbleAPI
//
//  Created by Eduard Panasiuk on 8/23/16.
//  Copyright © 2016 somedev. All rights reserved.
//

import Foundation

public enum DBScope:String {
    case Public = "public"
    case write
    case comment
    case upload
    
    static func scopeString(from scopes:[DBScope]) -> String {
        var result = scopes.reduce("", {"\($0)+\($1.rawValue)"})
        result.characters.removeFirst(1)
        return result
    }
}
