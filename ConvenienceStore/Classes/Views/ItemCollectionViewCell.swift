//
//  ItemCollectionViewCell.swift
//  ConvenienceStore
//
//  Created by kyo__hei on 2017/02/05.
//  Copyright © 2017年 kyo__hei. All rights reserved.
//

import UIKit
import Core_iOS

/// 商品を表示するCollectionViewCell
internal final class ItemCollectionViewCell: UICollectionViewCell {

    // MARK: Outlet
    
    @IBOutlet private weak var cardView: UIView!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var priceLabel: UILabel!
    @IBOutlet private weak var launchLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        clipsToBounds = false
        cardView.layer.shadowRadius  = 3
        cardView.layer.shadowOpacity = 0.1
        cardView.layer.shadowOffset  = .zero
        cardView.layer.cornerRadius  = 2
    }
    
    func apply(_ item: Item) {
        imageView.kf.setImage(with: item.imageURL)
        
        titleLabel.text  = item.title
        priceLabel.text  = item.taxIncludedPriceString
        launchLabel.text = item.launchDateString
        
        imageView.heroID   = "image" + item.id
        titleLabel.heroID  = "title" + item.id
        priceLabel.heroID  = "price" + item.id
        launchLabel.heroID = "launch" + item.id
        
        imageView.heroModifiers = [.defaultSpring()]
        titleLabel.heroModifiers = [.defaultSpring()]
        priceLabel.heroModifiers = [.defaultSpring()]
        launchLabel.heroModifiers = [.defaultSpring()]
    }

}
