//
//  ItemDetailTableViewCell.swift
//  ConvenienceStore
//
//  Created by kyo__hei on 2017/02/12.
//  Copyright © 2017年 kyo__hei. All rights reserved.
//

import UIKit
import Cosmos
import Core_iOS

internal protocol ItemDetailTableViewCellDelegate: class {
    
    func itemDetailTableViewCellDidTapReview(_ cell: ItemDetailTableViewCell)
    
}

internal final class ItemDetailTableViewCell: UITableViewCell {
    
    // MARK: Properties
    
    weak var delegate: ItemDetailTableViewCellDelegate?
    
    
    // MARK: Outlet
    
    @IBOutlet private weak var detailImageView: UIImageView!
    
    @IBOutlet private weak var titleLabel: UILabel!
    
    @IBOutlet private weak var priceLabel: UILabel!
    
    @IBOutlet private weak var launchLabel: UILabel!
    
    @IBOutlet private weak var detailLabel: UILabel!
    
    @IBOutlet private weak var ratingCountLabel: UILabel!
    
    @IBOutlet private weak var cosmosView: CosmosView!
    
    @IBOutlet private var baseCosmosViews: [CosmosView]!
    
    @IBOutlet private var progressView: [UIProgressView]!
    
    
    @IBAction func didTapReviewButton(_ sender: UIButton) {
        delegate?.itemDetailTableViewCellDidTapReview(self)
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        baseCosmosViews.enumerated().forEach {
            $1.rating = Double($0)
            $1.settings.starSize          = 11
            $1.settings.starMargin        = 1
            $1.settings.emptyColor        = #colorLiteral(red: 0.4756349325, green: 0.4756467342, blue: 0.4756404161, alpha: 1)
            $1.settings.emptyBorderColor  = #colorLiteral(red: 0.4756349325, green: 0.4756467342, blue: 0.4756404161, alpha: 1)
            $1.settings.filledColor       = #colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 1)
            $1.settings.filledBorderColor = #colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 1)
        }
        
        cosmosView.settings.starSize   = 11
        cosmosView.settings.starMargin = 1
    }
    
    
    func update<T: Item>(item: T, reviewList: ReviewListViewModel<T>) {
        detailImageView.kf.setImage(with: item.imageURL)
        titleLabel.text = item.title
        priceLabel.text = item.taxIncludedPriceString
        launchLabel.text = item.launchDateString
        detailLabel.text = item.text
        
        detailImageView.heroID = "image" + item.id
        titleLabel.heroID = "title" + item.id
        priceLabel.heroID = "price" + item.id
        launchLabel.heroID = "launch" + item.id
        
        detailImageView.heroModifiers = [.defaultSpring()]
        titleLabel.heroModifiers = [.defaultSpring()]
        priceLabel.heroModifiers = [.defaultSpring()]
        launchLabel.heroModifiers = [.defaultSpring()]
        detailLabel.heroModifiers = [.translate(x:0, y:100), .scale(0.5), .defaultSpring()]
        
        progressView.enumerated().forEach { index, progressView in
            progressView.progress = reviewList.progress(forRating: Double(index + 1))
            
        }
        
        cosmosView.rating = reviewList.averageRating()
    
        ratingCountLabel.text = L10n.Review.Template.reviewCount(reviewList.numberOfAllReviews())
    }
    
}
