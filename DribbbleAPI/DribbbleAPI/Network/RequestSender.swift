//
//  RequestSender.swift
//  DribbbleAPI
//
//  Created by Eduard Panasiuk on 8/30/16.
//  Copyright © 2016 somedev. All rights reserved.
//

import Foundation

enum RequestSenderError: Error {
    case NoData
    case InvalidData
    case ParserError
    case InvalidStatusCode(code: Int)
}

public typealias RequestCallback<T> = ((Result<T>) -> Void)

public final class RequestSender {
    public static let defaultSender: RequestSender = {
        RequestSender(baseURL: URL(string: DBAPIEndpoint)!)
    }()

    private let baseURL: URL
    private let urlSession: URLSession = URLSession.shared

    public init(baseURL url: URL) {
        baseURL = url
    }

    public func send<T>(request r: Request<T>, callback: @escaping RequestCallback<T>) {
        let urlRequest = r.requestWith(baseURL: baseURL)
        let task = urlSession.dataTask(with: urlRequest) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    callback(Result.Failure(error))
                }
                return
            }

            if let response = response, !response.isValidStatus {
                DispatchQueue.main.async {
                    callback(Result.Failure(RequestSenderError.InvalidStatusCode(code: response.status)))
                }
                return
            }

            guard let data = data else {
                DispatchQueue.main.async {
                    callback(Result.Failure(RequestSenderError.NoData))
                }
                return
            }

            guard let json = (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)) else {
                DispatchQueue.main.async {
                    callback(Result.Failure(RequestSenderError.InvalidData))
                }
                return
            }

            guard let result = r.parser(json) else {
                DispatchQueue.main.async {
                    callback(Result.Failure(RequestSenderError.ParserError))
                }
                return
            }

            DispatchQueue.main.async {
                callback(Result.Success(result))
            }
        }

        task.resume()
    }
}

public extension URLResponse {
    public var isValidStatus: Bool {
        guard let response = self as? HTTPURLResponse else { return true }
        return response.statusCode >= 200 && response.statusCode < 300
    }

    public var status: Int {
        guard let response = self as? HTTPURLResponse else { return 200 }
        return response.statusCode
    }
}
