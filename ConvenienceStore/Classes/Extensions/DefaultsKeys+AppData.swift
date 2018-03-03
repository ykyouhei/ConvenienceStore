//
//  DefaultsKeys+AppData.swift
//  ConvenienceStore
//
//  Created by kyo__hei on 2017/02/05.
//  Copyright © 2017年 kyo__hei. All rights reserved.
//

import Foundation
import SwiftyUserDefaults

extension DefaultsKeys {
    
    /// 地域情報
    static let region = DefaultsKey<Int?>("region")
   
    /// アプリ起動回数
    static let appLaunchCount = DefaultsKey<Int>("appLaunchCount")
    
    /// 商品閲覧回数
    static let itemViewCount = DefaultsKey<Int>("itemViewCount")
    
    /// いいねタップ回数
    static let likeActionCount = DefaultsKey<Int>("likeActionCount")
    
}
