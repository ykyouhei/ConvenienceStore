//
//  ReviewViewController.swift
//  ConvenienceStore
//
//  Created by kyo__hei on 2017/02/12.
//  Copyright © 2017年 kyo__hei. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD
import Cosmos
import Typist
import FirebaseAnalytics

internal protocol ReviewViewControllerDelegate: class {
    
    func reviewViewControllerDidTapCancel(_ vc: ReviewViewController)
    
    func reviewViewController(_ vc: ReviewViewController,
                              shouldSendReview review: Review)
    
}

internal final class ReviewViewController: XibBaseViewController {
    
    // MARK: Properties
    
    private let defaultReview: Review?
    
    weak var delegate: ReviewViewControllerDelegate?
    
    // MARK: Outlet / UI
    
    @IBOutlet private weak var cosmosView: CosmosView!
    
    @IBOutlet private weak var reviewLabel: UILabel!
    
    @IBOutlet private weak var titleTextField: UITextField!
    
    @IBOutlet private weak var textView: UITextView!
    
    @IBOutlet private weak var bottomConstraint: NSLayoutConstraint!
    
    private lazy var cancelButton: UIBarButtonItem = {
        let b = UIBarButtonItem(
            barButtonSystemItem: .cancel,
            target: self,
            action: #selector(ReviewViewController.didTapCancelButton(_:)))
        return b
    }()
    
    private lazy var sendButton: UIBarButtonItem = {
        let b = UIBarButtonItem(
            title: L10n.Review.Label.send,
            style: .done,
            target: self,
            action: #selector(ReviewViewController.didTapSendButton(_:)))
        b.isEnabled = false
        return b
    }()
    
    
    // MARK: Initializer
    
    init(review: Review?) {
        self.defaultReview = review
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: Actions
    
    @objc func didTapCancelButton(_ sender: UIBarButtonItem) {
        delegate?.reviewViewControllerDidTapCancel(self)
    }
    
    @objc func didTapSendButton(_ sender: UIBarButtonItem) {
        guard let uid = Auth.auth().currentUser?.uid else {
            SVProgressHUD.showError(withStatus: "")
            delegate?.reviewViewControllerDidTapCancel(self)
            return
        }
        
        let review : Review
        
        if let defaultReview = defaultReview {
            review  = defaultReview.updated(rating: cosmosView.rating,
                                           title: titleTextField.text ?? "",
                                           text: textView.text)
        } else {
            review  = Review(
                uid: uid,
                rating: cosmosView.rating,
                title: titleTextField.text ?? "",
                text: textView.text)
        }
        
        delegate?.reviewViewController(self, shouldSendReview: review)
    }
    
    // MARK: Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupKeyboard()
        setupViews()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        Typist.shared.clear()
    }
    
    
    // MARK: Private 
    
    private func setupViews() {
        title = L10n.Review.Label.writeReview
        
        navigationItem.leftBarButtonItem  = cancelButton
        navigationItem.rightBarButtonItem = sendButton
        
        reviewLabel.text = L10n.Review.Label.reviewHelp
        
        cosmosView.rating                    = 0
        cosmosView.settings.updateOnTouch    = true
        cosmosView.settings.minTouchRating   = 1
        cosmosView.settings.starSize         = 24
        cosmosView.settings.starMargin       = 14
        cosmosView.settings.emptyColor       = #colorLiteral(red: 0.7540688515, green: 0.7540867925, blue: 0.7540771365, alpha: 1)
        cosmosView.settings.emptyBorderColor = #colorLiteral(red: 0.7540688515, green: 0.7540867925, blue: 0.7540771365, alpha: 1)
        cosmosView.didFinishTouchingCosmos = { [weak self] rating in
            self?.sendButton.isEnabled = true
        }
        cosmosView.didTouchCosmos = { [weak self] rating in
            self?.sendButton.isEnabled = true
        }
        
        if let review = defaultReview {
            cosmosView.rating   = review.rating
            titleTextField.text = review.title
            textView.text       = review.text
            self.sendButton.isEnabled = true
        }
    }
    
    private func setupKeyboard() {
        Typist.shared
            .on(event: .didShow) { [weak self] options in
                self?.bottomConstraint.constant = options.endFrame.height
                UIView.animate(withDuration: options.animationDuration) {
                    self?.view.layoutIfNeeded()
                }
            }
            .on(event: .didHide) { [weak self] options in
                self?.bottomConstraint.constant = 0
                UIView.animate(withDuration: options.animationDuration) {
                    self?.view.layoutIfNeeded()
                }
            }
            .start()
    }

}
