//
//  Weather.swift
//  OpenMindWeather
//
//  Created by Holland Clarke on 3/4/19.
//  Copyright © 2019 Holland Clarke. All rights reserved.
//

import Foundation

public enum SerializationError: Error {
    case missing(String)
}

struct CurrentWeather {
    
    var temperature : Double?
    var weatherIcon : String?
    var currentTime : Double?
    var cityName    : String?
    var summary     : String?
    var latitude    : Double?
    var longitude   : Double?
    
    // Keys from the weather api
    struct CurrentWeatherKeys {
        static let icon         = "icon"
        static let cityTime     = "time"
        static let temperature  = "temperature"
        static let summary      = "summary"
        static let latitude     = "latitude"
        static let longitude    = "longitude"
    }
    
    init(json: [String: Any]) throws {
        
        // Throw errors if these sets of data were not received from the api
        guard let weatherIcon = json[CurrentWeatherKeys.icon] as? String else { throw SerializationError.missing("No Icon was found")}
        guard let cityTime = json[CurrentWeatherKeys.cityTime] as? Double else { throw SerializationError.missing("Time was no found")}
        guard let temperature = json[CurrentWeatherKeys.temperature] as? Double else { throw SerializationError.missing("No Temperature was found")}
        guard let summary = json[CurrentWeatherKeys.summary] as? String else {throw SerializationError.missing("No summary was found")}
        self.currentTime = cityTime
        self.temperature = temperature
        self.weatherIcon = weatherIcon
        self.summary = summary
    }
    
    public init() {}
    
}
