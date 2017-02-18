//
//  AdPresentable.swift
//  ConvenienceStore
//
//  Created by kyo__hei on 2017/02/12.
//  Copyright © 2017年 kyo__hei. All rights reserved.
//

import UIKit
import GoogleMobileAds

private let bannerViewTag = 1000

internal protocol AdPresentable {
    
    var scrollView: UIScrollView? { get }
    
}

extension AdPresentable where Self: UIViewController {
    
    var scrollView: UIScrollView? { return nil }
    
    var bannerView: GADBannerView? {
        return view.viewWithTag(bannerViewTag) as? GADBannerView
    }
    
    func addBannerView() {
        guard self.bannerView == nil else {
            return
        }
        
        let bannerView: GADBannerView = {
            let v = GADBannerView(adSize: kGADAdSizeSmartBannerPortrait)
            v.tag      = bannerViewTag
            v.adUnitID = googleService.get(.adUnitIdForBanner)
            v.rootViewController = self
            v.translatesAutoresizingMaskIntoConstraints = false
            return v
        }()
        
        let bannerHeight: CGFloat
        switch UIDevice.current.userInterfaceIdiom {
        case .pad:   bannerHeight = 90
        case .phone: bannerHeight = 50
        default:     bannerHeight = 50
        }
        
        view.addSubview(bannerView)
        
        bannerView
            .bottomAnchor
            .constraint(equalTo: self.bottomLayoutGuide.topAnchor, constant: 0)
            .isActive = true
        
        bannerView
            .leftAnchor
            .constraint(equalTo: self.view.leftAnchor, constant: 0)
            .isActive = true
        
         bannerView
            .rightAnchor
            .constraint(equalTo: self.view.rightAnchor, constant: 0)
            .isActive = true
        
        bannerView
            .heightAnchor
            .constraint(equalToConstant: bannerHeight)
            .isActive = true
        
        scrollView?.contentInset.bottom          = bannerHeight
        scrollView?.scrollIndicatorInsets.bottom = bannerHeight
        
        loadAdRequest()
    }
    
    func loadAdRequest() {
        bannerView?.load(GADRequest())
    }

}
