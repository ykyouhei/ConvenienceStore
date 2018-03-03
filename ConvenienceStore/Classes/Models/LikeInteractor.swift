//
//  LikeInteractor.swift
//  ConvenienceStore
//
//  Created by kyo__hei on 2017/11/25.
//  Copyright © 2017年 kyo__hei. All rights reserved.
//

import Foundation
import Firebase
import Core_iOS
import then
import RealmSwift
import SwiftyUserDefaults

/// いいねを管理するモデル。
internal final class LikeInteractor {
    
    // MAKR: Types
    
    typealias ItemId = String
    typealias UserId = String
    
    // MARK: Properties
    
    static let shared = LikeInteractor()
    
    /// <itemId>/<userId>/date
    private var likes = [ItemId: [UserId]]()

    // MARK: Constants
    
    let baseReference: DatabaseReference = {
        let ref = Database.database().reference().child("likes")
        ref.keepSynced(true)
        return ref
    }()

    
    // MARK: Public
    
    func updateLikes() -> Promise<Void> {
        return Promise { resolve, reject in
            self.baseReference.observeSingleEvent(of: .value) { snapshot in
                guard let likes = snapshot.value as? [ItemId: [UserId: Int]] else {
                    resolve(())
                    return
                }
                
                self.likes = likes.mapValues { Array($0.keys) }

                log.verbose(self.likes)
                
                resolve(())
            }
        }
        
    }
    
    /// いいねを送信する
    ///
    /// - Parameters:
    ///   - item:   レビュー対象のアイテム
    /// - Returns:  Promise<Review>
    func sendLike<T: Item>(to item: T, by user: User) -> Promise<Int> {
        Defaults[.likeActionCount] += 1
        return Promise { resolve, reject in
            self.baseReference
                .child(item.id)
                .child(user.uid)
                .setValue(ServerValue.timestamp()) { error, reference in
                    if let error = error {
                        reject(error)
                    } else {
                        self.likes[item.id] == nil ?
                            self.likes[item.id] = [user.uid] :
                            self.likes[item.id]!.append(user.uid)
                        
                        resolve(self.likes[item.id]!.count)
                    }
            }
        }
    }
    
    func likeCount<T: Item>(for item: T) -> Int {
        return likes[item.id]?.count ?? 0
    }
    
    func isLiked<T: Item>(for item: T, by user: User) -> Bool {
        return likes[item.id]?.contains(user.uid) ?? false
    }

}
