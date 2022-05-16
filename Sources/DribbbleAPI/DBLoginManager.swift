//
//  DBLoginManager.swift
//  DribbbleAPI
//
//  Created by Eduard Panasiuk on 8/23/16.
//  Copyright © 2016 somedev. All rights reserved.
//

import Foundation
import WebKit

public typealias DBCallback = (() -> Void)
public typealias DBLoginCallback = ((Bool) -> Void)

public final class DBLoginManager {
    private let sender = RequestSender(baseURL: URL(string: DBAPIOAuthEndpoint)!)
    private let clientID: String
    private let clientSecret: String
    private let scopes: [DBScope]
    private let callbackURL: URL

    public init(clientID: String, clientSecret: String, callbackURL: URL, scopes: [DBScope] = [.Public]) {
        self.clientID = clientID
        self.clientSecret = clientSecret
        self.scopes = scopes
        self.callbackURL = callbackURL
        DBTokenStorage.shared.setup(client: clientID, secret: clientSecret)
    }

    public func login(from viewController: UIViewController, callback: @escaping DBLoginCallback) {
        let job: DBCallback = { [weak self] in
            guard let manager = self else { return }
            let controller = DBLoginViewController(callback: manager.controllerCallback(callback: callback),
                                                   loadURL: manager.makeAuthorizeURL(),
                                                   callbackURL: manager.callbackURL)
            let navigation = DBNavigationViewController(rootViewController: controller)
            viewController.present(navigation, animated: true, completion: nil)
        }
        logout(callback: job)
    }

    public func logout(callback: DBCallback?) {
        let keychainJob: DBCallback = { [weak self] in
            self?.clearKeychain(callback)
        }
        clearCookies(keychainJob)
    }

    public func isLoggedIn() -> Bool {
        return DBTokenStorage.shared.getToken() != nil
    }

    // MARK: - private

    private func controllerCallback(callback aCallback: @escaping DBLoginCallback) -> DBLoginViewControllerCallback {
        return { [weak self] code, success in
            guard let code = code, success == true else {
                aCallback(false)
                return
            }
            self?.getAccessTokenFrom(code: code, callback: aCallback)
        }
    }

    private func getAccessTokenFrom(code aCode: String, callback: @escaping DBLoginCallback) {
        sender.send(request: accessTokenRequestFrom(code: aCode)) { result in
            switch result {
            case let .success(token):
                DBTokenStorage.shared.setToken(token: token)
                callback(true)
            case let .failure(error):
                print("access token fetch error: \(error)")
                callback(false)
            }
        }
    }

    private func makeAuthorizeURL() -> URL? {
        let path = DBAPIOAuthEndpoint + "\(DBAPIAuthorizePath)?client_id=\(clientID)&scope=\(DBScope.scopeString(from: scopes))"
        return URL(string: path)
    }

    private func clearKeychain(_ callback: DBCallback?) {
        DBTokenStorage.shared.deleteToken()
        callback?()
    }

    private func accessTokenRequestFrom(code aCode: String) -> Request<String> {
        return Request(type: .POST,
                       path: DBAPITokenPath,
                       headers: [:],
                       params: ["client_id": clientID, "client_secret": clientSecret, "code": aCode],
                       parser: { data in
                           guard let dict = data as? [String: Any] else { return nil }
                           return dict["access_token"] as? String
        })
    }

    private func clearCookies(_ callback: DBCallback?) {
        let store = WKWebsiteDataStore.default()
        store.fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            let filtered = records.filter({ $0.displayName.contains("dribbble") })
            WKWebsiteDataStore.default().removeData(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes(),
                                                    for: filtered,
                                                    completionHandler: callback ?? {})
        }
    }
}
