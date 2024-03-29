//
//  WeatherViewController.swift
//  WeatherApp
//
//  Created by Amani Hunter on 10/23/19.
//  Copyright © 2019 Amani Hunter. All rights reserved.
//

import UIKit
import CoreLocation


class WeatherViewController: UIViewController {
    //MARK: IBOutlets
    @IBOutlet weak var weatherScrollView: UIScrollView!
    
    
    @IBOutlet weak var pageControl: UIPageControl!
    
    
    
    //MARK: Vars
    let userDefaults = UserDefaults.standard
    var locationManager: CLLocationManager?
    var currentLocation: CLLocationCoordinate2D!
    
    var allLocations: [WeatherLocation] = []
    var allWeatherViews: [WeatherView] = []
    var allWeatherData: [CityTempData] = []
    
    var shouldRefresh = true
    
    
    
    //MARK: ViewLifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManagerStart()
        weatherScrollView.delegate = self
        

        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
       
        
        if shouldRefresh{
            allLocations = []
            allWeatherViews = []
            removeViewsFromScrollView()
            locationAuthCheck()
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        locationManagerStop()
    }

    // MARK: Download Weather
    
    private func getWeather() {
        loadLocationsFromUserDefaults()
        createWeatherViews()
        addWeatherToScrollView()
        setPageControllPageNumber()
        print("We have \(weatherScrollView.subviews.count)")
        
    }
    
    private func removeViewsFromScrollView() {
        for view in weatherScrollView.subviews{
            view.removeFromSuperview()
        }
    }
    private func createWeatherViews() {
        for _ in allLocations {
            allWeatherViews.append(WeatherView())
        }
        
    }
    
    private func addWeatherToScrollView() {

        for i in 0..<allWeatherViews.count{
            
            let weatherView = allWeatherViews[i]
            let location = allLocations[i]
            
            getCurrentWeather(weatherView: weatherView, location: location)
            getWeeklyWeather(weatherView: weatherView, location: location)
            getHourlyWeather(weatherView: weatherView, location: location)
            
            let xPos = self.view.frame.width * CGFloat(i)
            weatherView.frame = CGRect(x: xPos, y: 0, width: weatherScrollView.bounds.width, height: weatherScrollView.bounds.height)
            
            weatherScrollView.addSubview(weatherView)
            weatherScrollView.contentSize.width = weatherView.frame.width * CGFloat(i + 1)
        }
    }
    
    
    private func getCurrentWeather(weatherView: WeatherView, location: WeatherLocation) {
        weatherView.currentWeather = CurrentWeather()
        weatherView.currentWeather.getCurrentWeather(location: location){ (success) in
            
            weatherView.refreshData()
            self.generateWeatherList()
            
        }
    }
    private func getWeeklyWeather(weatherView: WeatherView, location: WeatherLocation) {
        
        WeeklyWeatherForecast.downloadWeeklyWeatherForecast(location: location) { (weatherForecasts) in
            weatherView.weeklyWeatherForecastData = weatherForecasts
            weatherView.tableView.reloadData()
        }
        
    }
    private func getHourlyWeather(weatherView: WeatherView, location: WeatherLocation) {
        HourlyForecast.downloadHourlyForecastWeather(location: location){ (weatherForecasts) in
            weatherView.dailyWeatherForecastData = weatherForecasts
            weatherView.hourlyCollectionView.reloadData()
            
        }
        
    }
    //MARK: LoadLocations from User Defaults
    private func loadLocationsFromUserDefaults(){
        
        let currentLocation = WeatherLocation(city: "", country: "", countryCode: "", isCurrentLocation: true)
        
        if let data = UserDefaults.standard.object(forKey: "Locations") as? Data {
            allLocations = try! PropertyListDecoder().decode(Array<WeatherLocation>.self, from: data)
            
            allLocations.insert(currentLocation, at: 0)
           
        }else{
            print("No user data in user defaults")
            
            allLocations.append(currentLocation)
        }
        
    }
    
    //MARK: PageControll
    private func setPageControllPageNumber() {
        pageControl.numberOfPages = allWeatherViews.count
    }
    private func updatePageControlSelectedPage(currentPage: Int) {
        pageControl.currentPage = currentPage
    }
    
    //MARK: Location Manager
    
    private func locationManagerStart() {
        
        if locationManager == nil {
            locationManager = CLLocationManager()
            locationManager!.desiredAccuracy = kCLLocationAccuracyBest
            locationManager!.requestWhenInUseAuthorization()
            locationManager!.delegate = self
        }
        locationManager!.startMonitoringSignificantLocationChanges()
        
    }
    
    private func locationManagerStop() {
        if locationManager != nil {
            locationManager!.stopMonitoringSignificantLocationChanges()
        }
    }
    
    
    private func locationAuthCheck() {
    
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            
            currentLocation = locationManager!.location?.coordinate
            
            if currentLocation != nil {
                LocationService.shared.latitude = currentLocation.latitude
                LocationService.shared.longitude = currentLocation.longitude
                
                getWeather()
            }else{
                locationAuthCheck()
            }
               }else{
            locationManager?.requestWhenInUseAuthorization()
            locationAuthCheck()
            
        }
    }
    
    private func generateWeatherList() {
        allWeatherData = []
        
        for weatherView in allWeatherViews {
            allWeatherData.append(CityTempData(city:
                weatherView.currentWeather.city, temp:
                weatherView.currentWeather.currentTemp))
            
        }
        
    }
    //MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "allLocationSeg" {
            let vc = segue.destination as! AllLocationsTableViewController
            vc.weatherData = allWeatherData
            vc.delegate = self
        }
    }

}
extension WeatherViewController: AllLocationsTableViewControllerDelegate{
    func didChooseLocation(atIndex: Int, shouldRefresh: Bool) {
        let viewNumber = CGFloat(integerLiteral: atIndex)
        let newOffset = CGPoint(x: (weatherScrollView.frame.width + 1.0) * viewNumber, y: 0)
        
        weatherScrollView.setContentOffset(newOffset, animated: true)
        updatePageControlSelectedPage(currentPage: atIndex)
        
        self.shouldRefresh = shouldRefresh
    }
    
    
}

extension WeatherViewController: CLLocationManagerDelegate{
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to get location,\(error.localizedDescription)")
    }
    
}

extension WeatherViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print("test")
        let value = scrollView.contentOffset.x / scrollView.frame.size.width
        
        updatePageControlSelectedPage(currentPage: Int(round(value)))
    }
}
