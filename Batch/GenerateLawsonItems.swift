//
//  GenerateLawsonItems.swift
//  ConvenienceStore
//
//  Created by kyo__hei on 2017/02/19.
//  Copyright © 2017年 kyo__hei. All rights reserved.
//

import Foundation
import Kanna
import Regex
import Core_macOS

func generateLawsonItems() -> [LawsonItem] {
    
    let baseURL      = "http://www.lawson.co.jp"
    let productsPath = "/recommend/new/index.html"
    
    let baseDoc      = HTML(url: URL(string: baseURL + productsPath)!, encoding: .utf8)!
    let meta         = baseDoc.head!.at_xpath("meta")!.toHTML!
    let redirectPath = "URL=(.+html)".r!.findFirst(in: meta)!.group(at: 1)!
    let doc          = HTML(url: URL(string: baseURL + redirectPath)!, encoding: .utf8)!
    
    var items = [LawsonItem]()
    
    for itemDoc in doc.xpath("//ul[@class='col-5 heightLineParent']/*") {
        let taxPriceRaw  = itemDoc.at_xpath("*/p[@class='price']/span[1]")!.text!
        let launchRaw    = itemDoc.at_xpath("*/p[@class='date']/span")!.text!
        let linkRaw      = itemDoc.at_xpath("a")!.toHTML!
        
        let title     = itemDoc.at_xpath("*/p[@class='ttl']")!.text!
        let taxPrice  = Int("([0-9]+)".r!.findFirst(in: taxPriceRaw)!.group(at: 1)!)!
        let id        = "([0-9|_]+).html".r!.findFirst(in: linkRaw)!.group(at: 1)!
        let link      = URL(string: baseURL + "href=\"([^\"]+)\"".r!.findFirst(in: linkRaw)!.group(at: 1)!)!
        
        // Detail
        let detailDoc    = HTML(url: link, encoding: .utf8)!
        let imageHTMLRaw = detailDoc.at_xpath("//div[@class='leftBlock']//img")!.toHTML!
        let imageURL     = URL(string: "src=\"([^\"]+)\"".r!.findFirst(in: imageHTMLRaw)!.group(at: 1)!)!
        let text         = detailDoc.at_xpath("//div[@class='rightBlock']/p[@class='text']")!.text!
        
        let dateGroup  = "([0-9]+)\\.([0-9]+)\\.([0-9]+)".r!.findFirst(in: launchRaw)
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
        
        let item = LawsonItem(
            id: id,
            title: title,
            text: text,
            imageURL: imageURL,
            detailURL: link,
            taxIncludedPrice: taxPrice,
            taxExcludedPrice: 0,
            launchDate: Int(unixTime!))
        
        print(item)
        
        items.append(item)
    }
    
    return items
}
