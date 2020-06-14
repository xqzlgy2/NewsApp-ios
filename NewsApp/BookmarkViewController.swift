//
//  BookmarkViewController.swift
//  NewsApp
//
//  Created by 沁洲 许 on 6/13/20.
//  Copyright © 2020 Qinzhou Xu. All rights reserved.
//

import UIKit

class NewsBookmark {
    
    var id: String
    var title: String
    var date: String
    var section: String
    var webUrl: String
    var imageData: Data
    
    init(id: String, title: String, date: String, section: String, webUrl: String, imageData: Data) {
        self.id = id
        self.title = title
        self.date = date
        self.section = section
        self.webUrl = webUrl
        self.imageData = imageData
    }
}

class BookmarkViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate{
    
    // MARK: Properities
    @IBOutlet weak var bookmarkCollectionView: UICollectionView!
    @IBOutlet weak var emptyLabel: UILabel!
    
    var bookmarks = [NewsBookmark]()
    private let itemsPerRow: CGFloat = 2
    
    // MARK: Methods
    override func viewWillAppear(_ animated: Bool) {
        self.reloadCollection()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bookmarkCollectionView.dataSource = self
        bookmarkCollectionView.delegate = self
    }
    
    func reloadCollection() {
        self.getStoredData()
        if bookmarks.count != 0 {
            emptyLabel.isHidden = true
            bookmarkCollectionView.isHidden = false
            
            bookmarkCollectionView.reloadData()
        }
        else {
            bookmarkCollectionView.isHidden = true
            emptyLabel.isHidden = false
        }
    }
    
    func getStoredData() {
        self.bookmarks.removeAll()
        
        let userDefaults = DataManager.userDefaults
        let dics = userDefaults.dictionaryRepresentation()
        for key in dics {
            let info = DataManager.getNewsInfo(id: key.key)
            let imageData = DataManager.getNewsImage(id: key.key)
            if info != nil && imageData != nil {
                let bookmark = NewsBookmark(id: key.key, title: info!["title"]!, date: info!["date"]!, section: info!["section"]!, webUrl: info!["webUrl"]!, imageData: imageData!)
                self.bookmarks += [bookmark]
            }
        }
    }
    
    // MARK: Data Source
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView,
                                 numberOfItemsInSection section: Int) -> Int {
        return bookmarks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BookmarkCollectionViewCell", for: indexPath) as? BookmarkCollectionViewCell else {
              fatalError("The dequeued cell is not an instance of BookmarkCollectionViewCell.")
          }
        
        let bookmark = bookmarks[indexPath.row]
        cell.newsImageView.image = UIImage(data: bookmark.imageData)
        cell.newsTitle.text = bookmark.title
        cell.newsTime.text = bookmark.date
        cell.newsSection.text = bookmark.section
        
        cell.bookmarkButton.tag = indexPath.row
        cell.bookmarkButton.addTarget(self, action: #selector(self.handleRemove(sender:)), for: .touchUpInside)
        
        cell.contentView.layer.cornerRadius = 10.0
        return cell
    }
    
    @objc func handleRemove(sender: UIButton) {
        let index = sender.tag
        DataManager.removeNews(id: self.bookmarks[index].id)
        self.reloadCollection()
    }
    
    // MARK: Delegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // instantiate a new detail view controller
        let detailController = self.storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        
        // prepare data for new view controller
        let bookmark = self.bookmarks[indexPath.row]
        let newsObj = NewsAbstract(image: "", title: bookmark.title, time: "", section: bookmark.section, id: bookmark.id, webUrl: bookmark.webUrl, date: bookmark.date)
        detailController.newsObj = newsObj
        
        self.navigationController?.pushViewController(detailController, animated: true)
    }

}
