//
//  StoreInformation.swift
//  ConvenienceStore
//
//  Created by kyo__hei on 2017/02/04.
//  Copyright © 2017年 kyo__hei. All rights reserved.
//

import UIKit
import Core_iOS

/// コンビニ店舗情報を返す
protocol StoreInformation {
    
    static var iconImage: UIImage { get }
    static var logoImage: UIImage { get }
    static var name: String { get }
    
}

extension SevenElevenItem: StoreInformation {
    
    static let iconImage = #imageLiteral(resourceName: "icon_seven_eleven")
    
    static let logoImage = #imageLiteral(resourceName: "logo_seven_eleven")
    
    static let name = L10n.Common.Title.seveneleven
    
    
}

extension FamilyMartItem: StoreInformation {
    
    static let iconImage = #imageLiteral(resourceName: "icon_familymart")
    
    static let logoImage = #imageLiteral(resourceName: "logo_familymart")
    
    static let name = L10n.Common.Title.familymart
    
    
}
