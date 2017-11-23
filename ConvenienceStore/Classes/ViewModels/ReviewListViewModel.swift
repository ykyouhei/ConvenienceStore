//
//  ReviewListViewModel.swift
//  ConvenienceStore
//
//  Created by kyo__hei on 2017/02/12.
//  Copyright © 2017年 kyo__hei. All rights reserved.
//

import Firebase
import Core_iOS
import then

/// レビュー一覧を表すViewModel
internal final class ReviewListViewModel<T: Item> {
    
    // MARK: Properties
    
    private let reference: DatabaseReference
    
    private let reportedReviewIds: [String]
    
    private(set) var allReviews: [Review] {
        didSet {
            self.reviews = allReviews
                .filter{ !($0.onlyRating || reportedReviewIds.contains($0.reviewId)) }
        }
    }
    
    private(set) var reviews: [Review]
    
    
    // MARK: Initializer
    
    init(item: T, reportedReviewIds: [String]) {
        self.reference = Database.database().reference()
            .child("reviews")
            .child(item.id)
        self.reference.keepSynced(true)
        self.allReviews = []
        self.reviews    = []
        self.reportedReviewIds = reportedReviewIds
    }
    
    
    // MARK: Public
    
    func fetch() -> Promise<[Review]> {
        return Promise { resolve, reject in
            self.reference.queryOrdered(byChild: "createDate").observeSingleEvent(
                of: .value,
                with: { snapshot in
                    self.allReviews = snapshot.children.reversed().flatMap { snap -> Review? in
                        guard let json = (snap as? DataSnapshot)?.value as? [String : Any] else {
                            return nil
                        }
                        return Review(json: json)
                    }
                    
                    resolve(self.reviews)
                },
                withCancel: { error in
                    reject(error)
                })
        }
    }
    
    // MARK: Operation
    
    func remove(at index: Int) -> Review {
        return reviews.remove(at: index)
    }
    
    /// 同一レビューがある場合は更新、ない場合は新規追加
    func insert(review: Review) {
        if let index = allReviews.index(of: review) {
            allReviews[index] = review
        } else {
            allReviews.insert(review, at: 0)
        }
    }
    
    // MARK: Presentation
    
    func reviewForCurrentUser() -> Review? {
        guard let currentUid = Auth.auth().currentUser?.uid else { return nil }
        return allReviews.filter{ $0.uid == currentUid }.first
    }
    
    func averageRating() -> Double {
        guard !allReviews.isEmpty else { return 0 }
        return allReviews.reduce(0){ $0 + $1.rating} / Double(allReviews.count)
    }
    
    func numberOfAllReviews() -> Int {
        return allReviews.count
    }
    
    func numberOfReviews(forRating rating: Double) -> Int {
        return allReviews.filter{ Int($0.rating) == Int(rating) }.count
    }
    
    func progress(forRating rating: Double) -> Float {
        guard !allReviews.isEmpty else { return 0 }
        return Float(numberOfReviews(forRating: rating)) / Float(allReviews.count)
    }
    
}
