//
//  ItemListViewModel.swift
//  ConvenienceStore
//
//  Created by kyo__hei on 2017/01/29.
//  Copyright © 2017年 kyo__hei. All rights reserved.
//

import Foundation
import Firebase
import Core_iOS
import then

internal final class ItemListViewModel<T: Item> {
    
    // MARK: Properties
    
    private let itemInteractor = ItemInteractor<T>()
    
    private let likeInteractor = LikeInteractor.shared

    private var items = [T]()
    

    // MARK: Initializer
    
    init() {
    }
    
    
    // MARK: Public Method
    
    func updateItems() -> Promise<Void> {
        return likeInteractor.updateLikes()
            .then(itemInteractor.fetchItems())
            .then { items in
                self.items = items
            }
    }
    
    func itemsCount() -> Int {
        return items.count
    }
    
    func items(at indexPath: IndexPath) -> T {
        return items[indexPath.row]
    }
    
    func likeInfo(at indexPath: IndexPath) -> (count: Int, isLiked: Bool) {
        let user = Auth.auth().currentUser!
        let item = items(at: indexPath)
        
        return (count: likeInteractor.likeCount(for: item),
                isLiked: likeInteractor.isLiked(for: item, by: user))
    }
    
    func likeItem(at indexPath: IndexPath) -> Promise<Int> {
        let user = Auth.auth().currentUser!
        let item = items(at: indexPath)
        return likeInteractor.sendLike(to: item, by: user)
    }

}
