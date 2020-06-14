//
//  SearchResultsViewController.swift
//  NewsApp
//
//  Created by 沁洲 许 on 6/11/20.
//  Copyright © 2020 Qinzhou Xu. All rights reserved.
//

import UIKit
import SwiftSpinner

class SearchResultsViewController: UIViewController {
    
    // MARK: Properities
    @IBOutlet weak var searchResultTableView: UITableView!
    @IBOutlet weak var searchScrollView: UIScrollView!
    
    var keyword: String?
    var tableHandler: NewsTableViewHandler!
    
    // MARK: Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SwiftSpinner.show("Loading Search Results..")
        configureComponents()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tableHandler.modifyBookmarks()
    }
    
    func configureComponents() {
        tableHandler = NewsTableViewHandler(controller: self, type: "Search",
                                            keyword: self.keyword ?? "Amazon")
        searchResultTableView.delegate = tableHandler as UITableViewDelegate
        searchResultTableView.dataSource = tableHandler as UITableViewDataSource
    }

}
