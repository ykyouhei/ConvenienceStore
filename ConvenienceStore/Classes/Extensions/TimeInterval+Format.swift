//
//  TimeInterval+Format.swift
//  ConvenienceStore
//
//  Created by kyo__hei on 2017/02/18.
//  Copyright © 2017年 kyo__hei. All rights reserved.
//

import Foundation

enum Format: String {
    case ymd = "yyyy年MM月dd日"
}

extension TimeInterval {
    
    func string(with format: Format) -> String {
        let date = Date(timeIntervalSince1970: self)
        let formatter = DateFormatter()
        
        formatter.calendar   = Calendar(identifier: .gregorian)
        formatter.dateFormat = format.rawValue
        
        return formatter.string(from: date)
    }
    
}
