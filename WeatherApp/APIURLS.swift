//
//  APIURLS.swift
//  WeatherApp
//
//  Created by Amani Hunter on 10/26/19.
//  Copyright © 2019 Amani Hunter. All rights reserved.
//

import Foundation

let CURRENTLOCATION_URL = "https://api.weatherbit.io/v2.0/current?&lat=\(LocationService.shared.latitude!)&lon=\(LocationService.shared.longitude!)&key=58c01582150f4fe08967b05b6ed7c428"
let CURRENTLOCATIONWEEKLYFORCAST_URL = "https://api.weatherbit.io/v2.0/forecast/daily?lat=\(LocationService.shared.latitude!)&lon=\(LocationService.shared.longitude!)&days=7&key=58c01582150f4fe08967b05b6ed7c428"
let CURRENTLOCATIONHOURLYFORECAST_URL = "https://api.weatherbit.io/v2.0/forecast/hourly?lat=\(LocationService.shared.latitude!)&lon=\(LocationService.shared.longitude!)&hours=24&key=58c01582150f4fe08967b05b6ed7c428"



