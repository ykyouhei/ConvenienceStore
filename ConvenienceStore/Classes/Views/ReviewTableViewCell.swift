//
//  ReviewTableViewCell.swift
//  ConvenienceStore
//
//  Created by kyo__hei on 2017/02/12.
//  Copyright © 2017年 kyo__hei. All rights reserved.
//

import UIKit
import Cosmos

internal final class ReviewTableViewCell: UITableViewCell {
    
    // MARK: Outlet
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var cosmosView: CosmosView!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var textView: UITextView!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        cosmosView.settings.starSize   = 10
        cosmosView.settings.starMargin = 1
    }
    
    func update(review: Review) {
        titleLabel.text     = review.title
        cosmosView.rating   = review.rating
        dateLabel.text      = "YYYY/MM/dd"
        textView.text       = review.text
    }
    
}
