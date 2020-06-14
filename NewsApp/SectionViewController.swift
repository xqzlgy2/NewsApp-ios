//
//  SectionViewController.swift
//  NewsApp
//
//  Created by 沁洲 许 on 6/12/20.
//  Copyright © 2020 Qinzhou Xu. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import SwiftSpinner

class SectionViewController: UIViewController, IndicatorInfoProvider {
    
    // MARK: Properities
    @IBOutlet weak var sectionTableView: UITableView!
    @IBOutlet weak var sectionScrollView: UIScrollView!
    
    var sectionName: String?
    var utils: Utils!
    var tableHandler: NewsTableViewHandler!
    
    // MARK: Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SwiftSpinner.show("Loading \(self.sectionName ?? "WORLD") Headlines..")
        configureContent()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tableHandler.modifyBookmarks()
    }
    
    func configureContent() {
        self.utils = Utils(controller: self)
        self.tableHandler = NewsTableViewHandler(controller: self, type: "Section", sectionName: self.sectionName!.lowercased())
        sectionTableView.dataSource = self.tableHandler
        sectionTableView.delegate = self.tableHandler
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: self.sectionName)
    }

}
