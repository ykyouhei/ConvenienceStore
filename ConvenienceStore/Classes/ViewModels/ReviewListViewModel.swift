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

internal final class ReviewListViewModel<T: Item> {
    
    // MARK: Properties
    
    private let reference: FIRDatabaseReference
    
    private(set) var allReviews: [Review] {
        didSet {
            self.reviews = allReviews.filter{ !$0.onlyRating }
        }
    }
    
    private(set) var reviews: [Review] 
    
    
    // MARK: Initializer
    
    init(item: T) {
        self.reference = FIRDatabase.database().reference()
            .child("reviews")
            .child(item.id)
        self.allReviews = []
        self.reviews    = []
    }
    
    
    // MARK: Public
    
    func fetch() -> Promise<[Review]> {
        return Promise { resolve, reject in
            self.reference.observeSingleEvent(
                of: .value,
                with: { snapshot in
                    guard let json = snapshot.value as? [String : [String : Any]] else {
                        self.allReviews = []
                        resolve(self.reviews)
                        return
                    }
                    
                    self.allReviews = json.map { Review(json: $1) }
                    
                    resolve(self.reviews)
                },
                withCancel: { error in
                    reject(error)
                })
        }
    }
    
    func reviewForCurrentUser() -> Review? {
        guard let currentUid = FIRAuth.auth()?.currentUser?.uid else { return nil }
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
