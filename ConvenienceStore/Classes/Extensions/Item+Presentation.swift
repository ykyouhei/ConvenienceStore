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
        return TimeInterval(launchDate).string(with: .ymd)
    }
    
    var taxIncludedPriceString: String {
        return L10n.Template.Label.includeTaxPrice(taxIncludedPrice)
    }
    
}
