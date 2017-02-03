//
//  ItemCell.swift
//  ConvenienceStore
//
//  Created by kyo__hei on 2017/01/29.
//  Copyright © 2017年 kyo__hei. All rights reserved.
//

import UIKit
import Kingfisher
import Hero

internal final class ItemCell: UICollectionViewCell {
    
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
    
    func apply(_ sevenItem: SevenItem) {
        imageView.kf.setImage(with: sevenItem.image)
        titleLabel.text = sevenItem.title
        priceLabel.text = sevenItem.priceText
        launchLabel.text = sevenItem.launchText
        
        imageView.heroID  = "image" + sevenItem.id
        titleLabel.heroID = "title" + sevenItem.id
        priceLabel.heroID = "price" + sevenItem.id
        launchLabel.heroID = "launch" + sevenItem.id
    }
    
}
