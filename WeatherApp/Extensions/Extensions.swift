//
//  Extensions.swift
//  WeatherApp
//
//  Created by Amani Hunter on 10/24/19.
//  Copyright © 2019 Amani Hunter. All rights reserved.
//

import Foundation

extension Date{
    
    func shortDate() -> String{
    let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d"
        
        return dateFormatter.string(from: self)
    }
    
    func time() -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
            return dateFormatter.string(from: self)
        
    }
    
    func dayOfTheWeek() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
            return dateFormatter.string(from: self)
    }
    
}
