//
//  ItemDetailViewController.swift
//  ConvenienceStore
//
//  Created by kyo__hei on 2017/01/30.
//  Copyright © 2017年 kyo__hei. All rights reserved.
//

import UIKit
import Hero
import Kingfisher

internal final class ItemDetailViewController: UIViewController {
    
    // MARK: Properties
    
    var sevenItem: SevenItem!
    
    
    // MARK: Outlets
    
    @IBOutlet private weak var tableView: UITableView!
    
    @IBOutlet private weak var detailImageView: UIImageView!
    
    @IBOutlet private weak var titleLabel: UILabel!
    
    @IBOutlet private weak var priceLabel: UILabel!
    
    @IBOutlet private weak var launchLabel: UILabel!
    
    @IBOutlet private weak var textLabel: UILabel!
    
    
    // MARK: Actions
    
    @IBAction func handlePan(_ sender: UIScreenEdgePanGestureRecognizer) {
        let translation = sender.translation(in: nil)
        let progress = translation.x / (view.bounds.width * 0.5)
        switch sender.state {
        case .began:
           _ = navigationController?.popViewController(animated: true)
            
        case .changed:
            Hero.shared.update(progress: Double(progress))
            
        default:
            progress + sender.velocity(in: nil).x / view.bounds.width > 0.15 ?
                Hero.shared.end() :
                Hero.shared.cancel()
        }
        
    }
    
    
    
    // MARK: Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        isHeroEnabled = true
        
        setupViews()
    }
    
    
    // MARK: Private Method
    
    private func setupViews() {
        let springModifier: HeroModifier = .spring(stiffness: 1000, damping: 45)
        
        detailImageView.kf.setImage(with: sevenItem.image)
        detailImageView.heroID = "image" + sevenItem.id
        detailImageView.heroModifiers = [springModifier]
        
        titleLabel.text = sevenItem.title
        titleLabel.heroID = "title" + sevenItem.id
        titleLabel.heroModifiers = [springModifier]
        
        priceLabel.text = sevenItem.priceText
        priceLabel.heroID = "price" + sevenItem.id
        priceLabel.heroModifiers = [springModifier]
        
        launchLabel.text = sevenItem.launchText
        launchLabel.heroID = "launch" + sevenItem.id
        launchLabel.heroModifiers = [springModifier]
        
        textLabel.text = sevenItem.text
        textLabel.heroModifiers = [.translate(x:0, y:100), .scale(0.5), springModifier]
    }

}
