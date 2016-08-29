//
//  ViewController.swift
//  DribbbleAPI-Example
//
//  Created by Eduard Panasiuk on 8/23/16.
//  Copyright © 2016 somedev. All rights reserved.
//

import UIKit
import DribbbleAPI

class ViewController: UIViewController {

    let manager = DBLoginManager(clientID: "efb0eafb4713dd79409d3448771adb52d1678aae2f5df6a8320c4e4fa250fb82",
                                 clientSecret: "31a6e66309707fe6c5ef57f9de68a1aab1341bea9802e4edf057215e1c2f4a30",
                                 callbackURL: URL(string:"dribbbleapi://phone-callback")!)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UINavigationBar.appearance(whenContainedInInstancesOf: [DBNavigationViewController.self]).tintColor = UIColor.white
        UINavigationBar.appearance(whenContainedInInstancesOf: [DBNavigationViewController.self]).barTintColor = UIColor(colorLiteralRed: 0.2, green: 0.2, blue: 0.2, alpha: 1)
        UINavigationBar.appearance(whenContainedInInstancesOf: [DBNavigationViewController.self]).isTranslucent = false

    }

    //MARK: - actions
    @IBAction func login(_ sender: AnyObject) {
        manager.login(from: self, callback: {result in
            print("login result: \(result)")
        })
    }
    

}

