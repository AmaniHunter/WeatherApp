//
//  MainWeatherTableViewCell.swift
//  WeatherApp
//
//  Created by Amani Hunter on 10/31/19.
//  Copyright © 2019 Amani Hunter. All rights reserved.
//

import UIKit

class MainWeatherTableViewCell: UITableViewCell {
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func generateCell(weatherData: CityTempData) {
        
        cityLabel.text = weatherData.city
        cityLabel.adjustsFontSizeToFitWidth = true
        tempLabel.text = String(format: "%.0f %@", weatherData.temp, returnTempFormatFromUserDefaults())
        //TODO: Make temp format dynamic
        
    }

}
