//
//  String+Utils.swift
//  DribbbleAPI
//
//  Created by Eduard Panasiuk on 8/30/16.
//  Copyright © 2016 somedev. All rights reserved.
//

import Foundation

extension String {

    public static func requestStringFrom(dictionary dic: [String: Any]) -> String {
        var params: [String] = []
        for (k, v) in dic {
            params.append("\(k)=\(v)")
        }
        return params.joined(separator: "&")
    }
}
