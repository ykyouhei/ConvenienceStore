//
//  Review.swift
//  ConvenienceStore
//
//  Created by kyo__hei on 2017/02/12.
//  Copyright © 2017年 kyo__hei. All rights reserved.
//

import Foundation
import Firebase
import SwiftyJSON

internal struct Review: Equatable, CustomStringConvertible {
    
    let reviewId: String
    
    let uid: String
    
    let rating: Double
    
    let title: String
    
    let text: String
    
    let createTime: TimeInterval?
    
    var onlyRating: Bool {
        return title.isEmpty && text.isEmpty
    }
    
    init(uid: String, rating: Double, title: String, text: String) {
        self.reviewId   = UUID().uuidString
        self.uid        = uid
        self.rating     = rating
        self.title      = title
        self.text       = text
        self.createTime = nil
    }
    
    init(json: Any) {
        let json = JSON(json)
        self.reviewId   = json["reviewId"].stringValue
        self.uid        = json["uid"].stringValue
        self.rating     = json["rating"].doubleValue
        self.title      = json["title"].stringValue
        self.text       = json["text"].stringValue
        self.createTime = json["createTime"].double.flatMap{ TimeInterval($0) }
    }
    
    var json: [String : Any] {
        var j: [String : Any] = [
            "reviewId"      : reviewId,
            "uid"           : uid,
            "rating"        : rating,
            "title"         : title,
            "text"          : text
        ]
        
        if let createTime = createTime {
            j["createTime"] = createTime
        } else {
            j["createTime"] = FIRServerValue.timestamp()
        }
        
        return j
    }
    
    func updated(rating: Double, title: String, text: String) -> Review {
        var json: [String : Any] = [
            "reviewId"      : self.reviewId,
            "uid"           : self.uid,
            "rating"        : rating,
            "title"         : title,
            "text"          : text
        ]
        
        if let createTime = self.createTime {
            json["createTime"] = createTime
        }
        
        return Review(json: json)
    }
    
    internal static func ==(lhs: Review, rhs: Review) -> Bool {
        return lhs.reviewId == rhs.reviewId
    }
    
}
