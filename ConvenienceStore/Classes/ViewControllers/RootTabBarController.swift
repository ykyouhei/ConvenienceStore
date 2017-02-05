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

internal final class RootTabBarController: UITabBarController {
    
    private(set) lazy var sevenElevenViewController: ItemsCollectionViewController<SevenElevenItem> = {
        let itemList = ItemListViewModel<SevenElevenItem>()
        let vc = ItemsCollectionViewController(itemList: itemList)
        let navigation = UINavigationController(rootViewController: vc)
        navigation.navigationItem.titleView = UIImageView(image: SevenElevenItem.logoImage)
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
        
        FIRAuth.auth()?.signInAnonymously { user, error in
            log.debug("\(user?.uid)")
            log.debug("\(error)")
        }
        
        let viewControllers: [UIViewController] = [
            UINavigationController(rootViewController: sevenElevenViewController),
            UINavigationController(rootViewController: familyMartViewController)
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
