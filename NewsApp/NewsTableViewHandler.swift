//
//  newsTableViewHandler.swift
//  NewsApp
//
//  Created by 沁洲 许 on 6/7/20.
//  Copyright © 2020 Qinzhou Xu. All rights reserved.
//

import UIKit
import SwiftyJSON
import SwiftSpinner
import Alamofire
import Toast_Swift

class NewsTableViewHandler: NSObject, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: Properities
    var news = [NewsAbstract]()
    var image = [Data]()
    var cells = [NewsTableViewCell]()
    var utils: Utils!
    var controller: UIViewController!
    var type: String!
    var keyword: String?
    var sectionName: String?
    var refreshControl: UIRefreshControl!
    
    func basicInit(controller: UIViewController, type: String) {
        self.controller = controller
        self.type = type
        self.utils = Utils(controller: controller)
        self.loadNews()
        self.addRefreshControll()
    }
    
    init(controller: UIViewController, type: String) {
        super.init()
        basicInit(controller: controller, type: type)
    }
    
    init(controller: UIViewController, type: String, keyword: String) {
        super.init()
        self.keyword = keyword
        basicInit(controller: controller, type: type)
    }
    
    init(controller: UIViewController, type: String, sectionName: String) {
        super.init()
        self.sectionName = sectionName
        basicInit(controller: controller, type: type)
    }
    
    // MARK: Private Methods
    
    func modifyBookmarks() {
        for i in 0..<self.news.count {
            if DataManager.isNewsSaved(id: news[i].id) {
                self.cells[i].bookmarkButton.setImage(UIImage(systemName: "bookmark.fill"), for: .normal)
            }
            else {
                self.cells[i].bookmarkButton.setImage(UIImage(systemName: "bookmark"), for: .normal)
            }
        }
    }
    
    func addResult(response: AFDataResponse<Any>) {
        self.news.removeAll()
        let news_arr = JSON(response.data!)["news_arr"].array!
        for newsObj in news_arr {
            let abstract = NewsAbstract(image: newsObj["image"].string!, title: newsObj["title"].string!,
                                        time: newsObj["time"].string!, section: newsObj["section"].string!,
                                        id: newsObj["id"].string!, webUrl: newsObj["webUrl"].string!,
                                        date: newsObj["date"].string!)
            self.news += [abstract]
        }
    }
    
    func loadNews() {
        switch type {
        case "Home":
            utils.getHomeNews(completion: { response in
                if response.error != nil {
                    self.utils.showNetworkAlert()
                }
                else {
                    self.addResult(response: response)
                    let homeView = self.controller as! HomeViewController
                    homeView.newsTableView.reloadData()
                    SwiftSpinner.hide()
                }
            })
        case "Search":
            utils.getSearchResult(keyword: self.keyword!, completion: { response in
                if response.error != nil {
                    self.utils.showNetworkAlert()
                }
                else {
                    self.addResult(response: response)
                    let searchView = self.controller as! SearchResultsViewController
                    searchView.searchResultTableView.reloadData()
                    SwiftSpinner.hide()
                }
            })
        case "Section":
            utils.getSectionNews(sectionName: self.sectionName!, completion: { response in
                if response.error != nil {
                    self.utils.showNetworkAlert()
                }
                else {
                    self.addResult(response: response)
                    let sectionView = self.controller as! SectionViewController
                    sectionView.sectionTableView.reloadData()
                    SwiftSpinner.hide()
                }
            })
        default:
            print("No matching type.")
        }
    }
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        switch type {
        case "Home":
            utils.getHomeNews(completion: { response in
                if response.error != nil {
                    self.utils.showNetworkAlert()
                }
                else {
                    self.addResult(response: response)
                    let homeView = self.controller as! HomeViewController
                    homeView.newsTableView.reloadData()
                    homeView.updateWheather()
                    refreshControl.endRefreshing()
                }
            })
        case "Search":
            utils.getSearchResult(keyword: self.keyword!, completion: { response in
                if response.error != nil {
                    self.utils.showNetworkAlert()
                }
                else {
                    self.addResult(response: response)
                    let searchView = self.controller as! SearchResultsViewController
                    searchView.searchResultTableView.reloadData()
                    refreshControl.endRefreshing()
                }
            })
        case "Section":
            utils.getSectionNews(sectionName: self.sectionName!, completion: { response in
                if response.error != nil {
                    self.utils.showNetworkAlert()
                }
                else {
                    self.addResult(response: response)
                    let sectionView = self.controller as! SectionViewController
                    sectionView.sectionTableView.reloadData()
                    refreshControl.endRefreshing()
                }
            })
        default:
            print("No matching type.")
        }
    }
    
    func addRefreshControll() {
        self.refreshControl = UIRefreshControl()
        self.refreshControl.addTarget(self,
                                      action: #selector(self.handleRefresh(_:)),
                                      for: .valueChanged)
        switch type {
        case "Home":
            let homeView = self.controller as! HomeViewController
            homeView.homeScrollView.addSubview(self.refreshControl)
        case "Search":
            let searchView = self.controller as! SearchResultsViewController
            searchView.searchScrollView.addSubview(self.refreshControl)
        case "Section":
            let sectionView = self.controller as! SectionViewController
            sectionView.sectionScrollView.addSubview(self.refreshControl)
        default:
            print("No matching type.")
        }
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return news.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "NewsTableViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? NewsTableViewCell else{
            fatalError("The dequeued cell is not an instance of NewsTableViewCell.")
        }
        
        let newsObj = news[indexPath.row]
        
        // load image from URL
        if newsObj.image == "" {
            cell.newsImage.image = UIImage(named: "default-guardian")
        }
        else {
            let url = URL(string: newsObj.image!)
            let data = try? Data(contentsOf: url!)
            cell.newsImage.image = UIImage(data: data!)
        }
        self.image.append(cell.newsImage.image!.pngData()!)
        
        // change text
        cell.newsTitleLabel.text = newsObj.title
        cell.newsTimeLabel.text = newsObj.time
        cell.newsSectionLabel.text = newsObj.section
        if DataManager.isNewsSaved(id: newsObj.id) {
            cell.bookmarkButton.setImage(UIImage(systemName: "bookmark.fill"), for: .normal)
        }
        else {
            cell.bookmarkButton.setImage(UIImage(systemName: "bookmark"), for: .normal)
        }
        cell.bookmarkButton.tag = indexPath.row
        cell.bookmarkButton.addTarget(self, action: #selector(self.handleSave(sender:)), for: .touchUpInside)
        
        // configure style
        cell.newsTableCellView.layer.cornerRadius = 10.0
        cell.newsImageView.layer.cornerRadius = 10.0
        cell.newsTableCellView.backgroundColor = Utils.getCellColor()
        
        self.cells.append(cell)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // instantiate a new detail view controller
        let detailController = controller.storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        
        // prepare data for new view controller
        detailController.newsObj = self.news[indexPath.row]
        
        self.controller.navigationController?.pushViewController(detailController, animated: true)
    }
    
    // MARK: Context Menu Methods
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil, actionProvider: { suggestedActions in
            return self.makeContextMenu(index: indexPath.row)
        })
    }
    
    func makeContextMenu(index: Int) -> UIMenu {
        let newsObj = self.news[index]
        let shareUrl = "https://twitter.com/intent/tweet?url=\(newsObj.webUrl)&text=Check%20out%20this%20article!"
        
        let share = UIAction(title: "Share with Twitter", image: UIImage(named: "twitter")) { action in
            if let url = URL(string: shareUrl) {
                UIApplication.shared.open(url)
            }
        }
        let bookmark = UIAction(title: "Bookmark", image: UIImage(systemName: "bookmark")) { action in
            self.handleSave(index: index)
        }
        return UIMenu(title: "Menu", children: [share, bookmark])
    }
    
    func handleSave(index: Int) {
        let newsObj = self.news[index]
        let imageData = self.image[index]
        
        if (DataManager.isNewsSaved(id: newsObj.id)) {
            DataManager.removeNews(id: newsObj.id)
            self.cells[index].bookmarkButton.setImage(UIImage(systemName: "bookmark"), for: .normal)
            self.controller.view.makeToast("Article Removed from Bookmarks")
        }
        else {
            DataManager.saveNews(newsObj: newsObj, imageData: imageData)
            self.cells[index].bookmarkButton.setImage(UIImage(systemName: "bookmark.fill"), for: .normal)
            self.controller.view.makeToast("Article Bookmarked. Check out the Bookmarks tab to view")
        }
    }
    
    @objc func handleSave(sender: UIButton) {
        handleSave(index: sender.tag)
    }
    
}
