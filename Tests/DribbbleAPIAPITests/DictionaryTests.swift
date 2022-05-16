//
//  DictionaryTests.swift
//  DribbbleAPI
//
//  Created by Eduard Panasiuk on 11/12/16.
//  Copyright © 2016 somedev. All rights reserved.
//

@testable import DribbbleAPI
import XCTest

class DictionaryTests: XCTestCase {
    func testDictionaryMerge() {
        var testDict = ["foo": "bar", "faz": "baz"]
        let dicToJoin = ["me": "you", "foo": "bar2"]
        XCTAssertEqual(testDict["foo"], "bar")
        testDict.unionInPlace(dictionary: dicToJoin)
        XCTAssertEqual(testDict["foo"], "bar2")
        XCTAssertEqual(testDict.keys.count, 3)
    }
}
