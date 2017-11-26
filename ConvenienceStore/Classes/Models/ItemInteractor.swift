//
//  ItemInteractor.swift
//  ConvenienceStore
//
//  Created by kyo__hei on 2017/11/25.
//  Copyright © 2017年 kyo__hei. All rights reserved.
//

import Core_iOS
import Firebase
import then

internal final class ItemInteractor<T: Item> {
    
    // MARK: Properties
    
    private let itemsReference: DatabaseReference = {
        let index = T.dataBasePath.index(after: T.dataBasePath.startIndex)
        let path  = String(T.dataBasePath[index...])
        let ref   =  Database.database().reference().child(path)
        ref.keepSynced(true)
        return ref
    }()
    

    // MARK: Public
    
    func fetchItems() -> Promise<[T]> {
        return Promise { resolve, reject in
            self.itemsReference
                .queryOrdered(byChild: "launchDate")
                .observeSingleEvent(
                    of: .value,
                    with: { snapshot in
                        let items = snapshot.children.flatMap { snap -> T? in
                            guard let json = (snap as? DataSnapshot)?.value,
                                let jsonData = try? JSONSerialization.data(withJSONObject: json, options: []),
                                let item = try? JSONDecoder().decode(T.self, from: jsonData) else {
                                    return nil
                            }
                            return item
                        }
                        
                        log.verbose(items)
                        
                        resolve(items)
                    },
                    withCancel: { error in
                        log.error(error)
                        reject(error)
                    })
        }
    }

}
