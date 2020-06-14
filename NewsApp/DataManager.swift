//
//  DataManager.swift
//  NewsApp
//
//  Created by 沁洲 许 on 6/13/20.
//  Copyright © 2020 Qinzhou Xu. All rights reserved.
//

import Foundation

class DataManager {
    
    // Data manager for bookmark
    
    static let userDefaults = UserDefaults.standard
    
    static func saveNews(newsObj: NewsAbstract, imageData: Data) {
        if isNewsSaved(id: newsObj.id) {
            return
        }
        else {
            let date = newsObj.date
            let start = date.index(date.startIndex, offsetBy: 0)
            let end = date.index(date.endIndex, offsetBy: -5)
            
            let value: [String: String] = [
                "title": newsObj.title,
                "date": String(date[start..<end]),
                "section": newsObj.section,
                "webUrl": newsObj.webUrl
            ]
            userDefaults.set(value, forKey: newsObj.id)
            userDefaults.set(imageData, forKey: "\(newsObj.id)-image")
        }
    }
    
    static func getNewsInfo(id: String) -> [String: String]? {
        return userDefaults.object(forKey: id) as? [String: String]
    }
    
    static func getNewsImage(id: String) -> Data? {
        return userDefaults.object(forKey: "\(id)-image") as? Data
    }
    
    static func removeNews(id: String) {
        userDefaults.removeObject(forKey: id)
        userDefaults.removeObject(forKey: "\(id)-image")
    }
    
    static func isNewsSaved(id: String) -> Bool {
        return userDefaults.object(forKey: id) != nil
    }
    
    static func clearData() {
        // remove all news from user default
        let dics = userDefaults.dictionaryRepresentation()
        for key in dics {
            userDefaults.removeObject(forKey: key.key)
        }
        userDefaults.synchronize()
    }
}
