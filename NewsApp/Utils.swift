//
//  Utils.swift
//  NewsApp
//
//  Created by 沁洲 许 on 6/6/20.
//  Copyright © 2020 Qinzhou Xu. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class Utils {
    
    // MARK: Properties
    var controller: UIViewController!
    static let weatherDict: [String: String] = [
        "Clouds": "cloudy_weather",
        "Clear": "clear_weather",
        "Snow": "snowy_weather",
        "Rain": "rainy_weather",
        "Thunderstorm": "thunder_weather"
    ]
    let baseUrl = "http://localhost:5000/"
    
    // MARK: Methods
    init(controller: UIViewController) {
        self.controller = controller
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
        NSLog("alert occured.")
        }))
        self.controller.present(alert, animated: true, completion: nil)
    }
    
    func showLocationAlert() {
        // show alert for location error
        self.showAlert(title: "Current Location Not Avaliable", message: "your current location can not be determined at this time")
    }
    
    func showLocationAuthorizationAlert() {
        self.showAlert(title: "Please Enable Location Authorization", message: "your current location can not be determined at this time")
    }
    
    func showNetworkAlert() {
        self.showAlert(title: "Network Request Error", message: "an error has occured when making network request")
    }
    
    static func getWeatherPics(weather: String!) -> String {
        return self.weatherDict[weather] ?? "sunny_weather"
    }
    
    static func createStateDict() -> NSDictionary {
        let stateCodes = ["AL","AK","AZ","AR","CA","CO","CT","DE","DC","FL","GA","HI","ID","IL","IN","IA","KS","KY","LA","ME","MD","MA","MI","MN","MS","MO","MT","NE","NV","NH","NJ","NM","NY","NC","ND","OH","OK","OR","PA","RI","SC","SD","TN","TX","UT","VT","VA","WA","WV","WI","WY"]
        let fullStateNames = ["Alabama","Alaska","Arizona","Arkansas","California","Colorado","Connecticut","Delaware","District of Columbia","Florida","Georgia","Hawaii","Idaho","Illinois","Indiana","Iowa","Kansas","Kentucky","Louisiana","Maine","Maryland","Massachusetts","Michigan","Minnesota","Mississippi","Missouri","Montana","Nebraska","Nevada","New Hampshire","New Jersey","New Mexico","New York","North Carolina","North Dakota","Ohio","Oklahoma","Oregon","Pennsylvania","Rhode Island","South Carolina","South Dakota","Tennessee","Texas","Utah","Vermont","Virginia","Washington","West Virginia","Wisconsin","Wyoming"]
        let dic = NSDictionary(objects: fullStateNames, forKeys:stateCodes as [NSCopying])
        return dic
    }
    
    static func getCellColor() -> UIColor {
        // dark mode cell color
        if #available(iOS 13.0, *) {
            return UIColor { (traits) -> UIColor in
                // Return one of two colors depending on light or dark mode
                return traits.userInterfaceStyle == .dark ?
                    UIColor(red: 0.15, green: 0.15, blue: 0.15, alpha: 1) :
                    UIColor(red: 0.905, green: 0.905, blue: 0.905, alpha: 1)
            }
        }
        else {
            // Color for IOS 12 and ealier
            return UIColor(red: 0.905, green: 0.905, blue: 0.905, alpha: 1)
        }
    }
    
    func getWeather(city: String, completion: @escaping (AFDataResponse<Any>) -> Void) {
        let url = "https://api.openweathermap.org/data/2.5/weather"
        let params = [
            "q": city,
            "units": "metric",
            "appid": "bf67e1841a3e25a97ed2f16c63198e3e"
        ]
        AF.request(url, parameters: params)
            .responseJSON(completionHandler: completion)
    }
    
    func getHomeNews(completion: @escaping (AFDataResponse<Any>) -> Void) {
        let url = "\(baseUrl)guardian/home"
        AF.request(url)
            .responseJSON(completionHandler: completion)
    }
    
    func getNewsDetail(id: String, completion: @escaping (AFDataResponse<Any>) -> Void) {
        let url = "\(baseUrl)guardian/detail"
        let params = [
            "id": id
        ]
        AF.request(url, parameters: params)
            .responseJSON(completionHandler: completion)
    }
    
    func getSearchResult(keyword: String, completion: @escaping (AFDataResponse<Any>) -> Void) {
        let url = "\(baseUrl)guardian/search"
        let params = [
            "keyword": keyword
        ]
        AF.request(url, parameters: params)
            .responseJSON(completionHandler: completion)
    }
    
    func getSuggestion(input: String, completion: @escaping (AFDataResponse<Any>) -> Void) {
        let url = "https://api.cognitive.microsoft.com/bing/v7.0/suggestions"
        let params = [
            "q": input,
            "cc": "en-US",
            "setLang": "en"
        ]
        let headers: HTTPHeaders = ["Ocp-Apim-Subscription-Key": "7421dbf8bba6406ca654a710987d8f6d"]
        AF.request(url, parameters: params, headers: headers)
            .responseJSON(completionHandler: completion)
    }
    
    func getTrends(keyword: String, completion: @escaping (AFDataResponse<Any>) -> Void) {
        let url = "\(baseUrl)trends"
        let params = [
            "keyword": keyword
        ]
        AF.request(url, parameters: params)
        .responseJSON(completionHandler: completion)
    }
    
    func getSectionNews(sectionName: String, completion: @escaping (AFDataResponse<Any>) -> Void) {
        let url = "\(baseUrl)guardian/section"
        let params = [
            "sectionName": sectionName
        ]
        AF.request(url, parameters: params)
        .responseJSON(completionHandler: completion)
    }
    
}
