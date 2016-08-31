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

public typealias RequestParser<T> = ((Dictionary<String, Any>) -> T?)

public struct Request<T> {
    let type:RequestType
    let path:String
    let headers:[String:String]
    let params:[String:String]
    let parser:RequestParser<T>
    
    public init(type:RequestType = .GET,
                path:String,
                headers:[String:String] = Request.defaultHeaders,
                params:[String:String] = [:],
                parser:RequestParser<T>){
        self.type = type
        self.path = path
        self.headers = headers
        self.params = params
        self.parser = parser
    }
}

public extension Request {
    public static var defaultHeaders:[String:String] {
        return ["Authorization":"Bearer \(DBTokenStorage().getToken())"]
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
