//
//  WeatherData.swift
//  OpenMindWeather
//
//  Created by Holland Clarke on 3/4/19.
//  Copyright © 2019 Holland Clarke. All rights reserved.
//

import Foundation

struct WeatherData {
    
    let apiBaseURL = "\(basePath)"
    let weatherDataURL: URL?

    init(latitude: Double, longitude: Double) {
        self.weatherDataURL = URL(string: "\(apiBaseURL)/\(latitude),\(longitude)")!
    }
    
    // Get data from url
    func getCurrentWeatherData(completion: @escaping (CurrentWeather?)-> Void) {
        
        if let weatherDataURL = self.weatherDataURL {
            let networkProcessor = NetworkProcessor(url: weatherDataURL)
            networkProcessor.downloadJSONFromURL { (jsonDictionary) in
                if let currentWeatherDictionary = jsonDictionary?["currently"] as? [String : Any] {
                    do {
                        let currentWeather = try? CurrentWeather(json: currentWeatherDictionary)
                        completion(currentWeather)
                    }
                }
            }
        }
    }
    
    func getDailyWeatherData(completion: @escaping ([DailyWeather]?)-> Void){
        
        var weeklyForecast = [DailyWeather]()
        if let weatherDataURL = self.weatherDataURL {
            let networkProcessor = NetworkProcessor(url: weatherDataURL)
            networkProcessor.downloadJSONFromURL { (jsonDictionary) in
                if let dailyWeatherDictionary = jsonDictionary?["daily"] as? [String : Any] {
                    if let dailyWeatherArray = dailyWeatherDictionary["data"] as? [[String : Any]]{
                        do {
                            for item in dailyWeatherArray {
                                if let dailyWeatherItem = try? DailyWeather(json: item) {
                                    weeklyForecast.append(dailyWeatherItem)
                                }
                                
                            }
                            completion(weeklyForecast)
                        }
                    }
                }
            }
        }
    }
}
