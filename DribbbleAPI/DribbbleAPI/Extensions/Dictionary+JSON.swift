//
//  Dictionary+JSON.swift
//  DribbbleAPI
//
//  Created by Eduard Panasiuk on 9/1/16.
//  Copyright © 2016 somedev. All rights reserved.
//

//
// Created by Eduard Panasiuk on 7/18/16.
// Copyright (c) 2016 Mobile Roadie. All rights reserved.
//

import Foundation

public protocol JSONKeyType: Hashable {
    var stringValue: String { get }
}

extension String: JSONKeyType {
    public var stringValue: String {
        return self
    }
}

public protocol JSONValueType {
    associatedtype T = Self
    static func JSONValue(_ object: Any) -> T?
}

public extension JSONValueType {
    public static func JSONValue(_ object: Any) -> T? {
        guard let objectValue = object as? T else {
            return nil
        }
        return objectValue
    }
}

extension String: JSONValueType {
    public static func JSONValue(_ object: Any) -> String? {
        guard let value = (object as AnyObject).description else { return nil }
        return value
    }
}

extension Bool: JSONValueType {
    public static func JSONValue(_ object: Any) -> Bool? {
        guard let value = (object as AnyObject).boolValue else { return nil }
        return Bool(value)
    }
}

extension Double: JSONValueType {
    public static func JSONValue(_ object: Any) -> Double? {
        guard let value = (object as AnyObject).doubleValue else { return nil }
        return Double(value)
    }
}

extension Float: JSONValueType {
    public static func JSONValue(_ object: Any) -> Float? {
        guard let value = (object as AnyObject).floatValue else { return nil }
        return Float(value)
    }
}

extension Int: JSONValueType {
    public static func JSONValue(_ object: Any) -> Int? {
        guard let value = (object as AnyObject).floatValue else { return nil }
        return Int(value)
    }
}

extension UInt: JSONValueType {
    public static func JSONValue(_ object: Any) -> UInt? {
        guard let value = (object as AnyObject).uintValue else { return nil }
        return UInt(value)
    }
}

extension Date: JSONValueType {
    public static func JSONValue(_ object: Any) -> Date? {
        guard let value = (object as? String) else { return nil }
        return DateFormatter.dbFormatter.date(from: value)
    }
}

extension URL: JSONValueType {
    public static func JSONValue(_ object: Any) -> URL? {
        guard let urlString = object as? String,
            let objectValue = URL(string: urlString) else { return nil }
        return objectValue
    }
}

public extension Dictionary where Key: JSONKeyType {
    
    private func anyForKey(_ key: Key) -> Any? {
        let pathComponents = key.stringValue.characters
            .split(separator: ".").map(String.init)
        var accumulator: Any = self
        
        for component in pathComponents {
            if let componentData = accumulator as? [Key: Value],
                let value = componentData[component as! Key] {
                accumulator = value
                continue
            }
            
            return nil
        }
        
        return accumulator
    }
    
    public func JSONValueForKey<A: JSONValueType>(_ key: Key) -> A? {
        guard let any = anyForKey(key), let result = A.JSONValue(any) as? A else {
            return nil
        }
        
        if let _ = result as? NSNull {
            return nil
        }
        
        return result
    }
    
    public func JSONValueForKey<A: JSONValueType>(_ key: Key) -> [A]? {
        guard let any = anyForKey(key) as? Array<AnyObject> else {
            return nil
        }
        return any.flatMap({ element in
            return A.JSONValue(element) as? A })
    }
}





