//
//  DBLoginViewController.swift
//  DribbbleAPI
//
//  Created by Eduard Panasiuk on 8/23/16.
//  Copyright © 2016 somedev. All rights reserved.
//

import UIKit
import WebKit

public typealias DBLoginViewControllerCallback = ((String?, Bool)->())

public final class DBLoginViewController: UIViewController, WKNavigationDelegate {

    private var webView:WKWebView?
    private var callback:DBLoginViewControllerCallback?
    private var loadURL:URL?
    private var callbackURL:URL?
    
    public init(callback aCallback:@escaping DBLoginViewControllerCallback, loadURL:URL?, callbackURL:URL) {
        super.init(nibName:nil, bundle:nil)
        self.callback = aCallback
        self.loadURL = loadURL
        self.callbackURL = callbackURL
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
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel",
                                                           style: .done,
                                                           target: self,
                                                           action: #selector(DBLoginViewController.cancel))
        guard let webView = webView, let loadURL = self.loadURL else {
            callback?(nil, false)
            return
        }
        webView.load(URLRequest(url: loadURL))
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
        
        if(url.host == callbackURL?.host) {
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
    func cancel() {
        dismiss(animated: true) { 
            self.callback?(nil, false)
        }
    }
    
    private func loadEmptyHtml() {
        let _ = webView?.loadHTMLString(DBEmptyPageHTML, baseURL: nil)
    }
    
    private func proceedWith(code aCode:String) {
        dismiss(animated: true) {
            self.callback?(aCode, true)
        }
    }
}
