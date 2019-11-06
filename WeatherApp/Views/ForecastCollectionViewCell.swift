//
//  ForecastCollectionViewCell.swift
//  WeatherApp
//
//  Created by Amani Hunter on 10/25/19.
//  Copyright © 2019 Amani Hunter. All rights reserved.
//

import UIKit

class ForecastCollectionViewCell: UICollectionViewCell {
    
    //MARK: IBOutlets
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var weatherIconImageView: UIImageView!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    func generateCell(weather: HourlyForecast){
        
        timeLabel.text = weather.date.time()
        weatherIconImageView.image = getWeatherIconFor(weather.weatherIcon)
        tempLabel.text = String(format: "%.0f%@", weather.temp, returnTempFormatFromUserDefaults())
        
    
        
    }
}

