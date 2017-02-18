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
    
    typealias FilterBlock = (T) -> Bool
    
    // MARK: Properties
    
    var queryBlock: QueryBlock = { ref in
        return ref.queryOrdered(byChild: "launchDate") 
    }
    
    var filterBlock: FilterBlock = { _ in
        return true
    }
    
    private lazy var fbReference: FIRDatabaseReference = {
        let index = T.dataBasePath.index(after: T.dataBasePath.startIndex)
        let path  = T.dataBasePath.substring(from: index)
        let ref   =  FIRDatabase.database().reference().child(path)
        ref.keepSynced(true)
        return ref
    }()
    
    private(set) var items: [T]
    
    
    // MARK: Initializer
    
    init() {
        items = []
    }
    
    
    // MARK: Public Method
    
    func fetch() -> Promise<[T]> {
        return Promise { resolve, reject in
            let ref   = self.queryBlock(self.fbReference)
            
            ref.observeSingleEvent(
                of: .value,
                with: { snapshot in
                    self.items = snapshot.children.flatMap { snap -> T? in
                        guard let json = (snap as? FIRDataSnapshot)?.value as? [String : Any] else {
                            return nil
                        }
                        return T(json: json)
                    }
                    
                    log.verbose(self.items)
                    
                    resolve(self.items)
                },
                withCancel: { error in
                    log.error(error)
                    reject(error)
            })
        }
    }

}

