//
//  Environment.swift
//  ConvenienceStore
//
//  Created by kyo__hei on 2017/01/28.
//  Copyright © 2017年 kyo__hei. All rights reserved.
//

import Foundation

/// 環境変数アクセス用クラス
public class Environment {
    
    enum EnvironmentName: String {
        case firebaseAPIKe     = "FIREBASE_API_KEY"
        case firebaseSecret    = "FIREBASE_SECRET"
        case firebaseEndpoint  = "FIREBASE_ENDPOINT"
    }
    
    static func get(_ name: EnvironmentName) -> String {
        
        let env = ProcessInfo.processInfo.environment
        if let value = env[name.rawValue] {
            return value
        } else {
            assertionFailure("環境変数 \(name.rawValue) が存在しません")
            return ""
        }
    }
    
    private init() {}
    
}
