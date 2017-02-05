//
//  Item+Presentation.swift
//  ConvenienceStore
//
//  Created by kyo__hei on 2017/02/05.
//  Copyright © 2017年 kyo__hei. All rights reserved.
//

import UIKit
import Core_iOS

// MARK: - プレゼンテーションロジックを拡張
extension Item {
    
    var launchDateString: String {
        let date = Date(timeIntervalSince1970: TimeInterval(launchDate))
        let format = "yyyy年MM月dd日"
        let formatter = DateFormatter()
        
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.dateFormat = format
        
        return formatter.string(from: date)
    }
    
    var taxIncludedPriceString: String {
        return L10n.Template.Label.includeTaxPrice(taxIncludedPrice)
    }
    
}
