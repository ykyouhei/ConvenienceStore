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

internal struct Review {
    
    let uid: String
    
    let rating: Double
    
    let title: String
    
    let text: String
    
    let updateTime = FIRServerValue.timestamp()
    
    var onlyRating: Bool {
        return title.isEmpty && text.isEmpty
    }
    
    init(uid: String, rating: Double, title: String, text: String) {
        self.uid    = uid
        self.rating = rating
        self.title  = title
        self.text   = text
    }
    
    init(json: Any) {
        let json = JSON(json)
        self.uid    = json["uid"].stringValue
        self.rating = json["rating"].doubleValue
        self.title  = json["title"].stringValue
        self.text   = json["text"].stringValue
    }
    
    var json: [String : Any] {
        return [
            "uid"           : uid,
            "rating"        : rating,
            "title"         : title,
            "text"          : text,
            "updateTime"    : updateTime,
        ]
    }
    
}
