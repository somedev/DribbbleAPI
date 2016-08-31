//
//  RequestSender.swift
//  DribbbleAPI
//
//  Created by Eduard Panasiuk on 8/30/16.
//  Copyright © 2016 somedev. All rights reserved.
//

import Foundation

enum RequestSenderError:Error {
    case NoData
    case InvalidData
    case ParserError
}

public final class RequestSender {
    let baseURL:URL
    let urlSession: URLSession = URLSession.shared
    
    
    public init(baseURL url:URL) {
        self.baseURL = url
    }
    
    public func send<T>(request r:Request<T>, callback:@escaping (Result<T>) -> ()) {
        let urlRequest = r.requestWith(baseURL: baseURL)
        let task = urlSession.dataTask(with: urlRequest) { data, response, error in
            if let error = error {
                callback(Result.Failure(error))
                return
            }
            
            guard let data = data else {
                callback(Result.Failure(RequestSenderError.NoData))
                return
            }
            
            guard let json = (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)) as? Dictionary<String, Any> else {
                callback(Result.Failure(RequestSenderError.InvalidData))
                return
            }
            
            guard let result = r.parser(json) else {
                callback(Result.Failure(RequestSenderError.ParserError))
                return
            }
            
            callback(Result.Success(result))
        }
        
        task.resume()
    }
    
    
}
