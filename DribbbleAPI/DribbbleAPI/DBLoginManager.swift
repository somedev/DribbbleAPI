//
//  DBLoginManager.swift
//  DribbbleAPI
//
//  Created by Eduard Panasiuk on 8/23/16.
//  Copyright © 2016 somedev. All rights reserved.
//

import Foundation
import WebKit

public final class DBLoginManager {
    
    //MARK: - private
    private func clearCookies(_ callback:(()->())) {
        let store = WKWebsiteDataStore.default()
        store.fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            let filtered = records.filter({$0.displayName.contains("dribbble")})
            WKWebsiteDataStore.default().removeData(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes(),
                                                    for: filtered,
                                                    completionHandler: callback)
        }
    }
    
}
