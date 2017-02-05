//
//  HeroModifier+Default.swift
//  ConvenienceStore
//
//  Created by kyo__hei on 2017/02/05.
//  Copyright © 2017年 kyo__hei. All rights reserved.
//

import UIKit
import Hero

extension HeroModifier {
    
    public static func defaultSpring() -> HeroModifier {
        return .spring(stiffness: 1000, damping: 45)
    }
    
}
