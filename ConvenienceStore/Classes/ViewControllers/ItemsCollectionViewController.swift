//
//  ItemsCollectionViewController.swift
//  ConvenienceStore
//
//  Created by kyo__hei on 2017/01/29.
//  Copyright © 2017年 kyo__hei. All rights reserved.
//

import UIKit
import Firebase
import Hero
import Core_iOS
import SVProgressHUD

internal final class ItemsCollectionViewController<T: Item>:
    XibBaseViewController,
    UICollectionViewDelegate,
    UICollectionViewDataSource where T: StoreInformation
{
    
    // MAKR: Constant
    
    private let cellName = ItemCollectionViewCell.className
    
    
    // MARK: Properties
    
    let itemList: ItemListViewModel<T>
    
    
    // MARK: Outlet
    
    @IBOutlet private weak var collectionView: UICollectionView!
    
    
    // MARK: Initializer
    
    init(itemList: ItemListViewModel<T>) {
        self.itemList = itemList
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.titleView = UIImageView(image: T.logoImage)
        
        updateCollectionViewLayout()
        
        collectionView.register(UINib(nibName: cellName, bundle: nil),
                                forCellWithReuseIdentifier: cellName)
        
        setupRefreshControl()
        
        reloadList()
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
    
    private func setupRefreshControl() {
        let refreshControl: UIRefreshControl = {
            let r = UIRefreshControl()
            r.addTarget(self,
                        action: #selector(reloadList(sender:)),
                        for: .valueChanged)
            return r
        }()
        
        if #available(iOS 10.0, *) {
            collectionView.refreshControl = refreshControl
        } else {
            collectionView.addSubview(refreshControl)
        }
    }
    
    
    func reloadList(sender: UIRefreshControl? = nil) {
        SVProgressHUD.show()
        sender?.beginRefreshing()
        
        itemList
            .fetch()
            .onError(showError)
            .finally{
                SVProgressHUD.dismiss()
                sender?.endRefreshing()
                self.collectionView.reloadData()
        }
    }

    
    // MARK: - UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemList.items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = itemList.items[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellName,
                                                      for: indexPath) as! ItemCollectionViewCell
        
        cell.apply(item)
        
        return cell
    }
    
    
    // MARK: - UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = itemList.items[indexPath.item]
        let detailVC = ItemDetailViewController(item: item)
        
        navigationController?.isHeroEnabled = true
        navigationController?.pushViewController(detailVC, animated: true)
        
        collectionView.deselectItem(at: indexPath, animated: false)
    }
    
}
