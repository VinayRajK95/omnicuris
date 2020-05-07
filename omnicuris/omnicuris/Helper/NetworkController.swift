//
//  NetworkController.swift
//  omnicuris
//
//  Created by Vinay Raj K on 06/05/20.
//  Copyright © 2020 Vinay Raj K. All rights reserved.
//

import Foundation

class NetworkController {
    
    fileprivate let api = "http://api.openweathermap.org/data/2.5/weather"
    
    let session = URLSession.shared

    internal func fetchWeatherUpdate(parameters: [String:String], completion: @escaping (CityModel?)  -> ()  ) {
        var urlComponents = URLComponents(string: api)!
        urlComponents.queryItems = parameters.map { (key, value) in
            URLQueryItem(name: key, value: value)
        }
        guard let url = urlComponents.url else { return }
        
        let request = URLRequest(url: url)

        session.dataTask(with: request) { data, response, error in
            
            guard let data = data, response != nil, error == nil else { return }
            do {
                let decoder = JSONDecoder()
                let city = try decoder.decode(CityModel.self, from: data)
                print(city)
                completion(city)
            }
            catch {
                print("Unable to decode")
                completion(nil)
            }
        }.resume()
    }
    
    
}
