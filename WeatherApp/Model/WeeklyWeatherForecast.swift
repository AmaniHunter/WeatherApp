//
//  WeeklyWeatherForecast.swift
//  WeatherApp
//
//  Created by Amani Hunter on 10/23/19.
//  Copyright © 2019 Amani Hunter. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON


class WeeklyWeatherForecast{
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
    
    class func downloadWeeklyWeatherForecast(location:WeatherLocation, completion: @escaping(_ weatherForecast: [WeeklyWeatherForecast]) ->Void) {
        
        
        var WEEKLYFORECAST_URL: String!
               
               
               if !location.isCurrentLocation {
                   WEEKLYFORECAST_URL = String(format: "https://api.weatherbit.io/v2.0/forecast/daily?city=%@,%@&days=7&key=58c01582150f4fe08967b05b6ed7c428"
                   , location.city, location.countryCode)
               } else {
                   WEEKLYFORECAST_URL = CURRENTLOCATIONWEEKLYFORCAST_URL
               }
        
        
        
        
        Alamofire.request(WEEKLYFORECAST_URL).responseJSON { (response) in
            let result = response.result
            
            var forecastArray: [WeeklyWeatherForecast] = []
            
            if result.isSuccess{
                
                if let dictionary = result.value as? Dictionary<String,AnyObject> {
                    if var list = dictionary["data"] as? [Dictionary<String,AnyObject>]{
                        list.remove(at: 0) //remove current Day
                        
                        for item in list{
                            let forecast = WeeklyWeatherForecast(weatherDictionary: item)
                            forecastArray.append(forecast)
                        }
                    }
                }
                
                completion(forecastArray)
                
            }else{
                completion(forecastArray)
                print("no weekly forecast")
            }
        }
    }
}
