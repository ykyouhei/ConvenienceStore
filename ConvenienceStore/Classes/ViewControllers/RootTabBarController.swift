//
//  RootTabBarController.swift
//  ConvenienceStore
//
//  Created by kyo__hei on 2017/01/29.
//  Copyright © 2017年 kyo__hei. All rights reserved.
//

import UIKit
import Firebase

internal final class RootTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        FIRAuth.auth()?.signInAnonymously { user, error in
            log.debug("\(user?.uid)")
            log.debug("\(error)")
        }

    }
    
    

}
