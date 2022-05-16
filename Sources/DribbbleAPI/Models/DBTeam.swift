//
//  DBTeam.swift
//  DribbbleAPI
//
//  Created by Eduard Panasiuk on 11/6/16.
//  Copyright © 2016 somedev. All rights reserved.
//

import Foundation

public struct DBTeam {
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
    public let canUpload: Bool
    public let type: String
    public let isPro: Bool
    public let created: Date
    public let updated: Date
}

// MARK: - custom initializer

extension DBTeam {
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

// MARK: - JSONValueType

extension DBTeam: JSONValueType {
    public static func JSONValue(_ object: Any) -> DBTeam? {
        guard let dict = object as? [String: Any],
            let team = DBTeam(dictionary: dict) else { return nil }
        return team
    }
}
