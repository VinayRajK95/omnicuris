//
//  CitiesViewController.swift
//  omnicuris
//
//  Created by Vinay Raj K on 06/05/20.
//  Copyright © 2020 Vinay Raj K. All rights reserved.
//

import UIKit

class CitiesViewController: UIViewController {
    
    @IBOutlet weak var citiesTableView: UITableView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var listOfCities = [String]()

    var filteredCities:[String] = []
    
    var searchActive : Bool = false
    
    let networkManager = NetworkController()
    
    var tempUnit: TempType = .celcius
    
    var parameters = ["q":"","units":"","appid":"66c3fd0cb6de2383542585703136321a"]
    
    var delegate : update!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        citiesTableView.delegate = self
        citiesTableView.dataSource = self
        searchBar.delegate = self
        searchBar.showsCancelButton = true
        searchBar.searchTextField.becomeFirstResponder()
    }


}

extension CitiesViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(searchActive) {
            return filteredCities.count
        }
        return listOfCities.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SimpleCell") else { return UITableViewCell() };
        if(searchActive){
            cell.textLabel?.text = filteredCities[indexPath.row]
        } else {
           cell.textLabel?.text = listOfCities[indexPath.row];
        }
        return cell;
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Recently Searched"
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let city = listOfCities[indexPath.row]
        makeApiCall(city: city, section: indexPath.row)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func makeApiCall(city: String, section: Int?) {
        parameters["q"] = city
        parameters["units"] = getTempStringFromEnum()
        if CoreData.checkIfCityExists(cityName: city) {
            self.dismiss(animated: true, completion: {
                self.delegate.updateUI(section: section)
            })
            return
        }
        networkManager.fetchWeatherUpdate(parameters: parameters, completion: saveToCoreData(city: ))
        
    }
    
    func saveToCoreData(city: CityModel?) {
        DispatchQueue.main.async {
            guard let cityDetails = city else { self.error(); return }
            CoreData.saveDetails(details: cityDetails)
            self.dismiss(animated: true, completion: {
                self.delegate.updateUI(section: nil)
            })
        }
    }
    
    func error() {
        let alert = UIAlertController(title: "City not found", message: "Please enter a valid city", preferredStyle: .alert)
        let okButton = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alert.addAction(okButton)
        present(alert, animated: true, completion: nil)
    }
    
    func getTempStringFromEnum() -> String {
        switch tempUnit {
        case .celcius:
            return "metric"
        default:
            return "imperial"
        }
    }

}


extension CitiesViewController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true;
    }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = false;
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.searchTextField.resignFirstResponder()
        searchActive = false;
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
        guard let text = searchBar.searchTextField.text, text.count > 0 else { return }
        makeApiCall(city: text, section: nil)
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if( searchText.count == 0 ) {
            searchActive = false;
        }
        else {
            searchActive = true;
            filteredCities = listOfCities.filter({ (text) -> Bool in
                let city: String = text.lowercased()
                return city.contains(searchText.lowercased())
            })
            if(filteredCities.count == 0 ) {
                citiesTableView.backgroundView = NoResultsView()
            } else {
                citiesTableView.backgroundView = nil
            }
        }
        citiesTableView.reloadData()
    }
}

class NoResultsView: UIView {
    
    let label : UILabel = {
        let innerLabel = UILabel(frame: CGRect.zero)
        innerLabel.translatesAutoresizingMaskIntoConstraints = false
        innerLabel.font = UIFont(descriptor: .preferredFontDescriptor(withTextStyle: .headline), size: CGFloat(50))
        innerLabel.text = " No suggestions found"
        innerLabel.numberOfLines = 0
        return innerLabel
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupConstraints()
    }
    
    func setupConstraints() {
        self.addSubview(label)
        NSLayoutConstraint.activate([label.centerXAnchor.constraint(equalTo: self.centerXAnchor),label.centerYAnchor.constraint(equalTo: self.centerYAnchor),label.leadingAnchor.constraint(greaterThanOrEqualTo: self.leadingAnchor,constant: 16),label.leadingAnchor.constraint(lessThanOrEqualTo: self.trailingAnchor, constant: -16)])
    }
    
    
}


