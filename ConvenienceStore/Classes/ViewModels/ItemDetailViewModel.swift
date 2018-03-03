//
//  ItemDetailViewModel.swift
//  ConvenienceStore
//
//  Created by kyo__hei on 2017/11/26.
//  Copyright © 2017年 kyo__hei. All rights reserved.
//

import Core_iOS
import Firebase
import then

internal final class ItemDetailViewModel<T: Item> {
    
    // MAKR: - Dependencies
    
    private let likeInteractor = LikeInteractor.shared
    
    
    // MAKR: - Properties
    
    let item: T
    
    private(set) var likeInfo: (count: Int, isLiked: Bool)
    
    
    // MARK: - Initializer
    
    init(item: T, likeInfo: (count: Int, isLiked: Bool)) {
        self.item = item
        self.likeInfo = likeInfo
    }
    
    
    // MARK: - Public

    func likeItem() -> Promise<Void> {
        let user = Auth.auth().currentUser!
        return likeInteractor
            .sendLike(to: item, by: user)
            .then { likeCount in
                self.likeInfo = (count: likeCount, isLiked: true)
            }
    }

    
}
