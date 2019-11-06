//
//  ChooseCityViewController.swift
//  WeatherApp
//
//  Created by Amani Hunter on 10/26/19.
//  Copyright © 2019 Amani Hunter. All rights reserved.
//

import UIKit


protocol ChooseCityViewControllerDelegate {
    func didAdd (newLocation: WeatherLocation)
}

class ChooseCityViewController: UIViewController {
    
    //MARK: IBOutlets
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: Vars:
    var allLocations:[WeatherLocation] = []
    var filteredLocations: [WeatherLocation] = []
    
    let searchController = UISearchController(searchResultsController: nil)
    
    let userDefaults = UserDefaults.standard
    
    var savedLocations: [WeatherLocation]?
    var delegate: ChooseCityViewControllerDelegate?
    
    
    //MARK: View life cycle
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        loadfromUserDefaults()
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView()
        
        setupSearchController()
        tableView.tableHeaderView = searchController.searchBar
        setupTapGesture()
        loadLocationsFromCSV()
        
        }
    
    private func setupSearchController() {
        searchController.searchBar.placeholder = "City or Country"
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        
        searchController.searchBar.searchBarStyle = UISearchBar.Style.prominent
        searchController.searchBar.sizeToFit()
        searchController.searchBar.backgroundImage = UIImage()
    }
    
    private func setupTapGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(tableTapped))
        self.tableView.backgroundView = UIView()
        
        self.tableView.backgroundView?.addGestureRecognizer(tap)
        
    }
    
    @objc func tableTapped() {
        dismissView()
    }
    
    //MARK: Get Locations
    
    private func loadLocationsFromCSV() {
        if let path = Bundle.main.path(forResource: "location", ofType: "csv"){
            parseCSVAt(url: URL(fileURLWithPath: path))
        }
        
        
    }
    
    private func parseCSVAt(url: URL){
        
        do{
            let data = try Data(contentsOf: url)
            let dataEncoded = String(data: data, encoding: .utf8)
            
           if let dataArr = dataEncoded?.components(separatedBy: "\n").map({ $0.components(separatedBy: ",")}) {
                
            var i = 0
            
            for line in dataArr{
                if line.count > 2 && i != 0 {
                    createLocation(line: line)
                }
                i += 1
            }
                
            }
        }catch{
            print("error reading CSV file," ,error.localizedDescription)
        }
        
    }
    private func createLocation(line: [String]) {
        allLocations.append(WeatherLocation(city: line.first!, country: line[1], countryCode: line.last, isCurrentLocation: false))
        
        print(allLocations.count)
        
    }
    //MARK: UserDefaults
    
    private func saveToUserDefaults(location: WeatherLocation) {
        
        if savedLocations != nil {
            if !savedLocations!.contains(location) {
                savedLocations!.append(location)
                }
        }else{
            savedLocations = [location]
        }
        userDefaults.set(try? PropertyListEncoder().encode(savedLocations!), forKey: "Locations")
        userDefaults.synchronize()
    }

    private func loadfromUserDefaults() {
        
        if let data = userDefaults.value(forKey: "Locations") as? Data{
            savedLocations = try? PropertyListDecoder().decode(Array<WeatherLocation>.self, from: data)
            
            print(savedLocations?.first?.city)
        }
        
    }
    private func dismissView() {
        if searchController.isActive{
            searchController.dismiss(animated: true){
                self.dismiss(animated: true)
            }
            
        }else{
            self.dismiss(animated: true)
            }
        
    }
    
    
}
extension ChooseCityViewController: UISearchResultsUpdating{
    func filterContentForSearchText(searchText: String, scope: String = "ALL") {
        filteredLocations = allLocations.filter({ (location) -> Bool in
            return location.city.lowercased().contains(searchText.lowercased()) || location.country.lowercased().contains(searchText.lowercased())
        })
        tableView.reloadData()
        
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchText: searchController.searchBar.text!)
    }
    
    
}


extension ChooseCityViewController: UITableViewDelegate, UITableViewDataSource {
     
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredLocations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let location = filteredLocations[indexPath.row]
        cell.textLabel?.text = location.city
        cell.detailTextLabel?.text = location.country
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Save location
        tableView.deselectRow(at: indexPath, animated: true)
        
        saveToUserDefaults(location: filteredLocations[indexPath.row])
        
        delegate?.didAdd(newLocation: filteredLocations[indexPath.row])
        delegate?.didAdd(newLocation: filteredLocations[indexPath.row])
        
        dismissView()
        
        }
    }
    

