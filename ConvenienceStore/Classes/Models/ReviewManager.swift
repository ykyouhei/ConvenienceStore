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

internal final class ReviewManager {
    
    // MARK: Constants
    
    static let baseReference = FIRDatabase.database().reference().child("reviews")
    
    
    // MARK: Public 
    
    static func set<T: Item>(review: Review, for item: T) -> Promise<Review> {
        return Promise { resolve, reject in
            self.baseReference
                .child(item.id)
                .child(review.uid)
                .setValue(review.json) { error, reference in
                    if let error = error {
                        reject(error)
                    } else {
                        resolve(review)
                    }
                }
        }
    }
    
    
}
