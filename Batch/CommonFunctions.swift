//
//  CommonFunctions.swift
//  ConvenienceStore
//
//  Created by kyo__hei on 2017/02/02.
//  Copyright © 2017年 kyo__hei. All rights reserved.
//

import Foundation
import Core_macOS

/// Firebaseへ商品情報を送る
///
/// - Parameter items: 商品情報
func sendJSON<T: Item>(with items: [T]) {
    
    let request: URLRequest = {
        let secret = Environment.get(.firebaseSecret)
        let url = URL(string: Environment.get(.firebaseEndpoint) + "\(T.dataBasePath)?auth=\(secret)")!
        var r = URLRequest(url: url)
        
        var json = [String : Any]()
        items.forEach {
            json[$0.id] = $0.json
        }
        
        r.httpMethod = "PUT"
        r.httpBody   = try? JSONSerialization.data(
            withJSONObject: json,
            options: [])
        
        return r
    }()
    
    print("======== Send JSON =========")
    
    let semaphore = DispatchSemaphore(value: 0)
    URLSession.shared.dataTask(with: request) { data, response, error in
        
        switch (data, response, error) {
        case (_, _, let error?):
            print(error)
        case (_, let response as HTTPURLResponse, _):
            print(response)
        default:
            break
        }
        
        semaphore.signal()
        
        }.resume()
    
    semaphore.wait()
    
}
