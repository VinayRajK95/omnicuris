//
//  City.swift
//  omnicuris
//
//  Created by Vinay Raj K on 06/05/20.
//  Copyright © 2020 Vinay Raj K. All rights reserved.
//

import Foundation

struct CityModel: Decodable {
    let coord: Coord?
    let weather: [WeatherModel?]
    let name: String
    let main: Main?
}

struct Coord: Decodable {
    let lon, lat: Double
}

struct WeatherModel: Decodable {
    let main: String?
    let description: String?
}

struct Main: Decodable {
    let temp: Double?
}

enum TempType {
    case fahrenheit
    case celcius
}
