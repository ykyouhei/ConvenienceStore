//
//  GenerateSevenItems.swift
//  ConvenienceStore
//
//  Created by kyo__hei on 2017/01/29.
//  Copyright © 2017年 kyo__hei. All rights reserved.
//

import Foundation
import Kanna
import Regex
import Core_macOS

func generateSevenItems() -> [SevenElevenItem] {
    
    let baseURL      = "http://www.sej.co.jp"
    let productsPath = "/i/products/thisweek/"
    
    let doc = HTML(url: URL(string: baseURL + productsPath)!, encoding: .utf8)!
    
    let areas      = doc.xpath("//*[@id='main']//h2")
    let categories = doc.xpath("//*[@id='main']/div[@class='subCategory']")
    
    var items = Set<SevenElevenItem>()
    
    for (index, category) in categories.enumerated() {
        let area = SevenElevenItem.Area(string: areas[index].text!)
        
        print("=================== \(area)\(area.rawValue) ====================")
        
        for item in category.xpath("div/ul/li[@class='item']") {
            let img   = item.at_xpath("div[@class='image']/a/img")!.toHTML!
            let link  = item.at_xpath("div/div[@class='itemName']/strong/a")!.toHTML!
            let price = item.at_xpath("div/ul[@class='itemPrice']")!
            
            // 先頭2桁は地域コードのため削除
            let idRaw = "([0-9]+)".r!.findFirst(in: link)!.group(at: 1)!
            let id = idRaw.substring(from: idRaw.index(idRaw.startIndex, offsetBy: 2))
            
            let title = ">(.+)<".r!.findFirst(in: link)!.group(at: 1)!
            let imagePath = "\"([^\"]*)\"".r!.findFirst(in: img)!.group(at: 1)!
            let detailURL = URL(string: baseURL + "href=\"([^\"]+)\"".r!.findFirst(in: link)!.group(at: 1)!)!
            
            let priceText   = price.at_xpath("li[@class='price']")!.text!
            var nonTaxPrice = 0
            var taxPrice    = 0
            "([0-9]+)".r!.findAll(in: priceText).enumerated().forEach {
                if $0 == 0 { nonTaxPrice = Int($1.group(at: 1)!)! }
                if $0 == 1 { taxPrice    = Int($1.group(at: 1)!)! }
            }
            
            let launchText = price.at_xpath("li[@class='launch']")!.text!
            let dateGroup  = "([0-9]+)年([0-9]+)月([0-9]+)日".r!.findFirst(in: launchText)
            let d = (year: Int(dateGroup!.group(at: 1)!)!,
                     month: Int(dateGroup!.group(at: 2)!)!,
                     day: Int(dateGroup!.group(at: 3)!)!)
            let calender = NSCalendar(calendarIdentifier: .gregorian)!
            calender.timeZone = TimeZone(identifier: "JST")!
            let date = calender.date(era: 1,
                                     year: d.year,
                                     month: d.month,
                                     day: d.day,
                                     hour: 0,
                                     minute: 0,
                                     second: 0,
                                     nanosecond: 0)
            let unixTime = date?.timeIntervalSince1970
            
            let detailDoc = HTML(url: detailURL, encoding: .utf8)
            let text      = detailDoc!.at_xpath("//div[@class='text']")!.text!
            
            var areas = Set<SevenElevenItem.Area>()
            
            if let oldItem = items.filter({ $0.id == id }).first {
                areas = oldItem.areas
                areas.insert(area)
            } else {
                areas.insert(area)
            }
            
            let item = SevenElevenItem(
                id: id,
                title: title,
                text: text,
                imageURL: URL(string: baseURL + imagePath)!,
                detailURL: detailURL,
                taxIncludedPrice: taxPrice,
                taxExcludedPrice: nonTaxPrice,
                launchDate: Int(unixTime!),
                areas: areas)
            
            print(item)
            
            items.update(with: item)
        }
    }
    
    return Array(items)
    
}
