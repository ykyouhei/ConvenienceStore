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
    
    private(set) var reviews: [Review]
    
    
    // MARK: Initializer
    
    init(item: T) {
        self.reference = FIRDatabase.database().reference()
            .child("reviews")
            .child(item.id)
        self.reviews = []
    }
    
    
    // MARK: Public
    
    func fetch() -> Promise<[Review]> {
        return Promise { resolve, reject in
            self.reference.observeSingleEvent(
                of: .value,
                with: { snapshot in
                    guard let json = snapshot.value as? [String : [String : Any]] else {
                        self.reviews = []
                        resolve([])
                        return
                    }
                    let reviews = json.map { Review(json: $1) }
                    self.reviews = reviews
                    resolve(reviews)
                },
                withCancel: { error in
                    reject(error)
                })
        }
    }
    
    func reviewForCurrentUser() -> Review? {
        guard let currentUid = FIRAuth.auth()?.currentUser?.uid else { return nil }
        return reviews.filter{ $0.uid == currentUid }.first
    }
    
    func averageRating() -> Double {
        guard !reviews.isEmpty else { return 0 }
        return reviews.reduce(0){ $0 + $1.rating} / Double(reviews.count)
    }
    
    func numberOfAllReviews() -> Int {
        return reviews.count
    }
    
    func numberOfReviews(forRating rating: Double) -> Int {
        return reviews.filter{ Int($0.rating) == Int(rating) }.count
    }
    
    func progress(forRating rating: Double) -> Float {
        guard !reviews.isEmpty else { return 0 }
        return Float(numberOfReviews(forRating: rating)) / Float(reviews.count)
    }
    
}
