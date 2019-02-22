//
//  ViewController.swift
//  WeatherApp
//
//  Created by Angela Yu on 23/08/2015.
//  Copyright (c) 2015 London App Brewery. All rights reserved.
//

import UIKit
import CoreLocation


class WeatherViewController: UIViewController, CLLocationManagerDelegate {
    
    //Constants
    let WEATHER_URL = "http://api.openweathermap.org/data/2.5/weather"
    let APP_KEY = "6539a2ac14afbfd211405e7baef6622e"
    /***Get your own App ID at https://openweathermap.org/appid ****/
    

    //TODO: Declare instance variables here
    let locationMgr = CLLocationManager();

    
    //Pre-linked IBOutlets
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //TODO:Set up the location manager here.
        locationMgr.delegate = self;
        locationMgr.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationMgr.requestWhenInUseAuthorization();
        locationMgr.startUpdatingLocation();
        
    }
    
    
    
    //MARK: - Networking
    /***************************************************************/
    
    //Write the getWeatherData method here:
    

    
    
    
    
    
    //MARK: - JSON Parsing
    /***************************************************************/
   
    
    //Write the updateWeatherData method here:
    

    
    
    
    //MARK: - UI Updates
    /***************************************************************/
    
    
    //Write the updateUIWithWeatherData method here:
    
    
    
    
    
    
    //MARK: - Location Manager Delegate Methods
    /***************************************************************/
    
    
    //Write the didUpdateLocations method here:
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // last location is the most accurate
        let lastLoc = locations[locations.count - 1];
        
        //check valid location
        if (lastLoc.horizontalAccuracy > 0) {
            locationMgr.stopUpdatingLocation();
            
            let latitude = String(lastLoc.coordinate.latitude);
            let longitude = String(lastLoc.coordinate.longitude);
            print("Got current (last) location with la '\(latitude)' and lo '\(longitude)'");
            
            let latLong: [String: String] = ["lat": latitude, "lon": longitude, "appid": APP_KEY];
            
        }
    }
    
    //Write the didFailWithError method here:
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Can not get current location: \(error)");
        cityLabel.text = "Location Unavailable";
    }
    
    //MARK: - Change City Delegate methods
    /***************************************************************/
    
    
    //Write the userEnteredANewCityName Delegate method here:
    

    
    //Write the PrepareForSegue Method here
    
    
    
    
    
}


