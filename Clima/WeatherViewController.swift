//
//  ViewController.swift
//  WeatherApp
//
//  Created by Angela Yu on 23/08/2015.
//  Copyright (c) 2015 London App Brewery. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire
import SwiftyJSON


class WeatherViewController: UIViewController, CLLocationManagerDelegate,
    ChangeCityDelegate {
    
    //Constants
    let WEATHER_URL = "http://api.openweathermap.org/data/2.5/weather"
    let APP_KEY = "6539a2ac14afbfd211405e7baef6622e"
    /***Get your own App ID at https://openweathermap.org/appid ****/
    
    let MINUS_KELVIN: Double = 273.15;
    

    //TODO: Declare instance variables here
    let locationMgr = CLLocationManager();
    let weather = WeatherDataModel();

    
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
    func getWeather(params: [String: String]) {
        Alamofire.request(WEATHER_URL, method: .get, parameters: params).responseJSON(completionHandler: {
            response in
            if (response.result.isSuccess) {
                print("Got weather data successfully...");
                
                let weatherJson: JSON = JSON(response.result.value!);
//                print("Got weather data: \(weatherJson)");
                self.setWeather(upData: weatherJson);
            } else {
                print("Can not get weather: \(response.result.error)");
                self.cityLabel.text = "Connection Issues";
            }
        })
    }
    
    //MARK: - JSON Parsing
    /***************************************************************/
   
    
    //Write the updateWeatherData method here:
    func setWeather(upData: JSON) {
        if let temp = upData["main"]["temp"].double {
            weather.temperatureInCelsius = Int(temp - MINUS_KELVIN);
            weather.city = upData["name"].stringValue;
            weather.condition = upData["weather"][0]["id"].intValue;
            weather.weatherIconName = weather.updateWeatherIcon(condition: weather.condition)
            
            updateViewWithWeather();
        } else {
            cityLabel.text = "Weather Unavailable";
        }
        
    }
    
    //MARK: - UI Updates
    /***************************************************************/
    
    
    //Write the updateUIWithWeatherData method here:
    func updateViewWithWeather() {
        self.cityLabel.text = weather.city;
        self.temperatureLabel.text = "\(weather.temperatureInCelsius)℃";
        self.weatherIcon.image = UIImage(named: weather.weatherIconName);
    }
    
    
    //MARK: - Location Manager Delegate Methods
    /***************************************************************/
    
    
    //Write the didUpdateLocations method here:
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // last location is the most accurate
        let lastLoc = locations[locations.count - 1];
        
        //check valid location
        if (lastLoc.horizontalAccuracy > 0) {
            locationMgr.stopUpdatingLocation();
            //stop needs time, so set it null for making stop now
            locationMgr.delegate = nil;
            
            let latitude = String(lastLoc.coordinate.latitude);
            let longitude = String(lastLoc.coordinate.longitude);
            print("Got current (last) location with la '\(latitude)' and lo '\(longitude)'");
            
            let latLong: [String: String] = ["lat": latitude, "lon": longitude, "appid": APP_KEY];
            
            getWeather(params: latLong);
            
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
    func enteredCity(city: String) {
        print("Entered city: \(city)");
        let params: [String: String] = ["q": city, "appid": APP_KEY]
        
        getWeather(params: params);
    }
    
    //Write the PrepareForSegue Method here
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "changeCityName") {
            let changeCity = segue.destination as! ChangeCityViewController;
            changeCity.delegate = self;
        }
    }
    
    
}


