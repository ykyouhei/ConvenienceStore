//
//  ItemListViewModel.swift
//  ConvenienceStore
//
//  Created by kyo__hei on 2017/01/29.
//  Copyright © 2017年 kyo__hei. All rights reserved.
//

import Foundation
import Firebase
import Core_iOS
import then

internal final class ItemListViewModel<T: Item> {
    
    // MAKR: Types
    
    typealias QueryBlock = (_ ref: FIRDatabaseReference) -> FIRDatabaseQuery
    
    typealias SortBlock = (T, T) -> Bool
    
    typealias FilterBlock = (T) -> Bool
    
    
    // MARK: Properties
    
    var queryBlock: QueryBlock?
    
    var sortBlock: SortBlock = { l, r in
        return l.launchDate < r.launchDate
    }
    
    var filterBlock: FilterBlock = { _ in
        return true
    }
    
    private lazy var fbReference: FIRDatabaseReference = {
        return FIRDatabase.database().reference()
    }()
    
    private(set) var items: [T]
    
    
    // MARK: Initializer
    
    init() {
        items = []
    }
    
    
    // MARK: Public Method
    
    func fetch() -> Promise<[T]> {
        return Promise { resolve, reject in
            let index = T.dataBasePath.index(after: T.dataBasePath.startIndex)
            let path  = T.dataBasePath.substring(from: index)
            let ref   = self.fbReference.child(path).queryOrdered(byChild: "taxIncludedPrice")  
            
            ref.observeSingleEvent(
                of: .value,
                with: { snapshot in
                    let json  = snapshot.value as! [String : [String : Any]]
                    let items = json
                        .map { T(json: $1) }
                    
                    log.info(items)
                    
                    self.items = items
                    
                    resolve(items)
                },
                withCancel: { error in
                    log.error(error)
                    reject(error)
            })
        }
    }

}

