//
//  LawsonItem.swift
//  ConvenienceStore
//
//  Created by kyo__hei on 2017/02/19.
//  Copyright © 2017年 kyo__hei. All rights reserved.
//

import Foundation

/// LAWSONの商品情報
public struct LawsonItem: Item {
    
    // MARK: Constants
    
    public static let dataBasePath = "/lawson_items/thisweek"
    
    
    // MARK: Properties
    
    public let id: String
    
    public let title: String
    
    public let text: String
    
    public let imageURL: URL
    
    public let detailURL: URL
    
    public let taxIncludedPrice: Int
    
    public let taxExcludedPrice: Int
    
    public let launchDate: Int
    

    // MARK: Initializer
    
    public init(id: String,
                title: String,
                text: String,
                imageURL: URL,
                detailURL: URL,
                taxIncludedPrice: Int,
                taxExcludedPrice: Int,
                launchDate: Int) {
        self.id                = id
        self.title             = title
        self.text              = text
        self.imageURL          = imageURL
        self.detailURL         = detailURL
        self.taxIncludedPrice  = taxIncludedPrice
        self.taxExcludedPrice  = taxExcludedPrice
        self.launchDate        = launchDate
    }
    
}
