//
//  DBScopeTests.swift
//  DribbbleAPI
//
//  Created by Eduard Panasiuk on 8/23/16.
//  Copyright © 2016 somedev. All rights reserved.
//

@testable import DribbbleAPI
import XCTest

class DBScopeTests: XCTestCase {
    func testScopeString() {
        let scopes: [DBScope] = [.Public, .comment, .upload, .write]
        XCTAssertEqual(DBScope.scopeString(from: scopes), "public+comment+upload+write")
    }
}
