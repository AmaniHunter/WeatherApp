//
//  WeatherLocation.swift
//  WeatherApp
//
//  Created by Amani Hunter on 10/26/19.
//  Copyright © 2019 Amani Hunter. All rights reserved.
//

import Foundation

struct WeatherLocation: Equatable, Codable {
    var city: String!
    var country: String!
    var countryCode: String!
    var isCurrentLocation: Bool!
}


