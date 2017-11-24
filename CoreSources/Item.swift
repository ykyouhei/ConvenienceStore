//
//  Item.swift
//  ConvenienceStore
//
//  Created by kyo__hei on 2017/02/03.
//  Copyright © 2017年 kyo__hei. All rights reserved.
//

import Foundation

/// コンビニの商品用プロトコル
public protocol Item: CustomStringConvertible, Hashable, Codable {
    
    /// Firebase Realtime Database のパス
    static var dataBasePath: String { get }
    
    /// アイテムを一意に示すID
    var id: String { get }
    
    /// 商品名
    var title: String { get }
    
    /// 商品説明
    var text: String { get }
    
    /// 商品画像URL
    var imageURL: URL { get }
    
    /// 商品詳細ページURL
    var detailURL: URL { get }
    
    /// 税込み価格
    var taxIncludedPrice: Int { get }
    
    /// 税抜き価格
    var taxExcludedPrice: Int { get }
    
    /// 発売日
    var launchDate: Int { get }
    
}

extension Item {
    
    public var hashValue: Int {
        return Int(id)!
    }
    
}

public func ==<T: Item>(lhs: T, rhs: T) -> Bool {
    return lhs.id == rhs.id
}
