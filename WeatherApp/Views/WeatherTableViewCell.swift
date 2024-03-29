//
//  WeatherTableViewCell.swift
//  WeatherApp
//
//  Created by Amani Hunter on 10/25/19.
//  Copyright © 2019 Amani Hunter. All rights reserved.
//

import UIKit

class WeatherTableViewCell: UITableViewCell {
    //MARK: IBOutlets
    @IBOutlet weak var dayOfTheWeekLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var weatherIconImageView: UIImageView!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func generateCell(forecast: WeeklyWeatherForecast) {
        
        dayOfTheWeekLabel.text = forecast.date.dayOfTheWeek()
        weatherIconImageView.image = getWeatherIconFor(forecast.weatherIcon)
        tempLabel.text = String(format: "%.0f %@", forecast.temp, returnTempFormatFromUserDefaults())
        
    }
    
    
}
