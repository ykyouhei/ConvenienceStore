//
//  ItemsCollectionViewController.swift
//  ConvenienceStore
//
//  Created by kyo__hei on 2017/01/29.
//  Copyright © 2017年 kyo__hei. All rights reserved.
//

import UIKit
import Firebase
import SwiftyJSON
import Hero

internal final class ItemsCollectionViewController: UIViewController {
    
    // MARK: Properties
    
    fileprivate lazy var sevenItems = [SevenItem]()
    
    fileprivate lazy var fbReference: FIRDatabaseReference = {
        return FIRDatabase.database().reference()
    }()
    
    
    // MARK: Outlet
    
    @IBOutlet private weak var collectionView: UICollectionView!
    
    
    // MARK: Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBarItem = UITabBarItem(
            title: "7 ELEVEN",
            image: #imageLiteral(resourceName: "icon_seven_eleven"),
            selectedImage: #imageLiteral(resourceName: "icon_seven_eleven").withRenderingMode(.alwaysOriginal))
        
        updateCollectionViewLayout()
        
        fbReference
            .child("seven_items/thisweek")
            .observeSingleEvent(
                of: .value,
                with: { snapshot in
                    let json = JSON(snapshot.value!)
                    
                    self.sevenItems = json.map { SevenItem(json: $1) }
                    
                    self.collectionView.reloadData()
                    
                },
                withCancel: { error in
                    log.error(error)
                })
    }
    
    
    // MARK: Private Method
    
    private func updateCollectionViewLayout() {
        let frameWidth  = UIScreen.main.bounds.width
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        
        let numberOfItemForLine = CGFloat(2)
        let space = CGFloat(8)
        
        let itemWidth  = (frameWidth - (space * (numberOfItemForLine + 1))) / numberOfItemForLine
        let itemHeight = itemWidth * 1.3
        
        layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        layout.minimumLineSpacing = space
        layout.minimumInteritemSpacing = space
        layout.sectionInset = UIEdgeInsets(
            top: space,
            left: space,
            bottom: space,
            right: space)
        
        collectionView.setCollectionViewLayout(layout, animated: true)
    }

}


extension ItemsCollectionViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sevenItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let sevenItem = sevenItems[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "itemCell",
                                                      for: indexPath) as! ItemCell
        
        cell.apply(sevenItem)
        
        return cell
    }
    
}


extension ItemsCollectionViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let sevenItem = sevenItems[indexPath.item]
        let detailVC = UIStoryboard(name: "Main", bundle: nil)
            .instantiateViewController(withIdentifier: "ItemDetailViewController") as! ItemDetailViewController
        
        detailVC.sevenItem = sevenItem
        
        navigationController?.isHeroEnabled = true
        
        navigationController?.show(detailVC, sender: nil)
        
        collectionView.deselectItem(at: indexPath, animated: false)
    }
    
}
