//
//  HomeViewController.swift
//  NewsApp
//
//  Created by 沁洲 许 on 6/3/20.
//  Copyright © 2020 Qinzhou Xu. All rights reserved.
//

import UIKit
import CoreLocation
import SwiftyJSON
import SwiftSpinner

class HomeViewController: UIViewController, CLLocationManagerDelegate {
    
    //MARK: Properties
    @IBOutlet weak var weatherImageView: UIImageView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var stateLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var weatherLabel: UILabel!
    @IBOutlet weak var newsTableView: UITableView!
    @IBOutlet weak var homeScrollView: UIScrollView!
    
    let locationManager: CLLocationManager = CLLocationManager()
    var tableHandler: NewsTableViewHandler!
    var utils: Utils!
    var stateDict: NSDictionary!
    var searchController: SearchController!
    
    // MARK: Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        SwiftSpinner.show("Loading Home Page..")
        
        self.utils = Utils(controller: self)
        self.stateDict = Utils.createStateDict()
        self.tableHandler = NewsTableViewHandler(controller: self, type: "Home")
        self.searchController = SearchController(controller: self)
        
        self.configureComponents()
        self.configureLocationManager()
        self.updateWheather()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tableHandler.modifyBookmarks()
    }

    func configureComponents() {
        // configure UI style
        weatherImageView.layer.cornerRadius = 10.0
        newsTableView.dataSource = tableHandler as UITableViewDataSource
        newsTableView.delegate = tableHandler as UITableViewDelegate
    }
    
    func configureLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        // deal with authorization result
        switch status {
        case .restricted, .denied, .notDetermined:
            self.utils.showLocationAuthorizationAlert()
        default:
            locationManager.startUpdatingLocation()
        }
    }
    
    func updateWheather() {
        if let lastLocation = self.locationManager.location {
            let geocoder = CLGeocoder()
            
            // get placemarks from coordinate
            geocoder.reverseGeocodeLocation(lastLocation,
                        completionHandler: { (placemarks, error) in
                if error == nil {
                    let firstLocation = placemarks?[0]
                    self.updateWeatherView(placemark: firstLocation!)
                }
                else {
                    self.utils.showLocationAlert()
                }
            })
        }
        else {
            // current Location is not avaliable
            self.utils.showLocationAlert()
        }
    }
    
    func updateWeatherView(placemark: CLPlacemark) {
        let city = placemark.locality ?? "Los Angeles"
        let state = placemark.administrativeArea ?? "CA"
        
        self.utils.getWeather(city: city, completion: { response in
            if response.error != nil {
                self.utils.showNetworkAlert()
            }
            else {
                let json = JSON(response.data!)
                let temp = Int(round(json["main"]["temp"].double!))
                let summary = json["weather"][0]["main"].string
                let picName = Utils.getWeatherPics(weather: summary)
                
                self.cityLabel.text = city
                self.stateLabel.text = self.stateDict.object(forKey: state) as? String ?? "California"
                self.temperatureLabel.text = "\(temp)°C"
                self.weatherLabel.text = summary
                self.weatherImageView.image = UIImage(named: picName)
            }
        })
    }
    
}
