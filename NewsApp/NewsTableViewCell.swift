//
//  NewsTableViewCell.swift
//  NewsApp
//
//  Created by 沁洲 许 on 6/6/20.
//  Copyright © 2020 Qinzhou Xu. All rights reserved.
//

import UIKit

class NewsTableViewCell: UITableViewCell {
    
    // MARK: Properities
    @IBOutlet weak var newsImage: UIImageView!
    @IBOutlet weak var newsTitleLabel: UILabel!
    @IBOutlet weak var newsTimeLabel: UILabel!
    @IBOutlet weak var newsSectionLabel: UILabel!
    @IBOutlet weak var newsTableCellView: UIView!
    @IBOutlet weak var newsImageView: UIView!
    @IBOutlet weak var bookmarkButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
