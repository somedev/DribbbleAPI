//
//  DBLink.swift
//  DribbbleAPI
//
//  Created by Eduard Panasiuk on 11/6/16.
//  Copyright © 2016 somedev. All rights reserved.
//

import Foundation

public struct DBLink {
    let name:String
    let url:URL
}

extension DBLink {
    public init?(key:String?, value:String?) {
        guard let name = key,
            let value = value,
            let url:URL = URL(string:value)  else { return nil }
        self.name = name
        self.url = url
    }
    
    public static func links(from dictionary:[String:String]) -> [DBLink]? {
        return dictionary.flatMap({return DBLink(key:$0, value:$1)})
    }
}
