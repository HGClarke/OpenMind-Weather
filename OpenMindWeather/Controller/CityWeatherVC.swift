//
//  CityWeatherViewController.swift
//  OpenMindWeather
//
//  Created by Holland Clarke on 3/7/19.
//  Copyright © 2019 Holland Clarke. All rights reserved.
//

import UIKit

class CityWeatherViewController: UIViewController {

    @IBOutlet var cityNameLabel: UILabel!
    @IBOutlet var currentWeatherIcon: UIImageView!
    @IBOutlet var weatherSummaryLbl: UILabel!
    @IBOutlet var temperatureLbl: UILabel!
    @IBOutlet var forecastCollectionView: UICollectionView!
    
    @IBOutlet var contentView: UIView!
    var cityWeather : CityWeatherData?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupUI()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        forecastCollectionView.delegate = self
        forecastCollectionView.dataSource = self
        forecastCollectionView.backgroundColor = cityWeather?.backgroundColor
        
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        forecastCollectionView.collectionViewLayout.invalidateLayout()
    }
    
    func setupUI() {
        view.backgroundColor = cityWeather?.backgroundColor
        contentView.backgroundColor = cityWeather?.backgroundColor
        if let cityName = cityWeather?.currentWeather?.cityName {
            cityNameLabel.text = cityName
        } else {
            cityNameLabel.text = "---"
        }
        
        if let iconName = cityWeather?.currentWeather?.weatherIcon {
            currentWeatherIcon.image = UIImage(named: iconName)
        }
        
        if let summary = cityWeather?.currentWeather?.summary {
            weatherSummaryLbl.text = summary
        } else {
            weatherSummaryLbl.text = "---"
        }
        
        if let temperature = cityWeather?.currentWeather?.temperature {
            temperatureLbl.text = "\(Int(temperature.rounded())) ºF"
        }
 
    }
    
}

extension CityWeatherViewController: UICollectionViewDelegate, UICollectionViewDataSource {

    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let count = cityWeather?.dailyWeather?.count else { return 0 }
        return count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "dailyCell", for: indexPath) as! DailyCollectionViewCell

        
        
        if let weather = cityWeather?.dailyWeather {
            let dayItem = weather[indexPath.row]
            if let temperatureMax = dayItem.temperatureMax?.rounded() {
                cell.temperatureMax.text = String(Int(temperatureMax))
            }
            
            if let temperatureMin = dayItem.temperatureMin?.rounded() {
                cell.temperatureMin.text = String(Int(temperatureMin))
            }
            cell.weatherIcon.image = UIImage(named: dayItem.weatherIcon ?? "")
            if let time = dayItem.time {
                let date = Date(timeIntervalSince1970: Double(time))
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "E"
                cell.dayLbl.text = dateFormatter.string(from: date)
                
            }
        }
        
        return cell
    }
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
}
