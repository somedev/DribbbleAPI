//
//  DBShot.swift
//  DribbbleAPI
//
//  Created by Eduard Panasiuk on 9/5/16.
//  Copyright © 2016 somedev. All rights reserved.
//

import Foundation

public struct DBShot {
    public let id: String
    public let title: String
    public let description: String
    public let width: Float
    public let height: Float
    public let hidpi: URL?
    public let normal: URL?
    public let teaser: URL?
    public let viewsCount: UInt
    public let likesCount: UInt
    public let commentsCount: UInt
    public let attachmentsCount: UInt
    public let reboundsCount: UInt
    public let bucketsCount: UInt
    public let created: Date
    public let updated: Date
    public let htmlURL: URL?
    public let isAnimated: Bool
    public let tags: [String]
    public let user: DBUser?
    public let team: DBTeam?
}

extension DBShot {

    public init?(dictionary: [String: Any] = [:]) {
        guard let id: String = dictionary.JSONValueForKey("id") else {
            return nil
        }

        self.id = id
        title = dictionary.JSONValueForKey("title") ?? ""
        description = dictionary.JSONValueForKey("description") ?? ""
        width = dictionary.JSONValueForKey("width") ?? 0
        height = dictionary.JSONValueForKey("height") ?? 0
        hidpi = dictionary.JSONValueForKey("images.hidpi")
        normal = dictionary.JSONValueForKey("images.normal")
        teaser = dictionary.JSONValueForKey("images.teaser")
        viewsCount = dictionary.JSONValueForKey("views_count") ?? 0
        likesCount = dictionary.JSONValueForKey("likes_count") ?? 0
        commentsCount = dictionary.JSONValueForKey("comments_count") ?? 0
        attachmentsCount = dictionary.JSONValueForKey("attachments_count") ?? 0
        reboundsCount = dictionary.JSONValueForKey("rebounds_count") ?? 0
        bucketsCount = dictionary.JSONValueForKey("buckets_count") ?? 0
        created = dictionary.JSONValueForKey("created_at") ?? Date()
        updated = dictionary.JSONValueForKey("updated_at") ?? Date()
        isAnimated = dictionary.JSONValueForKey("animated") ?? false
        tags = dictionary.JSONValueForKey("tags") ?? []
        user = dictionary.JSONValueForKey("user")
        team = dictionary.JSONValueForKey("team")
        htmlURL = dictionary.JSONValueForKey("html_url")
    }
}

extension DBShot {

    static func currentUserShots(page p: UInt = 1, perPage: UInt = 100) -> Request<[DBShot]> {
        return Request(path: "user/shots",
            headers: Request<DBShot>.defaultHeaders,
            params: ["page": "\(p)", "per_page": "\(perPage)"],
            parser: { data in
                guard let arr = data as? [[String: Any]] else { return nil }
                return arr.flatMap({ DBShot(dictionary: $0) })
        })
    }

    static func userShots(userID id: String, page: UInt = 1, perPage: UInt = 100) -> Request<[DBShot]> {
        return Request(path: "user/\(id)/shots",
                       headers: Request<DBShot>.defaultHeaders,
                       params: ["page": "\(page)", "per_page": "\(perPage)"],
                       parser: { data in
                        guard let arr = data as? [[String: Any]] else { return nil }
                        return arr.flatMap({ DBShot(dictionary: $0) })
        })
    }
    
    static func popularShots(page p: UInt = 0, perPage: UInt = 100) -> Request<[DBShot]> {
        return Request(path: "shots",
            headers: Request<DBShot>.defaultHeaders,
            params: ["page": "\(p)", "per_page": "\(perPage)"],
            parser: { data in
                guard let arr = data as? [[String: Any]] else { return nil }
                return arr.flatMap({ DBShot(dictionary: $0) })
        })
    }
}

extension DBShot {
    public static func loadUserShots(userID id: String,
                                     page: UInt = 1,
                                     perPage: UInt = 100,
                                     callback:@escaping RequestCallback<[DBShot]>) {
        RequestSender.defaultSender.send(request: DBShot.userShots(userID: id, page: page, perPage: perPage),
                                         callback: callback)
    }
    
    public static func loadCurrentUserShots(page p: UInt = 1,
                                     perPage: UInt = 100,
                                     callback:@escaping RequestCallback<[DBShot]>) {
        RequestSender.defaultSender.send(request: DBShot.currentUserShots(page: p, perPage: perPage),
                                         callback: callback)
    }

    public static func loadPopularShots(page p: UInt = 1,
                                            perPage: UInt = 100,
                                            callback:@escaping RequestCallback<[DBShot]>) {
        RequestSender.defaultSender.send(request: DBShot.popularShots(page: p, perPage: perPage),
                                         callback: callback)
    }
    
}
