//
//  DBShot.swift
//  DribbbleAPI
//
//  Created by Eduard Panasiuk on 9/5/16.
//  Copyright © 2016 somedev. All rights reserved.
//

import Foundation

public enum DBList: String {
    case animated
    case attachments
    case debuts
    case playoffs
    case rebounds
    case teams
}

public enum DBTimeFrame: String {
    case week
    case month
    case year
    case ever
}

public enum DBSort: String {
    case comments
    case recent
    case views
}

public struct DBShotUpdateParams {
    public let title: String?
    public let description: String?
    public let teamID: String?
    public let tags: [String]?
    
    public var params: [String: Any] {
        var result: [String: Any] = [:]
        if let title = self.title {
            result["title"] = title
        }
        if let description = self.description {
            result["description"] = description
        }
        if let teamID = self.teamID {
            result["teamID"] = teamID
        }
        if let tags = self.tags {
            let tagsString: String = tags.reduce("", { acc, value in
                acc + "," + value
            })
            
            result["tags"] = tagsString
        }
        return result
    }
}

public struct DBShotRequestParams {
    public let list: DBList?
    public let timeFrame: DBTimeFrame?
    public let date: Date?
    public let sort: DBSort?
    
    private static var dateFormatter: DateFormatter = {
        var formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-DD"
        return formatter
    }()
    
    public init(list: DBList? = nil, timeFrame: DBTimeFrame? = nil,
                date: Date? = nil, sort: DBSort? = nil) {
        self.list = list
        self.timeFrame = timeFrame
        self.date = date
        self.sort = sort
    }
    
    public var params: [String: Any] {
        var result: [String: Any] = [:]
        if let list = self.list {
            result["list"] = list.rawValue
        }
        if let timeFrame = self.timeFrame {
            result["timeframe"] = timeFrame.rawValue
        }
        if let sort = self.sort {
            result["sort"] = sort.rawValue
        }
        if let date = self.date {
            result["date"] = DBShotRequestParams.dateFormatter.string(from: date)
        }
        return result
    }
}

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
    static func currentUserShots(page: DBPage = DBPage()) -> Request<[DBShot]> {
        return Request(path: "user/shots",
                       headers: Request<DBShot>.defaultHeaders,
                       params: page.params,
                       parser: { data in
            guard let arr = data as? [[String: Any]] else { return nil }
            return arr.compactMap({ DBShot(dictionary: $0) })
        })
    }
    
    static func userShots(id: String, page: DBPage = DBPage()) -> Request<[DBShot]> {
        return Request(path: "user/\(id)/shots",
                       headers: Request<DBShot>.defaultHeaders,
                       params: page.params,
                       parser: { data in
            guard let arr = data as? [[String: Any]] else { return nil }
            return arr.compactMap({ DBShot(dictionary: $0) })
        })
    }
    
    static func getShot(id: String) -> Request<DBShot> {
        return Request(path: "shots/\(id)",
                       headers: Request<DBShot>.defaultHeaders,
                       parser: { data in
            guard let data = data as? [String: Any] else { return nil }
            return DBShot(dictionary: data)
        })
    }
    
    static func deleteShot(id: String) -> Request<Bool> {
        return Request(type: .DELETE,
                       path: "shots/\(id)",
                       headers: Request<DBShot>.defaultHeaders,
                       parser: { _ in true })
    }
    
    static func updateShot(id: String, params: DBShotUpdateParams) -> Request<Bool> {
        return Request(type: .PUT,
                       path: "shots/\(id)",
                       headers: Request<DBShot>.defaultHeaders,
                       params: params.params,
                       parser: { _ in true })
    }
    
    static func popularShots(params: DBShotRequestParams? = nil, page: DBPage = DBPage()) ->
    Request<[DBShot]> {
        var totalParams = page.params
        if let additional = params?.params {
            totalParams.unionInPlace(dictionary: additional)
        }
        
        return Request(path: "shots",
                       headers: Request<DBShot>.defaultHeaders,
                       params: totalParams,
                       parser: { data in
            guard let arr = data as? [[String: Any]] else { return nil }
            return arr.compactMap({ DBShot(dictionary: $0) })
        })
    }
}

extension DBShot {
    public static func getShot(id: String, callback: @escaping RequestCallback<DBShot>) {
        RequestSender.defaultSender.send(request: DBShot.getShot(id: id),
                                         callback: callback)
    }
    
    public static func deleteShot(id: String, callback: @escaping RequestCallback<Bool>) {
        RequestSender.defaultSender.send(request: DBShot.deleteShot(id: id),
                                         callback: callback)
    }
    
    public static func updateShot(id: String, params: DBShotUpdateParams, callback: @escaping RequestCallback<Bool>) {
        RequestSender.defaultSender.send(request: DBShot.updateShot(id: id, params: params),
                                         callback: callback)
    }
    
    public static func loadUserShots(userID id: String,
                                     page: DBPage = DBPage(),
                                     callback: @escaping RequestCallback<[DBShot]>) {
        RequestSender.defaultSender.send(request: DBShot.userShots(id: id, page: page),
                                         callback: callback)
    }
    
    public static func loadCurrentUserShots(page: DBPage = DBPage(),
                                            callback: @escaping RequestCallback<[DBShot]>) {
        RequestSender.defaultSender.send(request: DBShot.currentUserShots(page: page),
                                         callback: callback)
    }
    
    public static func loadPopularShots(params: DBShotRequestParams? = nil,
                                        page: DBPage = DBPage(),
                                        callback: @escaping RequestCallback<[DBShot]>) {
        RequestSender.defaultSender.send(request: DBShot.popularShots(params: params, page: page),
                                         callback: callback)
    }
}
