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
    
    var alert: dispatch_once_t = 0 // initialize alert to 0 in order to display alert only once (see location manager below)
    
    var locationManager = CLLocationManager()
    
    // Script after location update
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        
        // get the last location
        let lastLocation = locations.last!
        print(lastLocation)
        
        // Request for the API
        // Get 50 cities around the latitude and longitude parameters in metric format (celsius)
        requestJSON("http://api.openweathermap.org/data/2.5/find", params: [ // see Helpers.swift
            "lat": "\(lastLocation.coordinate.latitude)",
            "lon": "\(lastLocation.coordinate.longitude)",
            "units": "metric",
            "cnt": "50",
            "APPID":"09328b052302c57443b23a48d0e9fc9f"
            
            // Display error if request or parameters are wrong
            ]) { (json, error) -> Void in
                if error != nil {
                    print(error?.localizedDescription)
                    return
                }
                if let status = json["status"].dictionary {
                    print("Error")
                }else if let cities = json["list"].array { // convert the list of cities to array (response)
                    self.citiesDisplayed = [CityInfo]()
                    
                    // Inject array of CityInfo object to cities and append also to citiesDisplayed
                    self.cities = cities.reduce([CityInfo]()) { (citiesInfo, json) -> [CityInfo] in
                        var citiesCopy = citiesInfo
                        if let cityInfo = CityInfo(json: json) {
                            citiesCopy.append(cityInfo)
                            self.citiesDisplayed.append(cityInfo)
                        }
                        return citiesCopy
                    }
                    
                    // Sort the cities displayed by distance (ASC)
                    self.citiesDisplayed = self.citiesDisplayed.sort({ $0.distance < $1.distance })
                    
                    // Function to count the number of ciities in the array and execute the alert once for every instance
                    func displayDialogOnce() { dispatch_once(&self.alert) {
                        let citiesCount = self.citiesDisplayed.count
                        if citiesCount == 0 {
                            self.displayAlert("Ou fait-il beau ?", message:"Aucune ville fait beau autour de vous")
                        } else {
                            self.displayAlert("Ou fait-il beau ?", message:"Il y'a actuellement \(citiesCount) villes ou il fait beau atour de vous")
                        }
                      }
                    }
                    
                    // helper method (see Helpers.swift)
                    M {
                        displayDialogOnce() // display alert box
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
    
    // change row height
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        return 60.0; // custom row height
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
        // Sort cities after filtering with the sarchbar
        self.citiesDisplayed = self.citiesDisplayed.sort({ $0.distance < $1.distance })
        self.tableView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // location manager configuration
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

