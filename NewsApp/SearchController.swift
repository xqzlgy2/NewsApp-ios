//
//  SearchController.swift
//  NewsApp
//
//  Created by 沁洲 许 on 6/11/20.
//  Copyright © 2020 Qinzhou Xu. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class SearchController: NSObject, UISearchResultsUpdating {
    
    // MARK: Properities
    var masterController: UIViewController!
    var searchController: UISearchController!
    var searchTableViewController: SearchTableViewController!
    
    var utils: Utils!
    
    // MARK: Methods
    init(controller: UIViewController) {
        super.init()
        self.masterController = controller
        self.utils = Utils(controller: controller)
        
        self.searchTableViewController = masterController.storyboard?.instantiateViewController(withIdentifier: "SearchTableViewController") as? SearchTableViewController
        self.searchController = UISearchController(searchResultsController: self.searchTableViewController)
        
        self.configureSearchController()
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        if searchBar.text!.count >= 3 {
            let input = searchBar.text!
            
            utils.getSuggestion(input: input, completion: { response in
                if response.error != nil {
                    self.utils.showNetworkAlert()
                }
                else {
                    self.searchTableViewController.suggests.removeAll()
                    
                    let suggestions = JSON(response.data!)["suggestionGroups"].array?[0]["searchSuggestions"].array
                    if suggestions != nil {
                        for suggestion in suggestions! {
                            self.searchTableViewController.suggests += [suggestion["displayText"].string!]
                        }
                    }

                    self.searchTableViewController.tableView.reloadData()
                }
            })
        }
    }
    
    func configureSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = true
        searchController.searchBar.placeholder = "Enter keyword.."
        searchController.definesPresentationContext = true
        masterController.navigationItem.searchController = searchController
    }
    
}
