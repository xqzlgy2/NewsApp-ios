//
//  DetailViewController.swift
//  NewsApp
//
//  Created by 沁洲 许 on 6/8/20.
//  Copyright © 2020 Qinzhou Xu. All rights reserved.
//

import UIKit
import SwiftyJSON
import SwiftSpinner
import Alamofire
import Toast_Swift

class NewsDetail {
    
    var image: String?
    var title: String
    var time: String
    var description: String
    
    init(image: String?, title: String, time: String, description: String) {
        self.image = image
        self.title = title
        self.time = time
        self.description = description
    }
}

class DetailViewController: UIViewController {
    
    // MARK: Properities
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var bookmarkButton: UIBarButtonItem!
    @IBOutlet weak var viewFullButton: UIButton!
    @IBOutlet weak var newsImage: UIImageView!
    @IBOutlet weak var newsTitleLabel: UILabel!
    @IBOutlet weak var newsSectionLabel: UILabel!
    @IBOutlet weak var newsDateLabel: UILabel!
    @IBOutlet weak var newsDetailLabel: UILabel!
    
    var newsObj: NewsAbstract!
    var utils: Utils!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SwiftSpinner.show("Loading Detailed article..")
        self.utils = Utils(controller: self)
        self.configureComponents()
        self.getDetailData()
    }
    
    // MARK: Methods
    func configureComponents() {
        self.shareButton.target = self
        self.shareButton.action = #selector(self.handleShare(sender:))
        self.bookmarkButton.target = self
        self.bookmarkButton.action = #selector(self.handleSave(sender:))
        self.viewFullButton.addTarget(self, action: #selector(self.handleViewFull(sender:)), for: .touchUpInside)
        if DataManager.isNewsSaved(id: newsObj.id) {
            self.bookmarkButton.image = UIImage(systemName: "bookmark.fill")
        }
        else {
            self.bookmarkButton.image = UIImage(systemName: "bookmark")
        }
    }
    
    func openURL(url: String) {
        if let url = URL(string: url) {
            UIApplication.shared.open(url)
        }
    }
    
    @objc func handleShare(sender: UIBarButtonItem) {
        let shareUrl = "https://twitter.com/intent/tweet?url=\(self.newsObj.webUrl)&text=Check%20out%20this%20article!"
        self.openURL(url: shareUrl)
    }
    
    @objc func handleSave(sender: UIBarButtonItem) {
        
        if (DataManager.isNewsSaved(id: newsObj.id)) {
            DataManager.removeNews(id: newsObj.id)
            self.bookmarkButton.image = UIImage(systemName: "bookmark")
            self.view.makeToast("Article Removed from Bookmarks")
        }
        else {
            DataManager.saveNews(newsObj: newsObj, imageData: self.newsImage.image!.pngData()!)
            self.bookmarkButton.image = UIImage(systemName: "bookmark.fill")
            self.view.makeToast("Article Bookmarked. Check out the Bookmarks tab to view")
        }
    }
    
    @objc func handleViewFull(sender: UIButton) {
        let webUrl = newsObj.webUrl
        self.openURL(url: webUrl)
    }
    
    func loadComponentContent(response: AFDataResponse<Any>) {
        let json = JSON(response.data!)["news_detail"]
        let title = json["title"].string!
        let image = json["image"].string!
        let description = json["description"].string!
        let date = json["date"].string!
        
        // load image from URL
        if image == "" {
            self.newsImage.image = UIImage(named: "default-guardian")
        }
        else {
            let url = URL(string: image)
            let data = try? Data(contentsOf: url!)
            self.newsImage.image = UIImage(data: data!)
        }
        
        // load components' data
        self.newsTitleLabel.text = title
        self.newsSectionLabel.text = self.newsObj.section
        self.newsDateLabel.text = date
        self.newsDetailLabel.text = description
    }
    
    func getDetailData() {
        self.utils.getNewsDetail(id: self.newsObj.id, completion: { response in
            if response.error != nil {
                self.utils.showNetworkAlert()
            }
            else {
                self.loadComponentContent(response: response)
                SwiftSpinner.hide()
            }
        })
    }

}
