//
//  SelectRegionViewController.swift
//  ConvenienceStore
//
//  Created by kyo__hei on 2017/02/05.
//  Copyright © 2017年 kyo__hei. All rights reserved.
//

import UIKit
import Core_iOS

internal final class SelectRegionViewController: XibBaseViewController {
    
    // MAKR: Properites
    
    fileprivate let regionList: [SevenElevenItem.Area] = [
        .北海道,
        .東北,
        .関東,
        .甲信越・北陸,
        .東海,
        .近畿,
        .中国・四国,
        .九州
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
    }

}


extension SelectRegionViewController: UITableViewDelegate {
    
}


extension SelectRegionViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return regionList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        cell.textLabel?.text = "\(regionList[indexPath.row])"
        return cell
    }
    
}
