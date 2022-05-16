//
//  DBPage.swift
//  DribbbleAPI
//
//  Created by Eduard Panasiuk on 11/12/16.
//  Copyright © 2016 somedev. All rights reserved.
//

import Foundation

public struct DBPage {
    public let page: UInt
    public let itemsPerPage: UInt

    public init(page: UInt = 1, itemsPerPage: UInt = 100) {
        self.page = page
        self.itemsPerPage = itemsPerPage
    }

    public var params: [String: Any] {
        var result: [String: Any] = [:]
        result["page"] = page
        result["per_page"] = itemsPerPage
        return result
    }
}
