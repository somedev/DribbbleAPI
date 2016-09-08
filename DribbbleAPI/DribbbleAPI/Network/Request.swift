//
//  Request.swift
//  DribbbleAPI
//
//  Created by Eduard Panasiuk on 8/30/16.
//  Copyright © 2016 somedev. All rights reserved.
//

import Foundation

public enum RequestType:String {
    case GET
    case POST
    case DELETE
    case PUT
    case HEAD
}

public typealias RequestParser<T> = ((Any) -> T?)

public struct Request<T> {
    public let type:RequestType
    public let path:String
    public let headers:[String:String]
    public let params:[String:String]
    public let parser:RequestParser<T>
    
    public init(type:RequestType = .GET,
                path:String,
                headers:[String:String] = Request.defaultHeaders,
                params:[String:String] = [:],
                parser:@escaping RequestParser<T>){
        self.type = type
        self.path = path
        self.headers = headers
        self.params = params
        self.parser = parser
    }
}

public extension Request {
    public static var defaultHeaders:[String:String] {
        guard let token = DBTokenStorage.shared.getToken() else {
            return [:]
        }
        return ["Authorization":"Bearer \(token)"]
    }
    
    public func requestWith(baseURL anUrl:URL) -> URLRequest {
        var url = anUrl.appendingPathComponent(path)
        let data = String.requestStringFrom(dictionary: params)
        var request = URLRequest(url:url)
        if(data.characters.count > 0 && type == .GET){
            url = url.appendingPathComponent("?\(data)")
        } else {
            request.httpBody = data.data(using: .utf8)
        }
        request.httpMethod = type.rawValue
        request.allHTTPHeaderFields = headers
        return request
    }
}
