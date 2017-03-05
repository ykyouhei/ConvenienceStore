//
//  RootTabBarController.swift
//  ConvenienceStore
//
//  Created by kyo__hei on 2017/01/29.
//  Copyright © 2017年 kyo__hei. All rights reserved.
//

import UIKit
import Firebase
import Core_iOS
import SwiftyUserDefaults

internal final class RootTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        FIRAuth.auth()?.signInAnonymously { user, error in
            log.debug("\(user?.uid)")
            log.debug("\(error)")
        }
        
        setupViewControllers()
    }
    
    private func setupViewControllers() {
        let sevenList        = ItemListViewModel<SevenElevenItem>()
        let sevenVC          = ItemsCollectionViewController(itemList: sevenList)
        let sevenNavigation  = UINavigationController(rootViewController: sevenVC)
        sevenVC.tabBarItem   = tabBarItem(with: SevenElevenItem.self)
        
        let famimaList       = ItemListViewModel<FamilyMartItem>()
        let famimaVC         = ItemsCollectionViewController(itemList: famimaList)
        let famimaNavigation = UINavigationController(rootViewController: famimaVC)
        famimaVC.tabBarItem  = tabBarItem(with: FamilyMartItem.self)
        
        let lawsonList       = ItemListViewModel<LawsonItem>()
        let lawsonVC         = ItemsCollectionViewController(itemList: lawsonList)
        let lawsonNavigation = UINavigationController(rootViewController: lawsonVC)
        lawsonVC.tabBarItem  = tabBarItem(with: LawsonItem.self)
        
        let viewControllers: [UIViewController] = [
            sevenNavigation,
            famimaNavigation,
            lawsonNavigation
        ]
        
        setViewControllers(viewControllers, animated: false)
    }
    
    private func tabBarItem(with type: StoreInformation.Type) -> UITabBarItem {
        return UITabBarItem(
            title: type.name,
            image: type.iconImage,
            selectedImage: type.iconImage.withRenderingMode(.alwaysOriginal))
    }

}
