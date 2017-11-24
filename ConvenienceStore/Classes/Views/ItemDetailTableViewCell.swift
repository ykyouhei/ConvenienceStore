//
//  ItemDetailTableViewCell.swift
//  ConvenienceStore
//
//  Created by kyo__hei on 2017/02/12.
//  Copyright © 2017年 kyo__hei. All rights reserved.
//

import UIKit
import Core_iOS

internal protocol ItemDetailTableViewCellDelegate: class {
    
    func itemDetailTableViewCellDidTapReview(_ cell: ItemDetailTableViewCell)
    
}

internal final class ItemDetailTableViewCell: UITableViewCell {
    
    // MARK: Properties
    
    weak var delegate: ItemDetailTableViewCellDelegate?
    
    
    // MARK: Outlet
    
    @IBOutlet private weak var likeButton: UIButton!
    
    @IBOutlet private weak var likeCountLabel: UILabel!

    @IBOutlet private weak var detailImageView: UIImageView!
    
    @IBOutlet private weak var titleLabel: UILabel!
    
    @IBOutlet private weak var priceLabel: UILabel!
    
    @IBOutlet private weak var launchLabel: UILabel!
    
    @IBOutlet private weak var detailLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        likeButton.setImage(#imageLiteral(resourceName: "heart_off"), for: .normal)
        likeButton.setImage(#imageLiteral(resourceName: "heart_on"), for: .selected)
    }
    
    @IBAction private func didTapLike(_ sender: UIButton) {
        UIView.animate(withDuration: 0.35,
                       delay: 0,
                       usingSpringWithDamping: 0.6,
                       initialSpringVelocity: 0,
                       options: [],
                       animations: {
                        sender.transform = CGAffineTransform(scaleX: 0.3, y: 0.3)
                        sender.transform = CGAffineTransform(scaleX: 1.5, y: 1.3)
                        sender.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                        sender.isSelected = !sender.isSelected
        },
                       completion: { _ in
        })
    }
    
    
    func update<T>(item: T, reviewList: ReviewListViewModel<T>) {
        detailImageView.kf.setImage(with: item.imageURL)
        titleLabel.text = item.title
        priceLabel.text = item.taxIncludedPriceString
        launchLabel.text = item.launchDateString
        detailLabel.text = item.text
        
        likeButton.heroID = "likeButton" + item.id
        likeCountLabel.heroID = "likeCountLabel" + item.id
        detailImageView.heroID = "image" + item.id
        titleLabel.heroID = "title" + item.id
        priceLabel.heroID = "price" + item.id
        launchLabel.heroID = "launch" + item.id
        detailLabel.heroID = "detailLabel" + item.id
        
        likeButton.heroModifiers = [.defaultSpring()]
        likeCountLabel.heroModifiers = [.defaultSpring()]
        detailImageView.heroModifiers = [.defaultSpring()]
        titleLabel.heroModifiers = [.defaultSpring()]
        priceLabel.heroModifiers = [.defaultSpring()]
        launchLabel.heroModifiers = [.defaultSpring()]
        detailLabel.heroModifiers = [.defaultSpring()]
    }
    
}
