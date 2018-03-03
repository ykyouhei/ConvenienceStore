//
//  ItemCollectionViewCell.swift
//  ConvenienceStore
//
//  Created by kyo__hei on 2017/02/05.
//  Copyright © 2017年 kyo__hei. All rights reserved.
//

import UIKit
import Core_iOS

internal protocol ItemCollectionViewCellDelegate: class {
    func itemCollectionViewCellDidLike(_ cell: ItemCollectionViewCell)
}

/// 商品を表示するCollectionViewCell
internal final class ItemCollectionViewCell: UICollectionViewCell {

    // MARK: Outlet
    
    weak var delegate: ItemCollectionViewCellDelegate?
    
    @IBOutlet private weak var likeButton: UIButton!
    @IBOutlet private weak var likeCountLabel: UILabel!
    @IBOutlet private weak var cardView: UIView!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var priceLabel: UILabel!
    @IBOutlet private weak var launchLabel: UILabel!
    @IBOutlet private weak var dummyDetailLabel: UILabel!
    
    
    // MARK: Actions
    
    @IBAction private func didTapLike(_ sender: UIButton) {
        guard !sender.isSelected else { return }
        
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
                       completion: { [unowned self] _ in
                        self.delegate?.itemCollectionViewCellDidLike(self)
                       })
    }
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        clipsToBounds = false
        cardView.layer.shadowRadius  = 3
        cardView.layer.shadowOpacity = 0.1
        cardView.layer.shadowOffset  = .zero
        cardView.layer.cornerRadius  = 2
        
        likeButton.setImage(#imageLiteral(resourceName: "heart_off"), for: .normal)
        likeButton.setImage(#imageLiteral(resourceName: "heart_on"), for: .selected)
    }
    
    static func height(with width: CGFloat) -> CGFloat {
        let margin = CGFloat(8)
        
        let imageHeight = (width - margin*2) * (42/50)
        let stackViewHeight =
            28
            + margin
            + 34
            + margin
            + 16
            + margin
            + 16
        
        return margin
            + imageHeight
            + stackViewHeight
            + margin
    }
    
    func apply<T: Item>(_ item: T, likeCount: Int, isLiked: Bool) {
        imageView.kf.setImage(with: item.imageURL)
        
        titleLabel.text  = item.title
        priceLabel.text  = item.taxIncludedPriceString
        launchLabel.text = item.launchDateString
        likeButton.isSelected = isLiked
        likeCountLabel.text = "\(likeCount)"
        
        likeButton.heroID = "likeButton" + item.id
        likeCountLabel.heroID = "likeCountLabel" + item.id
        imageView.heroID   = "image" + item.id
        titleLabel.heroID  = "title" + item.id
        priceLabel.heroID  = "price" + item.id
        launchLabel.heroID = "launch" + item.id
        dummyDetailLabel.heroID = "detailLabel" + item.id
        
        likeButton.heroModifiers = [.defaultSpring()]
        likeCountLabel.heroModifiers = [.defaultSpring()]
        imageView.heroModifiers = [.defaultSpring()]
        titleLabel.heroModifiers = [.defaultSpring()]
        priceLabel.heroModifiers = [.defaultSpring()]
        launchLabel.heroModifiers = [.defaultSpring()]
        dummyDetailLabel.heroModifiers = [.defaultSpring()]
    }

}
