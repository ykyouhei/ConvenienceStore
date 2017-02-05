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
import Core_iOS

internal final class ItemDetailViewController<T: Item>:
    XibBaseViewController,
    UITableViewDelegate where T: StoreInformation
{
    
    // MARK: Properties
    
    let item: T
    
    private var isTransition = false
    
    
    // MARK: Outlets
    
    @IBOutlet private weak var tableView: UITableView!
    
    @IBOutlet private weak var headerView: UIView!
    
    @IBOutlet private weak var detailImageView: UIImageView!
    
    @IBOutlet private weak var titleLabel: UILabel!
    
    @IBOutlet private weak var priceLabel: UILabel!
    
    @IBOutlet private weak var launchLabel: UILabel!
    
    @IBOutlet private weak var textLabel: UILabel!
    
    
    // MARK: Initializer
    
    init(item: T) {
        self.item = item
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: Actions
    
    @IBAction func handlePan(_ sender: UIScreenEdgePanGestureRecognizer) {
        let translation = sender.translation(in: nil)
        let progress = translation.x / (view.bounds.width * 0.75)
        switch sender.state {
        case .began:
           _ = navigationController?.popViewController(animated: true)
            
        case .changed:
            Hero.shared.update(progress: Double(progress))
            
        default:
            progress + sender.velocity(in: nil).x / view.bounds.width > 0.3 ?
                Hero.shared.end() :
                Hero.shared.cancel()
        }
        
    }
    
    
    // MARK: Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        isHeroEnabled = true
        
        tableView.delegate = self
        
        navigationItem.titleView = UIImageView(image: T.logoImage)
        
        setupViews()
        
        setupGesture()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateHeaderViewSize()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    
    // MARK: Private Method
    
    private func setupViews() {
        detailImageView.kf.setImage(with: item.imageURL)
        titleLabel.text = item.title
        priceLabel.text = item.taxIncludedPriceString
        launchLabel.text = item.launchDateString
        textLabel.text = item.text
        
        detailImageView.heroID = "image" + item.id
        titleLabel.heroID = "title" + item.id
        priceLabel.heroID = "price" + item.id
        launchLabel.heroID = "launch" + item.id
        
        detailImageView.heroModifiers = [.defaultSpring()]
        titleLabel.heroModifiers = [.defaultSpring()]
        priceLabel.heroModifiers = [.defaultSpring()]
        launchLabel.heroModifiers = [.defaultSpring()]
        textLabel.heroModifiers = [.translate(x:0, y:100), .scale(0.5), .defaultSpring()]
    }
    
    private func updateHeaderViewSize() {
        tableView.tableHeaderView = headerView
        
        headerView.setNeedsLayout()
        headerView.layoutIfNeeded()
        
        let height = CGRect(
            origin: .zero,
            size: headerView.systemLayoutSizeFitting(UILayoutFittingCompressedSize)).height
        var frame = headerView.frame
        
        frame.size.height = height
        headerView.frame = frame
        
        tableView.tableHeaderView = headerView
    }
    
    private func setupGesture() {
        let screenEdge = UIScreenEdgePanGestureRecognizer(
            target: self,
            action: #selector(handlePan(_:)))
        screenEdge.edges = .left
        view.addGestureRecognizer(screenEdge)
    }
    
    
    // MARK: - UITableViewDelegate
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y < -topLayoutGuide.length {
            if isTransition {
                log.debug("--- isTransition ---")
                let progress = (-scrollView.contentOffset.y - topLayoutGuide.length) / (scrollView.bounds.height * 0.75)
                Hero.shared.update(progress: Double(progress))
            } else if !scrollView.isDecelerating && scrollView.isDragging {
                log.debug("---- start ----")
                isTransition = true
                _ = navigationController?.popViewController(animated: true)
            }
        } else if isTransition {
            log.debug("---- cancel ----")
            isTransition = false
            Hero.shared.cancel()
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if isTransition {
            log.debug("---- end ----")
            isTransition = false
            Hero.shared.end()
        }
    }

}
