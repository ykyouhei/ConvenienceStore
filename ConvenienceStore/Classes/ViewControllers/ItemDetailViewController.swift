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
import SVProgressHUD
import FirebaseAnalytics
import SwiftyUserDefaults

private struct CellId {
    static let detail = "detailCell"
}

private enum Section: Int {
    case itemDetail
}


internal protocol ItemDetailViewControllerDelegate: class {
    func itemDetailViewControllerShouldClose(_ vc: UIViewController)
}

internal final class ItemDetailViewController<T: Item>:
    XibBaseViewController,
    UITableViewDelegate,
    UITableViewDataSource,
    ItemDetailTableViewCellDelegate,
    AdPresentable where T: StoreInformation
{
    
    // MARK: Properties
    
    weak var delegate: ItemDetailViewControllerDelegate?
    
    private let viewModel: ItemDetailViewModel<T>
    
    private var isTransition = false
    
    
    // MARK: Outlets / UI
    
    @IBOutlet private weak var tableView: UITableView!
    
    private var detailCell: ItemDetailTableViewCell!
    
    private lazy var closeButton: UIBarButtonItem = {
        return UIBarButtonItem(
            title: L10n.Common.Label.close,
            style: .done,
            target: self,
            action: #selector(ItemDetailViewController.didTapCloseButton(_:)))
    }()
    

    // MARK: Computed Properties
    
    var scrollView: UIScrollView? {
        return tableView
    }
    
    
    // MARK: Initializer
    
    init(viewModel: ItemDetailViewModel<T>) {
        self.viewModel = viewModel

        Analytics.logEvent(AnalyticsEventViewItem,
                              parameters: [
                                AnalyticsParameterItemID   : NSString(string: viewModel.item.id),
                                AnalyticsParameterItemName : NSString(string: viewModel.item.title)
                              ])
        
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
            Hero.shared.update(progress)
            
        default:
            progress + sender.velocity(in: nil).x / view.bounds.width > 0.3 ?
                Hero.shared.finish() :
                Hero.shared.cancel()
        }
    }
    
    @objc func didTapCloseButton(_ sender: UIBarButtonItem) {
        delegate?.itemDetailViewControllerShouldClose(self)
    }
    

    // MARK: Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        isHeroEnabled = true
        
        navigationItem.titleView = UIImageView(image: T.logoImage)
        navigationItem.leftBarButtonItem  = closeButton

        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        tableView.tableFooterView = UIView()
        
        registerCells()
        
        setupGesture()
        
        addBannerView()
        
        Defaults[.itemViewCount] += 1
    }
    
    
    // MARK: Private Method
    
    private func setupGesture() {
        let screenEdge = UIScreenEdgePanGestureRecognizer(
            target: self,
            action: #selector(handlePan(_:)))
        screenEdge.edges = .left
        view.addGestureRecognizer(screenEdge)
    }
    
    private func registerCells() {
        let detailNib = UINib(nibName: ItemDetailTableViewCell.className, bundle: nil)

        tableView.register(detailNib, forCellReuseIdentifier: CellId.detail)

        detailCell = tableView.dequeueReusableCell(withIdentifier: CellId.detail) as! ItemDetailTableViewCell
        detailCell.delegate = self
        
        updateDetailCell()
    }
    
    private func updateDetailCell() {
        detailCell.update(item: viewModel.item,
                          likeCount: viewModel.likeInfo.count,
                          isLiked: viewModel.likeInfo.isLiked)
    }
    
    
    // MARK: Navigation
    

    // MARK: - UITableViewDelegate
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y < -topLayoutGuide.length {
            if isTransition {
                log.debug("--- isTransition\(scrollView.contentSize) ---")
                let progress = (-scrollView.contentOffset.y - topLayoutGuide.length) / (scrollView.bounds.height * 0.75)
                Hero.shared.update(progress)
            } else if !scrollView.isDecelerating && scrollView.isDragging {
                log.debug("---- start ----")
                isTransition = true
                delegate?.itemDetailViewControllerShouldClose(self)
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
            Hero.shared.finish()
        }
    }
    
    
    // MARK: - UITableViewDelegate
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = Section(rawValue: section)!
        switch section {
        case .itemDetail: return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = Section(rawValue: indexPath.section)!
        switch section {
        case .itemDetail:
            updateDetailCell()
            return detailCell
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        let section = Section(rawValue: indexPath.section)!
        switch section {
        case .itemDetail:
            return false
        }
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let section = Section(rawValue: indexPath.section)!
        switch section {
        case .itemDetail:
            return nil
        }
    }
    
    
    // MARK: - ItemDetailCellDelegate
    
    func itemDetailTableViewCellDidLike(_ cell: ItemDetailTableViewCell) {
        SVProgressHUD.show()
        viewModel.likeItem()
            .onError(showError)
            .finally {
                self.updateDetailCell()
                SVProgressHUD.dismiss()
            }
    }
    
}
