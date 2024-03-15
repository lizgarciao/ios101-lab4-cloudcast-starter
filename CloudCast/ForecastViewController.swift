//
//  ViewController.swift
//  CloudCast
//
//  Created by Mari Batilando on 3/29/23.
//

import UIKit

struct Location {
    let name: String
    let latitude: Double
    let longitude: Double
}

class ForecastViewController: UIViewController {
    
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var windspeedLabel: UILabel!
    @IBOutlet weak var windDirectionLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var forecastImageView: UIImageView!
    
    private var locations = [Location]() // initialize instance of (Array) class with default values, in this case an empty array of 'Location' objects.
    private var selectedLocationIndex = 0 // keep track of current selected location
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addGradient()
        let sanJose = Location(name: "San Jose", latitude: 37.335480, longitude: -121.893028)
        let dominicanRepublic = Location(name: "Dominican Republic", latitude: 18.7357, longitude: 70.1627)
        let italy = Location(name: "Italy", latitude: 41.8719, longitude: 12.5674)
        locations = [sanJose, dominicanRepublic, italy]
        
        changeLocation(withLocationIndex: 0) // show first location when view loads
    }
    
    private func changeLocation(withLocationIndex locationIndex: Int) {
        guard locationIndex < locations.count else { return } // check to prevent index out of bounds
        let location = locations[locationIndex]
        locationLabel.text = location.name // update location title in UI
        
        // 'forecast in' is a closure that captures the 'forecast' data returned by the 'festForecast' function.
        // The 'in' keyword separates the closure parameter 'forecast' and the closure body which accesses and uses the parameter 'forecast'.
        WeatherForecastService.fetchForecast(latitude: location.latitude, longitude: location.longitude) { forecast in
            self.configure(with: forecast)
        }
    }
    
    private func configure(with forecast: CurrentWeatherForecast) {
        forecastImageView.image = forecast.weatherCode.image
        descriptionLabel.text = forecast.weatherCode.description
        temperatureLabel.text = "\(forecast.temperature)"
        windspeedLabel.text = "\(forecast.windSpeed) mph"
        windDirectionLabel.text = "\(forecast.windDirection)°"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM d, yyyy"
        dateLabel.text = dateFormatter.string(from: Date())
    }
    
    private func addGradient() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [UIColor(red: 0.54, green: 0.88, blue: 0.99, alpha: 1.00).cgColor,
                                UIColor(red: 0.51, green: 0.81, blue: 0.97, alpha: 1.00).cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    @IBAction func didTapBackButton(_ sender: UIButton) {
        selectedLocationIndex = max(0, selectedLocationIndex - 1) // index must be >= 0
        changeLocation(withLocationIndex: selectedLocationIndex)
        
    }
    
    @IBAction func didTapForwardButton(_ sender: UIButton) {
        selectedLocationIndex = min(locations.count - 1, selectedLocationIndex + 1) // index must be <= locations.count - 1
        changeLocation(withLocationIndex: selectedLocationIndex)
    }
}

