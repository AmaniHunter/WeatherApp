//
//  CurrentWeather.swift
//  WeatherApp
//
//  Created by Amani Hunter on 10/22/19.
//  Copyright © 2019 Amani Hunter. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class CurrentWeather{
    
    private var _city: String!
    private var _date: Date!
    private var _currentTemp: Double!
    private var _feelsLike: Double!
    private var _uv: Double!
    private var _weatherType: String!
    private var _pressure: Double! //mb
    private var _humidity: Double! //%
    private var _windSpeed: Double! // meter/sec
    private var _weatherIcon: String!
    private var _visibility: Double! //KM
    private var _sunrise: String!
    private var _sunset: String!
    
    var city: String{
        if _city == nil{
            _city = ""
        }
        return _city
    }
    var date: Date{
        if _date == nil {
            _date = Date()
        }
        return _date
    }
    var uv: Double{
        if _uv == nil {
            _uv = 0.0
        }
        return _uv
    }
    var sunrise: String{
        if _sunrise == nil {
            _sunrise = ""
        }
        return _sunrise
    }
    var sunset: String{
        if _sunset == nil{
            _sunset = ""
        }
        return _sunset
    }
    var currentTemp: Double{
        if _currentTemp == nil{
            _currentTemp = 0.0
        }
       return _currentTemp
    }
    var feelsLike: Double{
        if _feelsLike == nil{
            _feelsLike = 0.0
        }
        return _feelsLike
    }
    var weatherType: String{
        if _weatherType == nil {
            _weatherType = ""
        }
        return _weatherType
    }
    var pressure: Double{
        if _pressure == nil {
            _pressure = 0.0
        }
        return _pressure
    }
    var humidity: Double{
        if _humidity == nil {
            _humidity = 0.0
        }
        return _humidity
    }
    var windSpeed: Double{
        if _windSpeed == nil {
            _windSpeed = 0.0
        }
        return _windSpeed
    }
    var weatherIcon: String{
        if _weatherIcon == nil {
            _weatherIcon = ""
        }
        return _weatherIcon
    }
    var visibility: Double{
        if _visibility == nil {
            _visibility = 0.0
        }
        return _visibility
    }
    
    func getCurrentWeather(location: WeatherLocation, completion: @escaping(_ success: Bool)->Void){
        var LOCATIONAPI_URL: String!
        
        
        if !location.isCurrentLocation {
            LOCATIONAPI_URL = String(format: "https://api.weatherbit.io/v2.0/current?city=%@,%@&key=58c01582150f4fe08967b05b6ed7c428", location.city, location.countryCode)
        } else {
            LOCATIONAPI_URL = CURRENTLOCATION_URL
        }
        
        Alamofire.request(LOCATIONAPI_URL).responseJSON { (response) in
            let result = response.result
            if result.isSuccess{
                let json = JSON(result.value)
                
                //print(json)
                self._city = json["data"][0]["city_name"].stringValue
                self._date = currentDateFromUnix(unixDate: json["data"][0]["ts"].double)
                self._weatherType = json["data"][0]["weather"]["description"].stringValue
                
                self._currentTemp = getTempBasedOnSettings(celsius: json["data"][0]["temp"].double ?? 0.0)
                self._feelsLike = getTempBasedOnSettings(celsius: json["data"][0]["app_temp"].double ?? 0.0)
                self._pressure = json["data"][0]["pres"].double
                self._humidity = json["data"][0]["rh"].double
                self._windSpeed = json["data"][0]["wind_spd"].double
                self._weatherIcon = json["data"][0]["weather"]["icon"].stringValue
                self._visibility = json["data"][0]["vis"].double
                self._uv = json["data"][0]["uv"].double
                self._sunrise = json["data"][0]["sunrise"].stringValue
                self._sunset = json["data"][0]["sunset"].stringValue
                
               completion(true)
                
            }else {
                self._city = location.city
                completion(false)
                print("No Result found for current location")
            }
        }
    }
}
