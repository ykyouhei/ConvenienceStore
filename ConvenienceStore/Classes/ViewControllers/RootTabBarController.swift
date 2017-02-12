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
    
    private(set) lazy var sevenElevenViewController: ItemsCollectionViewController<SevenElevenItem> = {
        let itemList = ItemListViewModel<SevenElevenItem>()
        let vc = ItemsCollectionViewController(itemList: itemList)
        vc.tabBarItem = self.tabBarItem(with: SevenElevenItem.self)
        return vc
    }()
    
    private(set) lazy var familyMartViewController: ItemsCollectionViewController<FamilyMartItem> = {
        let itemList = ItemListViewModel<FamilyMartItem>()
        let vc = ItemsCollectionViewController(itemList: itemList)
        vc.tabBarItem = self.tabBarItem(with: FamilyMartItem.self)
        return vc
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        isHeroEnabled = true
        
        FIRAuth.auth()?.signInAnonymously { user, error in
            log.debug("\(user?.uid)")
            log.debug("\(error)")
        }
        
        setupViewControllers()
    }
    
    private func setupViewControllers() {
        let sevenList = ItemListViewModel<SevenElevenItem>()
        sevenList.queryBlock = { ref in
            return ref.queryOrdered(byChild: "taxIncludedPrice")
        }
        let sevenVC = ItemsCollectionViewController(itemList: sevenList)
        let sevenNavigation = UINavigationController(rootViewController: sevenVC)
        sevenVC.tabBarItem = tabBarItem(with: SevenElevenItem.self)
        
        let famimaList = ItemListViewModel<FamilyMartItem>()
        let famimaVC = ItemsCollectionViewController(itemList: famimaList)
        let famimaNavigation = UINavigationController(rootViewController: famimaVC)
        famimaVC.tabBarItem = tabBarItem(with: FamilyMartItem.self)
        
        let viewControllers: [UIViewController] = [
            sevenNavigation,
            famimaNavigation
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
