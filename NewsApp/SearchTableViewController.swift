//
//  SearchTableViewController.swift
//  NewsApp
//
//  Created by 沁洲 许 on 6/11/20.
//  Copyright © 2020 Qinzhou Xu. All rights reserved.
//

import UIKit

class SearchTableViewController: UITableViewController {
    
    // MARK: Properities
    var suggests = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.suggests.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "SearchTableViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? SearchTableViewCell else{
            fatalError("The dequeued cell is not an instance of SearchTableViewCell.")
        }
        
        cell.suggestLabel.text = self.suggests[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // instantiate a search result view controller
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let searchResultsViewController = storyboard.instantiateViewController(withIdentifier: "SearchResultsViewController") as! SearchResultsViewController
        
        // prepare data for new view controller
        searchResultsViewController.keyword = self.suggests[indexPath.row]
        
        self.presentingViewController?.navigationController?.pushViewController(searchResultsViewController, animated: true)
    }

}
