//
//  TrendingViewController.swift
//  NewsApp
//
//  Created by 沁洲 许 on 6/12/20.
//  Copyright © 2020 Qinzhou Xu. All rights reserved.
//

import UIKit
import Charts
import SwiftyJSON
import Alamofire

class TrendingViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: Properities
    @IBOutlet weak var keywordTextField: UITextField!
    @IBOutlet weak var chartView: LineChartView!
    
    var utils: Utils!
    
    // MARK: Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.utils = Utils(controller: self)
        self.keywordTextField.delegate = self
        self.getTrends(keyword: "Coronavirus")
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let keyword = textField.text ?? "Coronavirus"
        self.getTrends(keyword: keyword)
        textField.resignFirstResponder()
        return true
    }
    
    func getTrends(keyword: String) {
        utils.getTrends(keyword: keyword, completion: { response in
            if response.error != nil {
                self.utils.showNetworkAlert()
            }
            else {
                let trendsData = JSON(response.data!)["trends_data"].array!
                var lineChartEntry = [ChartDataEntry]()
                
                for i in 0..<trendsData.count {
                    let value = ChartDataEntry(x: Double(i), y: trendsData[i].double!)
                    lineChartEntry.append(value)
                }
                
                let line = LineChartDataSet(entries: lineChartEntry, label: "Trending Chart for \(keyword)")
                let color = NSUIColor(red: 47.0/255.0, green: 124.0/255.0, blue: 246.0/255.0, alpha: 1.0)
                line.colors = [color]
                line.circleColors = [color]
                line.circleHoleRadius = 0.0
                line.circleRadius = 5.0
                
                let data = LineChartData()
                data.addDataSet(line)
                
                self.chartView.data = data
            }
        })
    }

}
