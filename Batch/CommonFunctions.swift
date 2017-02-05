//
//  CommonFunctions.swift
//  ConvenienceStore
//
//  Created by kyo__hei on 2017/02/02.
//  Copyright © 2017年 kyo__hei. All rights reserved.
//

import Foundation
import Core_macOS

protocol PushItem {
    static var body: String { get }
}

extension SevenElevenItem: PushItem {
    static var body: String {
        return "⭐セブンイレブンの新商品情報が更新されました"
    }
}

extension FamilyMartItem: PushItem {
    static var body: String {
        return "⭐FamilyMartの新商品情報が更新されました"
    }
}


/// Firebaseへ商品情報を送る
///
/// - Parameter items: 商品情報
func sendJSON<T: Item>(with items: [T]) where T: PushItem {
    
    let request: URLRequest = {
        let secret = Environment.get(.firebaseSecret)
        let url = URL(string: Environment.get(.firebaseEndpoint) + "\(T.dataBasePath).json?auth=\(secret)")!
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
            
            if 200..<300 ~= response.statusCode {
                pushNotification(title: "🏪新商品情報の更新", body: T.body)
            }
            
            
        default:
            break
        }
        
        semaphore.signal()
        
        }.resume()
    
    semaphore.wait()
    
}


func pushNotification(title: String, body: String) {
    let request: URLRequest = {
        let secret = Environment.get(.firebaseServerKey)
        let url = URL(string: "https://fcm.googleapis.com/fcm/send")!
        var r = URLRequest(url: url)
        
        let header: [String : String] = [
            "Authorization" : "key=\(secret)",
            "Content-Type"  : "application/json"
        ]
        
        let json: [String : Any] = [
            "to" : "/topics/newItems",
            "content_available": true,
            "priority": "high",
            "notification" : [
                "title"   : title,
                "body" : body,
                "badge" : "1"
            ]
        ]
        
        r.httpMethod = "POST"
        r.allHTTPHeaderFields = header
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
