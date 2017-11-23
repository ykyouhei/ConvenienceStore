//
//  CustomStringConvertible+Default.swift
//  ConvenienceStore
//
//  Created by kyo__hei on 2017/02/03.
//  Copyright © 2017年 kyo__hei. All rights reserved.
//

import Foundation

public extension CustomStringConvertible {
    
    public var description : String {
        let type = "\(Swift.type(of: self))"
        let selfMirror = Mirror(reflecting: self)
        let property = selfMirror.children.reduce("") {
            $1.label != nil ? $0 + "    \($1.label!) = \($1.value)\n" : $0
        }
        
        return "<\(type)> {\n\(property)\n}"
    }
    
}
