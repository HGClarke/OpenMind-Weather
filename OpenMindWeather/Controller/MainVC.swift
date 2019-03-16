//
//  WeatherTableViewController.swift
//  OpenMindWeather
//
//  Created by Holland Clarke on 3/4/19.
//  Copyright © 2019 Holland Clarke. All rights reserved.
//

import UIKit
import CoreLocation
import GooglePlaces
import CoreData

class WeatherViewController: UIViewController {

    @IBOutlet var weatherCells: UITableView!
    

    @IBOutlet var cityNamelbl: UILabel!
    @IBOutlet var latitudeLabel: UILabel!
    @IBOutlet var longitudeLbl: UILabel!
    
    var array = [CurrentWeather]()
    let dataManager = DataManager()
    var currentWeatherArr = [CurrentWeather]()
    private var roundButton = UIButton()
    let colors = [Colors.paleBlue, Colors.palePink, Colors.mintGreen, Colors.coolBlack]
    override func viewDidLoad() {
        super.viewDidLoad()
        createFloatingButton()
        setupTableView()
        weatherCells.backgroundColor = Colors.lightGrey
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        roundButton.isHidden = false
        currentWeatherArr = dataManager.getAllWeatherData()
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func updateWeatherForLocation (place : GMSPlace) {
        
        let latitude = place.coordinate.latitude
        let longitude = place.coordinate.longitude
        let weatherData = WeatherData(latitude: latitude, longitude: longitude)
       
        weatherData.getCurrentWeatherData { (currentWeather) in
            guard var weather = currentWeather else { return }
            DispatchQueue.main.async {
                weather.cityName = place.name!
                weather.latitude = latitude
                weather.longitude = longitude
                self.dataManager.addWeatherData(weather: weather)
                self.currentWeatherArr = self.dataManager.getAllWeatherData()
                self.weatherCells.reloadData()
            }
        }
    }
    
    private func setupTableView() {
        weatherCells.dataSource = self
        weatherCells.delegate = self
        weatherCells.rowHeight = 150
        weatherCells.tableFooterView = UIView()
    }
    
    func createFloatingButton() {
        roundButton = UIButton(type: .custom)
        roundButton.translatesAutoresizingMaskIntoConstraints = false
        roundButton.backgroundColor = .white
        
        // Make sure you replace the name of the image:
        roundButton.setImage(UIImage(named:"button"), for: .normal)
        
        // When the button is pressed, bring up the autocomplete controller
        roundButton.addTarget(self, action: #selector(autocompleteClicked), for: UIControl.Event.touchUpInside)
        view.addSubview(roundButton)
        
        // Create constraints for the button
        NSLayoutConstraint.activate([
            self.roundButton.widthAnchor.constraint(equalToConstant: 50),
            self.roundButton.heightAnchor.constraint(equalToConstant: 50),
            self.roundButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -18),
            self.roundButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -18)
            ])
        
        // Make the button round:
        self.roundButton.layer.cornerRadius = 37.5
    }
}

extension WeatherViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return currentWeatherArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! WeatherCell
        cell.setupCell(weatherData: currentWeatherArr[indexPath.row])
        cell.cityNameLabel.text = currentWeatherArr[indexPath.row].cityName
        cell.backgroundColor = colors[indexPath.row % 4]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {

            dataManager.deleteData(at: indexPath.row)
            currentWeatherArr.remove(at: indexPath.row)
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.endUpdates()
        }
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: tableView.frame)
        view.backgroundColor = .clear
        return view
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let coordinates = dataManager.getCoordinates(at: indexPath.row)
        let weatherData = WeatherData(latitude: coordinates.0, longitude: coordinates.1)
        weatherData.getDailyWeatherData { (weeklyForecast) in
            let currentWeather = self.currentWeatherArr[indexPath.row]
            var cityWeather = CityWeatherData()
            cityWeather.currentWeather = currentWeather
            cityWeather.dailyWeather = weeklyForecast
            cityWeather.backgroundColor = self.colors[indexPath.row % 4]
            // Segues passes data main table view to the city weather view controller
            DispatchQueue.main.async {
                self.roundButton.isHidden = true
                self.performSegue(withIdentifier: segueIdentifier, sender: cityWeather)
            }
        }
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    // Prepare to send data to CityWeatherVC
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == segueIdentifier {
            let destinationVC = segue.destination as! CityWeatherViewController
            roundButton.isHidden = true
            destinationVC.cityWeather = sender as? CityWeatherData
        }
    }
    
}
