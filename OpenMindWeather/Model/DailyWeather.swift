//
//  DailyWeather.swift
//  OpenMindWeather
//
//  Created by Holland Clarke on 3/4/19.
//  Copyright © 2019 Holland Clarke. All rights reserved.
//

import Foundation

struct DailyWeather {
    
    var weatherIcon : String?
    var temperatureMax: Double?
    var temperatureMin: Double?    
    var time: Int?
    struct DailyWeatherKeys {
        static let temperatureMax = "temperatureMax"
        static let temperatureMin = "temperatureMin"
        static let icon = "icon"
        static let time = "time"
    }
    
    init(json: [String: Any]) throws {
        
        guard let temperatureMax = json[DailyWeatherKeys.temperatureMax] as? Double else { throw SerializationError.missing("Did not find temperature max")}
        
        guard let temperatureMin = json[DailyWeatherKeys.temperatureMin] as? Double else { throw     SerializationError.missing("Did not find temperature min")}
        
        guard let weatherIcon = json[DailyWeatherKeys.icon] as? String else { throw SerializationError.missing("Did not find an icon")}
        
        guard let time = json[DailyWeatherKeys.time] as? Int else { throw SerializationError.missing("Did not find the time")}
        
        self.time = time
        self.weatherIcon = weatherIcon
        self.temperatureMax = temperatureMax
        self.temperatureMin = temperatureMin
    }
    
}
