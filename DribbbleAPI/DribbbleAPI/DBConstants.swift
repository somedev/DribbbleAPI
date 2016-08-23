//
//  DBConstants.swift
//  DribbbleAPI
//
//  Created by Eduard Panasiuk on 8/23/16.
//  Copyright © 2016 somedev. All rights reserved.
//

import Foundation

internal let DBRedirectUri = "dribbble-api://callback"
internal let DBEmptyPageHTML = "<html><body bgcolor=\"#333333\"></body></html>"

//MARK: - API
internal let DBAPIEndpoint = URL(string: "https://api.dribbble.com/v1")!
internal let DBAPIOAuthEndpoint = URL(string: "https://dribbble.com/oauth")!

internal let DBAPITokenPath = "token"
internal let DBAPIAuthorizePath = "authorize"
