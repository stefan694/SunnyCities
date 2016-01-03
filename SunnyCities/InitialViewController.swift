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
    let backgroundImage = UIImageView(image: UIImage(named: "SunnyBackground"))
    
    var locationManager = CLLocationManager()
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        let lastLocation = locations.last!
        requestJSON("http://api.openweathermap.org/data/2.5/find", params: [
            "lat": "\(lastLocation.coordinate.latitude)",
            "lon": "\(lastLocation.coordinate.longitude)",
            "units": "metric",
            "cnt": "50",
            "APPID":"09328b052302c57443b23a48d0e9fc9f"
            ]) { (json, error) -> Void in
                if error != nil {
                    print(error?.localizedDescription)
                    return
                }
                if let status = json["status"].dictionary {
                    print("Error")
                }else if let cities = json["list"].array {
                    self.citiesDisplayed = [CityInfo]()
                    self.cities = cities.reduce([CityInfo]()) { (citiesInfo, json) -> [CityInfo] in
                        var citiesCopy = citiesInfo
                        if let cityInfo = CityInfo(json: json) {
                            citiesCopy.append(cityInfo)
                            self.citiesDisplayed.append(cityInfo)
                        }
                        return citiesCopy
                    }
                    
                    self.citiesDisplayed = self.citiesDisplayed.sort({ $0.distance < $1.distance })
                    
                    /*
                    let citiesCount = self.citiesDisplayed.count
                    if citiesCount == 0 {
                        self.displayAlert("Ou fait-il beau ?", message:"Aucune ville fait beau autour de vous")
                    } else {
                        self.displayAlert("Ou fait-il beau ?", message:"Il y'a actuellement \(citiesCount) villes ou il fait beau atour de vous")
                    }
                    */
                    
                    M {
                        self.tableView.reloadData()
                    }
                }else {
                    print("error")
                }
        }
    }
    
    // alert dialog
    func displayAlert (title: String, message: String) {
        let prompt = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        prompt.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
        presentViewController(prompt, animated: true, completion: nil)
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
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        
        let viewController = self.storyboard?.instantiateViewControllerWithIdentifier("cityoptions") as! CityOptionsViewController
        viewController.cityInfo = self.citiesDisplayed[indexPath.row]
        self.presentViewController(viewController, animated: true, completion: nil)
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
        
        self.citiesDisplayed = self.citiesDisplayed.sort({ $0.distance < $1.distance })
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
        backgroundImage.contentMode = .ScaleAspectFill
        tableView.backgroundView = backgroundImage
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

