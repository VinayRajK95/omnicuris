//
//  ViewController.swift
//  omnicuris
//
//  Created by Vinay Raj K on 06/05/20.
//  Copyright © 2020 Vinay Raj K. All rights reserved.
//

import UIKit

class ViewController: UIViewController, update {

    @IBOutlet weak var weatherTableView: UITableView!
    
    fileprivate var expandedSections = [Int]()
    
    fileprivate var celcius = [Int:Bool]()
    
    fileprivate var cities: [City]?
    
    fileprivate var cityArray = [String]()
    
    fileprivate var headerViews = [SectionHeaderFooterView]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let _ = CoreData.fetchCities()
        cities = CoreData.cities
        weatherTableView.delegate = self
        weatherTableView.dataSource = self
        weatherTableView.register(SectionHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: "SectionHeader")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Cities" {
            guard let vc = (segue.destination as? CitiesViewController), let cts = cities else { return }
            vc.listOfCities = cts.map({ (City) in
                return City.name ?? ""
            })
            vc.delegate = self
        }
    }
    
    internal func updateUI(section: Int?) {
        cityArray = CoreData.fetchCities()
        cities = CoreData.cities
        if let sect = section {
            let view = headerViews[sect]
            view.section = sect
            view.handleToggle()
        }
        weatherTableView.reloadData()
    }

}

extension ViewController: UITableViewDataSource, UITableViewDelegate, Expandabledelegate  {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return cities?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if expandedSections.contains(section){
            return 2
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "SimpleCell") else { return UITableViewCell() };
            return cell
        }
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherDetails") as? WeatherTableViewCell, let city = cities else { return UITableViewCell() }
        let details = city[indexPath.section]
        cell.configureCell(details: details)
        return cell;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 0
        }
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "SectionHeader") as? SectionHeaderFooterView else {
            return UITableViewHeaderFooterView()
        }
        let expanded = expandedSections.contains(section)
        header.button.isSelected = expanded
        header.delegate = self
        header.section = section
        let data = cities?[section]
        header.cityLabel.text = data?.name ?? ""
        header.temparature = "\(data?.weather?.temp ?? 0)"
        celcius[section] = celcius[section] ?? true
        header.isCelcius = celcius[section]!
        headerViews.append(header)
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    
    internal func toggleSection(cell: UITableViewHeaderFooterView, section: Int, isCelcius: Bool) {
        let shouldExpand = expandedSections.contains(section)
        if !shouldExpand {
            expandedSections.append(section)
        }
        else {
            guard let index = expandedSections.firstIndex(of: section) else { return }
            expandedSections.remove(at: index)
        }
        celcius[section] = isCelcius
        reloadSection(section: section)
    }
    
    func updateCelcius(section: Int, isCelcius: Bool) {
        celcius[section] = isCelcius
    }
    
    fileprivate func reloadSection(section: Int) {
        weatherTableView.beginUpdates()
        weatherTableView.reloadSections(IndexSet(integer: section), with: .automatic)
        weatherTableView.endUpdates()
    }

}

protocol update {
    func updateUI(section: Int?)
}


