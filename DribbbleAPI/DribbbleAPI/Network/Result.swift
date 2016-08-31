//
//  Result.swift
//  DribbbleAPI
//
//  Created by Eduard Panasiuk on 8/30/16.
//  Copyright © 2016 somedev. All rights reserved.
//

import Foundation

public enum Result<T> {
    case Success(T)
    case Failure(Error)
}
