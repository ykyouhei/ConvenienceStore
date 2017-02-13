//
//  PlistKeys.swift
//  ConvenienceStore
//
//  Created by kyo__hei on 2017/02/12.
//  Copyright © 2017年 kyo__hei. All rights reserved.
//

import Foundation
import SwiftyConfiguration

// MARK: - GoogleService-Info.plist

let googleService: Configuration = {
    let plistPath = Bundle.main.path(forResource: "GoogleService-Info", ofType: "plist")!
    return  Configuration(plistPath: plistPath)!
}()

extension Keys {
    
    #if DEBUG
    static let adUnitIdForBanner = Key<String>("AD_UNIT_ID_FOR_BANNER_TEST")
    #else
    static let adUnitIdForBanner = Key<String>("AD_UNIT_ID_FOR_BANNER")
    #endif
   
}
