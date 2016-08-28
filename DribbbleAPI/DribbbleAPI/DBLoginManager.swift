//
//  DBLoginManager.swift
//  DribbbleAPI
//
//  Created by Eduard Panasiuk on 8/23/16.
//  Copyright © 2016 somedev. All rights reserved.
//

import Foundation
import WebKit

public typealias DBCallback = (()->())
public typealias DBLoginCallback = ((Bool)->())

public final class DBLoginManager {
    
    private let clientID:String
    private let clientSecret:String
    private let scopes:[DBScope]
    private let callbackURL:URL
    
    public init(clientID:String, clientSecret:String, callbackURL:URL, scopes:[DBScope] = [.Public]) {
        self.clientID = clientID
        self.clientSecret = clientSecret
        self.scopes = scopes
        self.callbackURL = callbackURL
    }
    
    public func login(from viewController:UIViewController, callback:DBLoginCallback) {
        let job:DBCallback = { [weak self] in
            guard let manager = self else { return }
            let controller = DBLoginViewController(callback: manager.controllerCallback(callback:callback),
                                                   loadURL: manager.makeAuthorizeURL(),
                                                   callbackURL: manager.callbackURL)
            let navigation = UINavigationController(rootViewController: controller)
            viewController.present(navigation, animated: true, completion: nil)
        }
        clearCookies(job)
    }
    
    //MARK: - private
    private func controllerCallback(callback aCallback:DBLoginCallback) -> DBLoginViewControllerCallback {
        return { [weak self] code, success in
            guard let code = code, success == true else {
                aCallback(false)
                return
            }
            self?.getAccessTokenFrom(code: code, callback: aCallback)
        }
    }
    
    private func getAccessTokenFrom(code aCode:String, callback:DBLoginCallback) {
        var request = URLRequest(url: URL(string:DBAPIOAuthEndpoint + DBAPITokenPath)!)
        request.httpMethod = "POST"
        request.httpBody = "client_id=\(clientID)&client_secret=\(clientSecret)&code=\(aCode)".data(using: .utf8)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil,
                let data = data,
                let json = (try? JSONSerialization.jsonObject(with: data)) as? Dictionary<String, Any>
                else {
                    callback(false)
                    return
            }
            
            print("access token: \(json["access_token"]))")
            callback(true)
        }.resume()
    }
    
    private func makeAuthorizeURL() -> URL? {
        let path = DBAPIOAuthEndpoint + "\(DBAPIAuthorizePath)?client_id=\(clientID)&scope=\(DBScope.scopeString(from: scopes))"
        return URL(string: path)
    }
    
    private func clearCookies(_ callback:DBCallback) {
        let store = WKWebsiteDataStore.default()
        store.fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            let filtered = records.filter({$0.displayName.contains("dribbble")})
            WKWebsiteDataStore.default().removeData(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes(),
                                                    for: filtered,
                                                    completionHandler: callback)
        }
    }
    
}
