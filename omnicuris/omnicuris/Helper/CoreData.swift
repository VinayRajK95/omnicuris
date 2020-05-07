//
//  CoreData.swift
//  omnicuris
//
//  Created by Vinay Raj K on 06/05/20.
//  Copyright © 2020 Vinay Raj K. All rights reserved.
//

import Foundation
import UIKit
import CoreData

public struct CoreData {

    static var cities = [City]()
    
    static let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    static var context : NSManagedObjectContext {
        get {
            return appDelegate.persistentContainer.viewContext
        }
    }
        
    static var weatherDetails = [Weather]()
    
    static func fetchCities() -> [String]{
        var citiesArray = [String]()
        let fetchRequest = NSFetchRequest<City>(entityName: "City")
        do {
            cities = try context.fetch(fetchRequest)
            citiesArray = cities.map({ (City) in
                City.name ?? ""
            })
        } catch {
            print("Cannot fetch cities")
        }
        return citiesArray
    }
    


    static func saveDetails(details: CityModel) {
        do{
            if !checkIfCityExists(cityName: details.name) {
                let city = NSEntityDescription.insertNewObject(forEntityName: "City", into: context)
                let weather = NSEntityDescription.insertNewObject(forEntityName: "Weather", into: context)
                city.setValue(details.name, forKey: "name")
                weather.setValue(details.main?.temp, forKey: "temp")
                weather.setValue(details.coord?.lat, forKey: "latitude")
                weather.setValue(details.coord?.lon, forKey: "longitude")
                weather.setValue(details.weather[0]?.description, forKey: "descr")
                weather.setValue(details.weather[0]?.main, forKey: "main")
                city.setValue(weather, forKey: "weather")
                try context.save()
            }
        }
        catch{
            print("Save failed")
        }
    }
    
    static func checkIfCityExists(cityName: String) -> Bool {
        let fetchRequest = NSFetchRequest<City>(entityName: "City")
        fetchRequest.predicate = NSPredicate(format: "name == %@", cityName)
        do {
            let city = try context.fetch(fetchRequest)
            if city.count == 0 {
                return false
            }
            else {
                return true
            }
        } catch {
            print("Cannot fetch cities")
        }
        return false
    }

}
