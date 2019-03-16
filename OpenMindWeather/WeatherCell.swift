//
//  WeatherCell.swift
//  OpenMindWeather
//
//  Created by Holland Clarke on 3/4/19.
//  Copyright © 2019 Holland Clarke. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherCell: UITableViewCell {
    
    @IBOutlet var cityNameLabel: UILabel!
    @IBOutlet var weatherIcon: UIImageView!
    @IBOutlet var temperatureLbl: UILabel!
    @IBOutlet var timeLbl: UILabel!
    
    func setupCell(weatherData: CurrentWeather) {
        
        // Set outlets based on the data in weather data
        if let iconName = weatherData.weatherIcon {
            weatherIcon.image = UIImage(named: iconName)
        } else {
            weatherIcon = UIImageView()
        }
        
        if let temperature = weatherData.temperature {
            temperatureLbl.text = String(temperature.rounded()) + " ºF"
        } else {
            temperatureLbl.text = "-"
        }
        if let cityName = weatherData.cityName {
            cityNameLabel.text = cityName
        } else {
            cityNameLabel.text = "-"
        }
        
        if let latitude = weatherData.latitude, let longitude = weatherData.longitude {
            let location = CLLocation(latitude: latitude, longitude: longitude)
            let geocoder = CLGeocoder()
            geocoder.reverseGeocodeLocation(location) { (placemark, error) in
                guard error == nil else {
                    print("Error: ", error.debugDescription)
                    return
                }
                guard let place = placemark?.first else {
                    self.timeLbl.text = "00:00"
                    return
                }
                guard let timeZone = place.timeZone else {
                    self.timeLbl.text = "00:00"
                    return
                }
                if let time = weatherData.currentTime {
                    let date = Date(timeIntervalSince1970: time)
                    let formatter = DateFormatter()
                    formatter.dateFormat = "HH:mm"
                    formatter.timeZone = timeZone
                    self.timeLbl.text = formatter.string(from: date)
                } else {
                    self.timeLbl.text = "00:00"
                }
            }
        }
    }
}
