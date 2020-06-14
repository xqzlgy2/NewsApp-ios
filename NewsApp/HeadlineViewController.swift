//
//  HeadlineViewController.swift
//  NewsApp
//
//  Created by 沁洲 许 on 6/3/20.
//  Copyright © 2020 Qinzhou Xu. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class HeadlineViewController: ButtonBarPagerTabStripViewController {
    
    // MARK: Properities
    var searchController: SearchController!
    
    // MARK: Methods
    override func viewDidLoad() {
        self.searchController = SearchController(controller: self)
        self.configureButtonBar()
        
        super.viewDidLoad()
    }
    
    func configureButtonBar() {
        settings.style.buttonBarBackgroundColor = .systemBackground
        settings.style.buttonBarItemBackgroundColor = .systemBackground
        settings.style.selectedBarBackgroundColor = .systemBackground
        settings.style.buttonBarItemFont = .systemFont(ofSize: 15)
        settings.style.buttonBarItemTitleColor = .systemGray
        
        settings.style.buttonBarMinimumLineSpacing = 0
        settings.style.buttonBarItemsShouldFillAvailableWidth = true
        settings.style.buttonBarLeftContentInset = 0
        settings.style.buttonBarRightContentInset = 0
        
        settings.style.selectedBarHeight = 3.0
        settings.style.selectedBarBackgroundColor = .systemBlue
        
        changeCurrentIndexProgressive = { (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
            guard changeCurrentIndex == true else { return }
            oldCell?.label.textColor = .systemGray
            newCell?.label.textColor = .systemBlue
        }
    }
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        let sectionNames = ["WORLD", "BUSINESS", "POLITICS", "SPORT", "TECHNOLOGY", "SCIENCE"]
        return sectionNames.map({(sectionName: String) -> UIViewController in
            let child = self.storyboard?.instantiateViewController(withIdentifier: "SectionViewController") as! SectionViewController
            child.sectionName = sectionName
            return child
        })
    }

}

