//
//  Dictionary+Utils.swift
//  DribbbleAPI
//
//  Created by Eduard Panasiuk on 11/12/16.
//  Copyright © 2016 somedev. All rights reserved.
//

import Foundation

extension Dictionary {
    mutating func unionInPlace(
        dictionary: Dictionary<Key, Value>) {
        for (key, value) in dictionary {
            self[key] = value
        }
    }
}
