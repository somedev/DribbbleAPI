//
//  DBUser.swift
//  DribbbleAPI
//
//  Created by Eduard Panasiuk on 9/1/16.
//  Copyright © 2016 somedev. All rights reserved.
//

import Foundation

public struct DBUser {
    public let id: String
    public let name: String
    public let username: String
    public let htmlURL: URL?
    public let avatarUrl: URL?
    public let bio: String
    public let location: String
    public let links: [DBLink]?
    public let bucketsCount: UInt
    public let commentsReceivedCount: UInt
    public let followersCount: UInt
    public let followingsCount: UInt
    public let likesCount: UInt
    public let likesReceived_count: UInt
    public let projectsCount: UInt
    public let reboundsReceivedCount: UInt
    public let shotsСount: UInt
    public let teamsСount: UInt
    public let canUpload: Bool
    public let type: String
    public let isPro: Bool
    public let created: Date
    public let updated: Date
}

extension DBUser {
    public init?(dictionary: [String: Any] = [:]) {
        guard let id: String = dictionary.JSONValueForKey("id") else {
            return nil
        }

        self.id = id
        name = dictionary.JSONValueForKey("name") ?? ""
        username = dictionary.JSONValueForKey("username") ?? ""
        avatarUrl = dictionary.JSONValueForKey("avatar_url")
        htmlURL = dictionary.JSONValueForKey("html_url")
        bio = dictionary.JSONValueForKey("bio") ?? ""
        location = dictionary.JSONValueForKey("location") ?? ""
        bucketsCount = dictionary.JSONValueForKey("buckets_count") ?? 0
        commentsReceivedCount = dictionary.JSONValueForKey("comments_received_count") ?? 0
        followersCount = dictionary.JSONValueForKey("followers_count") ?? 0
        followingsCount = dictionary.JSONValueForKey("followings_count") ?? 0
        likesCount = dictionary.JSONValueForKey("likes_count") ?? 0
        likesReceived_count = dictionary.JSONValueForKey("likes_received_count") ?? 0
        projectsCount = dictionary.JSONValueForKey("projects_count") ?? 0
        reboundsReceivedCount = dictionary.JSONValueForKey("rebounds_received_count") ?? 0
        shotsСount = dictionary.JSONValueForKey("shots_count") ?? 0
        teamsСount = dictionary.JSONValueForKey("teams_count") ?? 0
        canUpload = dictionary.JSONValueForKey("can_upload_shot") ?? false
        type = dictionary.JSONValueForKey("type") ?? ""
        isPro = dictionary.JSONValueForKey("pro") ?? false
        created = dictionary.JSONValueForKey("created_at") ?? Date()
        updated = dictionary.JSONValueForKey("updated_at") ?? Date()
        if let linksDict = dictionary["links"] as? [String: String] {
            links = DBLink.links(from: linksDict)
        } else {
            links = nil
        }
    }
}

extension DBUser {
    static var currentUserRequest: Request<DBUser> {
        return Request(path: "user",
                       headers: Request<DBUser>.defaultHeaders,
                       parser: { data in
                           guard let dict = data as? [String: Any] else { return nil }
                           return DBUser(dictionary: dict)
        })
    }

    static func userRequest(id anID: String) -> Request<DBUser> {
        return Request(path: "users/\(anID)",
                       headers: Request<DBUser>.defaultHeaders,
                       parser: { data in
                           guard let dict = data as? [String: Any] else { return nil }
                           return DBUser(dictionary: dict)
        })
    }
}

extension DBUser: JSONValueType {
    public static func JSONValue(_ object: Any) -> DBUser? {
        guard let userDict = object as? [String: Any],
            let user = DBUser(dictionary: userDict) else { return nil }
        return user
    }
}

extension DBUser {
    public static func loadUser(id anID: String, callback: @escaping RequestCallback<DBUser>) {
        RequestSender.defaultSender.send(request: DBUser.userRequest(id: anID),
                                         callback: callback)
    }

    public static func loadCurrentUser(_ callback: @escaping RequestCallback<DBUser>) {
        RequestSender.defaultSender.send(request: DBUser.currentUserRequest,
                                         callback: callback)
    }
}
