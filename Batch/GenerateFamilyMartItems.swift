//
//  GenerateFamilyMartItems.swift
//  ConvenienceStore
//
//  Created by kyo__hei on 2017/02/02.
//  Copyright © 2017年 kyo__hei. All rights reserved.
//

import Foundation
import Kanna
import Regex
import Core_macOS

func generateFamilyMartItems() -> [FamilyMartItem] {

    let baseURL      = "http://www.family.co.jp"
    let productsPath = "/goods/newgoods.html"
    
    let doc = HTML(url: URL(string: baseURL + productsPath)!, encoding: .utf8)!
    
    var items = [FamilyMartItem]()
    
    for itemDoc in doc.xpath("//div[@class='ly-mod-layout-clm']") {
        let imageHTMLRaw = itemDoc.at_xpath("div/a/div/p/img")!.toHTML!
        let taxPriceRaw  = itemDoc.at_xpath("div/a/p[@class='ly-mod-infoset4-txt']")!.text!
        let linkRaw      = itemDoc.at_xpath("div/a[@class='ly-mod-infoset4-link']")!.toHTML!
        
        let category = itemDoc.at_xpath("div/a/p[@class='ly-mod-infoset4-cate']")!.text!
            .replacingOccurrences(of: "\t", with: "")
            .replacingOccurrences(of: "\n", with: "")
        
        let title = itemDoc.at_xpath("div/a/h3[@class='ly-mod-infoset4-ttl']")!.text!
            .replacingOccurrences(of: "\t", with: "")
            .replacingOccurrences(of: "\n", with: "")
        
        let taxPrice  = Int("([0-9]+)".r!.findFirst(in: taxPriceRaw)!.group(at: 1)!)!
        let id        = "([0-9]+).html".r!.findFirst(in: linkRaw)!.group(at: 1)!
        let imageURL  = URL(string: baseURL + "src=\"([^\"]+)\"".r!.findFirst(in: imageHTMLRaw)!.group(at: 1)!)!
        let link      = URL(string: baseURL + "href=\"([^\"]+)\"".r!.findFirst(in: linkRaw)!.group(at: 1)!)!
        
        
        // Detail
        let detailDoc = HTML(url: link, encoding: .utf8)!
        let text      = detailDoc.at_xpath("//p[@class='ly-goods-lead']")!.text!
        let launchRaw = detailDoc.at_xpath("//ul[@class='ly-goods-spec']/li")!.text!
        
        let dateGroup  = "([0-9]+)年([0-9]+)月([0-9]+)日".r!.findFirst(in: launchRaw)
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
        
        let item = FamilyMartItem(
            id: id,
            title: title,
            text: text,
            imageURL: imageURL,
            detailURL: link,
            taxIncludedPrice: taxPrice,
            taxExcludedPrice: 0,
            launchDate: Int(unixTime!),
            category: category)
        
        print(item)
        
        items.append(item)
    }
    
    return items
}
