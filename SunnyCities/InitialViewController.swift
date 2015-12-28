//
//  ViewController.swift
//  SunnyCities
//
//  Created by Stefan Atkinson on 28/12/2015.
//  Copyright © 2015 Stefan Atkinson. All rights reserved.
//

import UIKit
import CoreLocation

class InitialViewController: UIViewController, CLLocationManagerDelegate, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    private var cities = [CityInfo]()
    private var citiesDisplayed = [CityInfo]()
    
    
    
    var locationManager = CLLocationManager()
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        let lastLocation = locations.last!
        print(lastLocation)
        let accurrancy = 0.2
        requestJSON("http://api.geonames.org/citiesJSON", params: [
            "north":"\(lastLocation.coordinate.latitude + accurrancy)",
            "south":"\(lastLocation.coordinate.latitude - accurrancy)",
            "east":"\(lastLocation.coordinate.longitude + accurrancy)",
            "west":"\(lastLocation.coordinate.longitude - accurrancy)",
            "lang":"en",
            "username":"stefan694" // geonames username.
            ]) { (json, error) -> Void in
                if error != nil {
                    print(error?.localizedDescription)
                    return
                }
                if let status = json["status"].dictionary {
                    print("Error")
                }else if let cities = json["geonames"].array {
                    self.citiesDisplayed = [CityInfo]()
                    self.cities = cities.reduce([CityInfo]()) { (citiesInfo, json) -> [CityInfo] in
                        var citiesCopy = citiesInfo
                        if let cityInfo = CityInfo(json: json) {
                            citiesCopy.append(cityInfo)
                            self.citiesDisplayed.append(cityInfo)
                        }
                        return citiesCopy
                    }
                    
                    M {
                        self.tableView.reloadData()
                    }
                }else {
                    print("error")
                }
        }
    }
    
    // MARK: - TableView Datasource and delegate
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return self.citiesDisplayed.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCellWithIdentifier("cityinfocell") as! CityInfoCell
        cell.cityInfo = self.citiesDisplayed[indexPath.row]
        return cell
    }
    
    // MARK: - UISearchBar delegate
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        self.citiesDisplayed = [CityInfo]()
        for cityInfo in self.cities {
            if searchText == "" {
                citiesDisplayed.append(cityInfo)
            }else if cityInfo.name.lowercaseString.rangeOfString(searchText.lowercaseString) != nil{
                citiesDisplayed.append(cityInfo)
            }
        }
        self.tableView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
        locationManager.distanceFilter = 3000
        if locationManager.respondsToSelector(Selector("requestWhenInUseAuthorization")) {
            locationManager.requestWhenInUseAuthorization()
        }
        locationManager.startUpdatingLocation()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

