//
//  DBBucket.swift
//  DribbbleAPI
//
//  Created by Eduard Panasiuk on 11/6/16.
//  Copyright © 2016 somedev. All rights reserved.
//

import Foundation

public struct DBBucket {
    public let id: String
    public let name: String
    public let description: String
    public let shotsCount: UInt
    public let created: Date
    public let updated: Date
    public let user:DBUser?
}

//MARK: - custom initializer
extension DBBucket {
    public init?(dictionary: [String: Any] = [:]) {
        guard let id: String = dictionary.JSONValueForKey("id") else {
            return nil
        }
        
        self.id = id
        name = dictionary.JSONValueForKey("name") ?? ""
        description = dictionary.JSONValueForKey("description") ?? ""
        shotsCount = dictionary.JSONValueForKey("shots_count") ?? 0
        created = dictionary.JSONValueForKey("created_at") ?? Date()
        updated = dictionary.JSONValueForKey("updated_at") ?? Date()
        user = dictionary.JSONValueForKey("user")
    }
}

//MARK: - Buscket requests
extension DBBucket {
    static func getBucketRequest(id id: String) -> Request<DBBucket> {
        return Request(path: "buckets/\(id)",
            headers: Request<DBBucket>.defaultHeaders,
            parser: { data in
                guard let dict = data as? [String: Any] else { return nil }
                return DBBucket(dictionary: dict)
        })
    }
    
    static func createBucketRequest(name name: String, description:String?) -> Request<DBBucket> {
        return Request(type:.POST,
            path: "buckets",
            headers: Request<DBBucket>.defaultHeaders,
            params:["name":name, "description":description ?? ""],
            parser: { data in
                guard let dict = data as? [String: Any] else { return nil }
                return DBBucket(dictionary: dict)
        })
    }
    
    static func updateBucketRequest(id id:String, name: String, description:String?) -> Request<DBBucket> {
        return Request(type:.PUT,
                       path: "buckets/\(id)",
                       headers: Request<DBBucket>.defaultHeaders,
                       params:["name":name, "description":description ?? ""],
                       parser: { data in
                        guard let dict = data as? [String: Any] else { return nil }
                        return DBBucket(dictionary: dict)
        })
    }
    
    static func deleteBucketRequest(id id:String) -> Request<Bool> {
        return Request(type:.DELETE,
                       path: "buckets/\(id)",
            headers: Request<Bool>.defaultHeaders,
            parser: { _ in return true})
    }
    
    static func getBucketShotsRequest(id id: String, page: UInt = 1, perPage: UInt = 100) -> Request<[DBShot]> {
        return Request(path: "buckets/\(id)/shots",
            headers: Request<DBBucket>.defaultHeaders,
            params: ["page": "\(page)", "per_page": "\(perPage)"],
            parser: { data in
                guard let arr = data as? [[String: Any]] else { return nil }
                return arr.flatMap({ DBShot(dictionary: $0) })
        })
    }
    
    static func addShotToBucketRequest(id id:String, shotID: String) -> Request<Bool> {
        return Request(type:.PUT,
                       path: "buckets/\(id)/shots",
            headers: Request<DBBucket>.defaultHeaders,
            params:["shot_id":shotID],
            parser: {_ in return true})
    }
    
    static func deleteShotFromBucketRequest(id id:String, shotID: String) -> Request<Bool> {
        return Request(type:.DELETE,
                       path: "buckets/\(id)/shots",
            headers: Request<Bool>.defaultHeaders,
            params:["shot_id":shotID],
            parser: { _ in return true})
    }
}

//MARK: - operations with Bucket
extension DBBucket {
    public static func loadBucket(id anID: String, callback:@escaping RequestCallback<DBBucket>) {
        RequestSender.defaultSender.send(request: DBBucket.getBucketRequest(id: anID),
                                         callback: callback)
    }
    
    public static func createBucket(name name:String, description:String? ,callback:@escaping RequestCallback<DBBucket>) {
        RequestSender.defaultSender.send(request: DBBucket.createBucketRequest(name: name, description: description),
                                         callback: callback)
    }
    
    public static func updateBucket(id id:String, name:String, description:String? ,callback:@escaping RequestCallback<DBBucket>) {
        RequestSender.defaultSender.send(request: DBBucket.updateBucketRequest(id: id, name: name, description: description),
                                         callback: callback)
    }
    
    public static func deleteBucket(id id: String, callback:@escaping RequestCallback<Bool>) {
        RequestSender.defaultSender.send(request: DBBucket.deleteBucketRequest(id: id),
                                         callback: callback)
    }
    
    public static func loadBucketShots(id anID: String, page: UInt = 1, perPage: UInt = 100, callback:@escaping RequestCallback<[DBShot]>) {
        RequestSender.defaultSender.send(request: DBBucket.getBucketShotsRequest(id: anID, page:page, perPage:perPage),
                                         callback: callback)
    }
    
    public static func addShotToBucket(id id: String, shotID:String, callback:@escaping RequestCallback<Bool>) {
        RequestSender.defaultSender.send(request: DBBucket.addShotToBucketRequest(id: id, shotID: shotID),
                                         callback: callback)
    }
    
    public static func deleteShotFromBucket(id id: String, shotID:String, callback:@escaping RequestCallback<Bool>) {
        RequestSender.defaultSender.send(request: DBBucket.deleteShotFromBucketRequest(id: id, shotID: shotID),
                                         callback: callback)
    }
}
