//
//  main.swift
//  ConvenienceStore
//
//  Created by kyo__hei on 2017/01/28.
//  Copyright © 2017年 kyo__hei. All rights reserved.
//

import Foundation
import Regex

let familyMartItems  = generateFamilyMartItems()
let sevenElevenItems = generateSevenItems()

sendJSON(with: familyMartItems)
sendJSON(with: sevenElevenItems)
