//
//  ClassName.swift
//  ConvenienceStore
//
//  Created by kyo__hei on 2017/02/05.
//  Copyright © 2017年 kyo__hei. All rights reserved.
//

import Foundation

extension NSObject {
    
    @nonobjc class var className: String {
        let name = String(describing: self)
        let regex = try! NSRegularExpression(pattern: "<.+>", options: .allowCommentsAndWhitespace)
        return regex.stringByReplacingMatches(in: name, options: [], range: NSMakeRange(0, name.count), withTemplate: "")
    }
    
    @nonobjc var className: String {
        return type(of: self).className
    }
}
