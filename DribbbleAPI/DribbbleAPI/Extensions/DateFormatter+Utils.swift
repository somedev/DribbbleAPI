//
//  DateFormatter+Utils.swift
//  DribbbleAPI
//
//  Created by Eduard Panasiuk on 9/5/16.
//  Copyright © 2016 somedev. All rights reserved.
//

import Foundation

extension DateFormatter {
    @nonobjc public static var dbFormatter: DateFormatter = {
        var formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()
}
