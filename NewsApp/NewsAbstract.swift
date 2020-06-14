//
//  NewsAbstract.swift
//  NewsApp
//
//  Created by 沁洲 许 on 6/6/20.
//  Copyright © 2020 Qinzhou Xu. All rights reserved.
//

import Foundation

public class NewsAbstract {

    // MARK: Properities
    var image: String?
    var title: String
    var time: String
    var section: String
    var id: String
    var webUrl: String
    var date: String
    
    // MARK: Initialization
    init(image: String?, title: String, time: String, section: String, id: String, webUrl: String, date: String) {
        self.image = image
        self.title = title
        self.time = time
        self.section = section
        self.id = id
        self.webUrl = webUrl
        self.date = date
    }
}
