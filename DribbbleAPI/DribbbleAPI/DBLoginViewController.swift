//
//  DBLoginViewController.swift
//  DribbbleAPI
//
//  Created by Eduard Panasiuk on 8/23/16.
//  Copyright © 2016 somedev. All rights reserved.
//

import UIKit
import WebKit

public typealias DBLoginViewControllerCallback = ((String)->())

public final class DBLoginViewController: UIViewController, WKNavigationDelegate {

    private var webView:WKWebView?
    private var callback:DBLoginViewControllerCallback?
    private var clientID:String?
    
    public init(callback aCallback:DBLoginViewControllerCallback, clientID:String) {
        super.init(nibName:nil, bundle:nil)
        self.callback = aCallback
        self.clientID = clientID
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override public func loadView() {
        webView = WKWebView()
        webView?.navigationDelegate = self
        view = webView
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        loadEmptyHtml()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    //MARK: - WKNavigationDelegate
    public func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Swift.Void) {
        
        guard let url = navigationAction.request.url else {
            decisionHandler(.allow)
            return
        }
        
        if(url.absoluteString.contains(DBRedirectUri)) {
            decisionHandler(.cancel)
            loadEmptyHtml()
            guard let query = URLComponents(string: url.absoluteString)?.queryItems?.first,
                query.name == "code", let code = query.value else { return }
            proceedWith(code: code)
            return
        }
        
        decisionHandler(.allow);
    }
    
    //MARK: - private
    private func loadEmptyHtml() {
        let _ = webView?.loadHTMLString(DBEmptyPageHTML, baseURL: nil)
    }
    
    private func proceedWith(code aCode:String) {
        self.callback?(aCode)
    }
}
