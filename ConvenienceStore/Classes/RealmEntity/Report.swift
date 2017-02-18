//
//  Report.swift
//  ConvenienceStore
//
//  Created by kyo__hei on 2017/02/14.
//  Copyright © 2017年 kyo__hei. All rights reserved.
//

import Foundation
import RealmSwift

/// 報告済みレビュー
internal final class ReportedReview: Object {
    
    private(set) dynamic var reviewId = ""
    
    convenience init(review: Review) {
        self.init()
        reviewId = review.reviewId
    }
    
    override static func primaryKey() -> String? {
        return #keyPath(ReportedReview.reviewId)
    }
    
    override static func indexedProperties() -> [String] {
        return [#keyPath(ReportedReview.reviewId)]
    }
    
}
