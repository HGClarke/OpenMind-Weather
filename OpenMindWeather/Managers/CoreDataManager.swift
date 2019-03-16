//
//  CoreDataManager.swift
//  OpenMindWeather
//
//  Created by Holland Clarke on 3/8/19.
//  Copyright © 2019 Holland Clarke. All rights reserved.
//

import UIKit
import CoreData

class DataManager {
    
    // Add weather data to CoreData
    func addWeatherData(weather: CurrentWeather) {
        
        // Set up and allow insertion into core data
        let context = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: entityName, in: context)
        let newData = NSManagedObject(entity: entity!, insertInto: context)
        
        // Set the valeus of the different variables inside the CoreData Database
        newData.setValue(weather.weatherIcon, forKey: CurrentWeather.CurrentWeatherKeys.icon)
        newData.setValue(Int(weather.temperature!.rounded()), forKey: CurrentWeather.CurrentWeatherKeys.temperature)
        newData.setValue(weather.cityName, forKey: "cityName")
        newData.setValue(weather.summary, forKey: CurrentWeather.CurrentWeatherKeys.summary)
        newData.setValue(weather.latitude, forKey: CurrentWeather.CurrentWeatherKeys.latitude)
        newData.setValue(weather.longitude, forKey: CurrentWeather.CurrentWeatherKeys.longitude)
        newData.setValue(weather.currentTime, forKey: CurrentWeather.CurrentWeatherKeys.cityTime)

        
        // Save data
        appDelegate.saveContext()
    }
    
    // Return all data found within Core Data
    func getAllWeatherData() -> [CurrentWeather] {
        
        // Create a new object
        var weather = CurrentWeather()
        
        let context = appDelegate.persistentContainer.viewContext
        
        // Creste a fetch request
        let fetchRequest = NSFetchRequest<CurrentWeatherModel>(entityName: entityName)
        
        // Array we will return with all the data
        var array = [CurrentWeather]()
        do {
            // If the fetch is successful set the varibales and then append them to the array
            let results = try context.fetch(fetchRequest)
            for result in results {
                weather.latitude = result.latitude
                weather.longitude = result.longitude
                weather.cityName = result.cityName
                weather.weatherIcon = result.icon
                weather.temperature = result.temperature
                weather.summary = result.summary
                weather.currentTime = result.time
                array.append(weather)
                
            }
        } catch let error as NSError {
            print("Error: ", error.debugDescription)
        }
        return array
    }
    
    func getCoordinates(at index: Int) -> (Double, Double) {
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<CurrentWeatherModel>(entityName: entityName)
        
        do {
            let results = try context.fetch(request)
            if results.indices.contains(index) {
                let latitude = results[index].latitude
                let longitude = results[index].longitude
                return (latitude, longitude)
            }
        } catch let error as NSError {
            print("Error: ", error.debugDescription)
        }
        return (0,0)
    }
    // Deleting data from Core Data
    func deleteData(at index: Int) {
        
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<CurrentWeatherModel>(entityName: entityName)
        
        do {
            let results = try context.fetch(request)
            // If the index is valid and found in the results aray then delete the item
            if results.indices.contains(index) {
                let item = results[index]
                context.delete(item)
                appDelegate.saveContext()
            }
        } catch let error as NSError {
            print("Error: ", error.debugDescription)
        }
    }
}
