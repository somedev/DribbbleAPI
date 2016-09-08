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
    public let userID: String
    public let teamID: String
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
    public let isAnimated: Bool
    public let tags: [String]
}

extension DBShot {

    public init?(dictionary: [String: Any] = [:]) {
        guard let id: String = dictionary.JSONValueForKey("id") else {
            return nil
        }

        self.id = id
        userID = dictionary.JSONValueForKey("user.id") ?? ""
        teamID = dictionary.JSONValueForKey("team.id") ?? ""
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
    }
}

extension DBShot {

    public static func currentUserShots(page p: UInt = 1, perPage: UInt = 100) -> Request<[DBShot]> {
        return Request(path: "user/shots",
            headers: Request<DBShot>.defaultHeaders,
            params: ["page": "\(p)", "per_page": "\(perPage)"],
            parser: { data in
                guard let arr = data as? [[String: Any]] else { return nil }
                return arr.flatMap({ DBShot(dictionary: $0) })
        })
    }

    public static func popularShots(page p: UInt = 0, perPage: UInt = 100) -> Request<[DBShot]> {
        return Request(path: "shots",
            headers: Request<DBShot>.defaultHeaders,
            params: ["page": "\(p)", "per_page": "\(perPage)"],
            parser: { data in
                guard let arr = data as? [[String: Any]] else { return nil }
                return arr.flatMap({ DBShot(dictionary: $0) })
        })
    }
}
