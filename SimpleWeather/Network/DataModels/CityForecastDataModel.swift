//
//  CityForecastDataModel.swift
//  ForecastApp
//
//  Created by Filipe Merli on 04/12/21.
//

import Foundation

struct CityForecastResponse: Codable {
    let city: CityInfoDataModdel?
    let list: [DailyForecast]?
}

struct CityInfoDataModdel: Codable {
    let id: Int?
    let name: String?
    let country: String?
    let sunset: Int?
    let sunrise: Int?
    let population: Int?
    let timezone: Double?
    let coord: Coordinates?
}

struct DailyForecast: Codable {
    let dt: Double?
    let main: Temperature?
}

struct Temperature: Codable {
    let temp: Double?
}

struct Coordinates: Codable {
    let lat: Double?
    let lon: Double?
}
