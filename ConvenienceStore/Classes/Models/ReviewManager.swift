//
//  ReviewManager.swift
//  ConvenienceStore
//
//  Created by kyo__hei on 2017/02/12.
//  Copyright © 2017年 kyo__hei. All rights reserved.
//

import Firebase
import Core_iOS
import then
import RealmSwift

internal final class ReviewManager {
    
    // MARK: Constants
    
    static let baseReference: DatabaseReference = {
        let ref = Database.database().reference().child("reviews")
        ref.keepSynced(true)
        return ref
    }()
    
    
    // MARK: Public 
    
    /// レビューを送信する
    ///
    /// - Parameters:
    ///   - review: 送信するレビュー
    ///   - item:   レビュー対象のアイテム
    /// - Returns:  Promise<Review>
    static func send<T: Item>(review: Review, for item: T) -> Promise<Review> {
        return Promise { resolve, reject in
            self.baseReference
                .child(item.id)
                .child(review.reviewId)
                .setValue(review.json) { error, reference in
                    if let error = error {
                        reject(error)
                    } else {
                        resolve(review)
                    }
                }
        }
    }
    
    /// 対象のレビューを違反報告する
    ///
    /// - Parameter review: 報告するレビュー
    static func report(for review: Review) {
        let realm = try! Realm()
        let reportedReview = ReportedReview(review: review)
        try! realm.write {
            realm.add(reportedReview, update: true)
        }
    }
    
    
}
