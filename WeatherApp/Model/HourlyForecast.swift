//
//  HourlyForecast.swift
//  WeatherApp
//
//  Created by Amani Hunter on 10/23/19.
//  Copyright © 2019 Amani Hunter. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class HourlyForecast{
   private var _date: Date!
   private var _temp: Double!
   private var _weatherIcon: String!
    
    var date: Date{
        if _date == nil {
            _date = Date()
        }
        return _date
    }
    
    var temp: Double{
        if _temp == nil{
            _temp = 0.0
        }
        return _temp
    }
    var weatherIcon: String{
        if _weatherIcon == nil{
            _weatherIcon = ""
        }
        return _weatherIcon
    }
    
    init(weatherDictionary: Dictionary<String, AnyObject>) {
        
        let json = JSON(weatherDictionary)
        
        self._temp = getTempBasedOnSettings(celsius: json["temp"].double ?? 0.0)
        self._date = currentDateFromUnix(unixDate: json["ts"].double!)
        self._weatherIcon = json["weather"]["icon"].stringValue
        
    }
    
    
    class func downloadHourlyForecastWeather(location: WeatherLocation, completion: @escaping (_ hourlyForecast: [HourlyForecast]) -> Void) {
        
        
        var HOURLYFORECAST_URL: String!
        
        
        if !location.isCurrentLocation {
            HOURLYFORECAST_URL = String(format: "https://api.weatherbit.io/v2.0/forecast/hourly?city=%@,%@&hours=24&key=58c01582150f4fe08967b05b6ed7c428"
            , location.city, location.countryCode)
        } else {
            HOURLYFORECAST_URL = CURRENTLOCATIONHOURLYFORECAST_URL
        }
        
        
        
        Alamofire.request(HOURLYFORECAST_URL).responseJSON { (response) in
            let result = response.result
            
            var forecastArray: [HourlyForecast] = []
            
            if result.isSuccess{
                
                if let dictionary = result.value as? Dictionary<String, AnyObject> {
                    if let list = dictionary["data"] as? [Dictionary<String, AnyObject>] {
                        
                        for item in list{
                            let forecast = HourlyForecast(weatherDictionary: item)
                            forecastArray.append(forecast)
                        }
                        
                    }
                }
                
                completion(forecastArray)
                
            }else{
                completion(forecastArray)
                print("no forecast data")
            }
        }
        
    }
    
}
