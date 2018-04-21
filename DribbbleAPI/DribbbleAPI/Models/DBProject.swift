//
//  DBProject.swift
//  DribbbleAPI
//
//  Created by Eduard Panasiuk on 11/6/16.
//  Copyright © 2016 somedev. All rights reserved.
//

import Foundation

public struct DBProject {
    public let id: String
    public let name: String
    public let description: String
    public let shotsCount: UInt
    public let created: Date
    public let updated: Date
    public let user: DBUser?
}

// MARK: - custom initializer

extension DBProject {
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

// MARK: - Project requests

extension DBProject {
    static func getProjectRequest(id: String) -> Request<DBProject> {
        return Request(path: "projects/\(id)",
                       headers: Request<DBProject>.defaultHeaders,
                       parser: { data in
                           guard let dict = data as? [String: Any] else { return nil }
                           return DBProject(dictionary: dict)
        })
    }

    static func getProjectShotsRequest(id: String, page: UInt = 1, perPage: UInt = 100) -> Request<[DBShot]> {
        return Request(path: "projects/\(id)/shots",
                       headers: Request<DBBucket>.defaultHeaders,
                       params: ["page": "\(page)", "per_page": "\(perPage)"],
                       parser: { data in
                           guard let arr = data as? [[String: Any]] else { return nil }
                           return arr.flatMap({ DBShot(dictionary: $0) })
        })
    }
}

// MARK: - operations with Project

extension DBProject {
    public static func loadProject(id: String, callback: @escaping RequestCallback<DBProject>) {
        RequestSender.defaultSender.send(request: DBProject.getProjectRequest(id: id),
                                         callback: callback)
    }

    public static func loadProjectShots(id anID: String, page: UInt = 1, perPage: UInt = 100, callback: @escaping RequestCallback<[DBShot]>) {
        RequestSender.defaultSender.send(request: DBProject.getProjectShotsRequest(id: anID, page: page, perPage: perPage),
                                         callback: callback)
    }
}
