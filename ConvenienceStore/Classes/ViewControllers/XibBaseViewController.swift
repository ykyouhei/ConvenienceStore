//
//  XibBaseViewController.swift
//  ConvenienceStore
//
//  Created by kyo__hei on 2017/02/05.
//  Copyright © 2017年 kyo__hei. All rights reserved.
//

import UIKit
import SVProgressHUD
import GoogleMobileAds
import FirebaseAnalytics

internal class XibBaseViewController: UIViewController {
    
    /// top,bottomLayoutGuideを設定するView
    @IBOutlet private weak var contentView: UIView?
    
    @IBInspectable private var isActiveTopLayoutGuid: Bool    = false
    @IBInspectable private var isActiveBottomLayoutGuid: Bool = false
    
    var screenName: String {
       return type(of: self).className
    }
    
    init() {
        let name = type(of: self).className
        super.init(nibName: name, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        contentView?.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor).isActive    = isActiveTopLayoutGuid
        contentView?.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor).isActive = isActiveBottomLayoutGuid
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        FIRAnalytics.setScreenName(screenName, screenClass: String(describing: type(of: self)))
    }
    
    let showError: (Error) -> Void = { error in
        log.error("\(error)")
        SVProgressHUD.showError(withStatus: "\(error.localizedDescription)")
    }

}
