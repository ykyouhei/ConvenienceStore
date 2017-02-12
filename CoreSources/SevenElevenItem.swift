//
//  SevenElevenItem.swift
//  ConvenienceStore
//
//  Created by kyo__hei on 2017/02/04.
//  Copyright © 2017年 kyo__hei. All rights reserved.
//

import Foundation

/// セブンイレブンの商品
public struct SevenElevenItem: Item {
    
    // MARK: Constants
    
    public static let dataBasePath = "/seven_items/thisweek"
    
    
    // MARK: Types
    
    public enum Area: Int {
        case 北海道
        case 東北
        case 関東
        case 甲信越・北陸
        case 東海
        case 近畿
        case 中国・四国
        case 九州
        
        public init(string: String) {
            switch string {
            case "北海道":      self = .北海道
            case "東北":        self = .東北
            case "関東":        self = .関東
            case "甲信越・北陸": self = .甲信越・北陸
            case "東海":        self = .東海
            case "近畿":        self = .近畿
            case "中国・四国":   self = .中国・四国
            case "九州":        self = .九州
            default:
                fatalError(string)
            }
        }
    }
    
    
    // MARK: Properties
    
    public let id: String
    public let title: String
    public let text: String
    public let imageURL: URL
    public let detailURL: URL
    public let taxIncludedPrice: Int
    public let taxExcludedPrice: Int
    public let launchDate: Int
    public let areas: Set<Area>
    
    
    // MARK: Computed Properties
    
    public var json: [String : Any] {
        var builder = baseJSON
        builder["areas"] = areas.map { $0.rawValue }
        return builder
    }
    
    
    // MARK: Initializer
    
    public init(id: String,
                title: String,
                text: String,
                imageURL: URL,
                detailURL: URL,
                taxIncludedPrice: Int,
                taxExcludedPrice: Int,
                launchDate: Int,
                areas: Set<Area>) {
        self.id                = id
        self.title             = title           
        self.text              = text            
        self.imageURL          = imageURL        
        self.detailURL         = detailURL       
        self.taxIncludedPrice  = taxIncludedPrice
        self.taxExcludedPrice  = taxExcludedPrice
        self.launchDate        = launchDate      
        self.areas             = areas
    }
    
    public init(json: [String : Any]) {
        self.id                = json["id"] as! String
        self.title             = json["title"] as! String
        self.text              = json["text"] as! String
        self.imageURL          = URL(string: (json["imageURL"] as! String))!
        self.detailURL         = URL(string: (json["detailURL"] as! String))!
        self.taxIncludedPrice  = json["taxIncludedPrice"] as! Int
        self.taxExcludedPrice  = json["taxExcludedPrice"] as! Int
        self.launchDate        = json["launchDate"] as! Int
        self.areas             = Set((json["areas"] as! [Int]).map({ Area(rawValue: $0)! }))
    }
    
}
