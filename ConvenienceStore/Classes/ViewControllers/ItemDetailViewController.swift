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
import RealmSwift
import FirebaseAnalytics

private struct CellId {
    static let detail = "detailCell"
    static let review = "reviewCell"
}

private enum Section: Int {
    case itemDetail
    case reviews
}

internal final class ItemDetailViewController<T: Item>:
    XibBaseViewController,
    UITableViewDelegate,
    UITableViewDataSource,
    ItemDetailTableViewCellDelegate,
    ReviewViewControllerDelegate,
    AdPresentable where T: StoreInformation
{
    
    // MARK: Properties
    
    let item: T
    
    private lazy var reviewList: ReviewListViewModel<T> = {
        let reportedReviewIds = try! Realm().objects(ReportedReview.self).map { $0.reviewId }
        return ReviewListViewModel(item: self.item, reportedReviewIds: Array(reportedReviewIds))
    }()
    
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
    
    private lazy var writeReviewButton: UIBarButtonItem = {
        return UIBarButtonItem(barButtonSystemItem: .compose,
                                target: self,
                                action: #selector(ItemDetailViewController.didTapWriteButton(_:)))
    }()
    
    
    // MARK: Computed Properties
    
    var scrollView: UIScrollView? {
        return tableView
    }
    
    
    // MARK: Initializer
    
    init(item: T) {
        self.item = item
        
        Analytics.logEvent(AnalyticsEventViewItem,
                              parameters: [
                                AnalyticsParameterItemID   : NSString(string: item.id),
                                AnalyticsParameterItemName : NSString(string: item.title)
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
    
    func reloadList(sender: UIRefreshControl? = nil) {
        SVProgressHUD.show()
        sender?.beginRefreshing()
        
        reviewList
            .fetch()
            .onError(showError)
            .finally{
                SVProgressHUD.dismiss()
                sender?.endRefreshing()
                self.tableView.reloadData()
        }
    }
    
    @objc func didTapCloseButton(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    
    @objc func didTapWriteButton(_ sender: UIBarButtonItem) {
        showReviewVC()
    }
    
    
    // MARK: Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        isHeroEnabled = true
        
        navigationItem.titleView = UIImageView(image: T.logoImage)
        navigationItem.leftBarButtonItem  = closeButton
        navigationItem.rightBarButtonItem = writeReviewButton
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        tableView.tableFooterView = UIView()
        
        registerCells()
        
        setupGesture()
        
        addBannerView()
        
        reloadList()
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
        let reviewNib = UINib(nibName: ReviewTableViewCell.className, bundle: nil)
        
        tableView.register(detailNib, forCellReuseIdentifier: CellId.detail)
        tableView.register(reviewNib, forCellReuseIdentifier: CellId.review)
        
        detailCell = tableView.dequeueReusableCell(withIdentifier: CellId.detail) as! ItemDetailTableViewCell
        detailCell.update(item: item, reviewList: reviewList)
        detailCell.delegate = self
    }
    
    
    // MARK: Navigation
    
    private func showReviewVC() {
        let reviewVC = ReviewViewController(review: reviewList.reviewForCurrentUser())
        let navigation = UINavigationController(rootViewController: reviewVC)
        navigation.modalPresentationStyle = .formSheet
        reviewVC.delegate = self
        present(navigation, animated: true)
    }
    
    private func showReportAlert(_ reportHandler: @escaping () -> Void) {
        let yesAction = UIAlertAction(
            title: L10n.Common.Label.yes,
            style: .destructive) { _ in
                reportHandler()
        }
        let noAction = UIAlertAction(
            title: L10n.Common.Label.no,
            style: .default)
        
        let alert = UIAlertController(
            title: L10n.Itemdetail.Label.report,
            message: L10n.Itemdetail.Label.reportMessage,
            preferredStyle: .alert)
        
        alert.addAction(noAction)
        alert.addAction(yesAction)
        
        present(alert, animated: true)
    }
    
    
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
                dismiss(animated: true)
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
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = Section(rawValue: section)!
        switch section {
        case .itemDetail: return 1
        case .reviews:    return reviewList.reviews.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = Section(rawValue: indexPath.section)!
        switch section {
        case .itemDetail:
            detailCell.update(item: item, reviewList: reviewList)
            return detailCell
        case .reviews:
            let cell = tableView.dequeueReusableCell(
                withIdentifier: CellId.review,
                for: indexPath) as! ReviewTableViewCell
            
            cell.update(review: reviewList.reviews[indexPath.row])
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let section = Section(rawValue: indexPath.section)!
        switch section {
        case .itemDetail:
            return nil
            
        case .reviews:
            return [
                UITableViewRowAction(
                    style: .destructive,
                    title: L10n.Itemdetail.Label.report) { _, indexPath in
                        self.showReportAlert{
                            ReviewManager.report(for: self.reviewList.remove(at: indexPath.row))
                            tableView.deleteRows(at: [indexPath], with: .automatic)
                        }
                }
            ]
        }
    }
    
    
    // MARK: - ItemDetailTableViewCellDelegate
    
    func itemDetailTableViewCellDidTapReview(_ cell: ItemDetailTableViewCell) {
        showReviewVC()
    }
    
    
    // MARK: - ReviewViewControllerDelegate
    
    func reviewViewControllerDidTapCancel(_ vc: ReviewViewController) {
        vc.dismiss(animated: true)
    }
    
    func reviewViewController(_ vc: ReviewViewController, shouldSendReview review: Review) {
        Analytics.logEvent(AnalyticsEventPostScore,
                              parameters: [
                                AnalyticsParameterItemID   : NSString(string: item.id),
                                AnalyticsParameterItemName : NSString(string: item.title),
                                AnalyticsParameterScore : NSNumber(value: review.rating)
                              ])
        
        ReviewManager.send(review: review, for: item)
            .onError(showError)
            .finally{
                self.dismiss(animated: true)
                self.reviewList.insert(review: review)
                self.tableView.reloadData()
            }
    }

}
