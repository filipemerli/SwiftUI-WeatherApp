//
//  CityDetailViewModel.swift
//  SimpleWeather
//
//  Created by Filipe Merli on 09/12/21.
//

import Foundation
import SwiftUI
import MapKit
import Combine

final class CityDetailViewModel: ObservableObject {
    
    @Published var dataModel: CityDetailModel
    
    init(city: City) {
        self.dataModel = .init(city: city)
    }
    
}

struct CityDetailModel {
    private let city: City

    init(city: City) {
        self.city = city
    }

    var cityName: String {
        return city.name ?? ""
    }

    var cityCountry: String {
        return city.country ?? ""
    }

    var population: String {
        return String(city.population)
    }

    var sunset: String {
        return String(Date(timeIntervalSince1970: Double(city.sunset)).getCompleteHourString())
    }

    var sunrise: String {
        return String(Date(timeIntervalSince1970: Double(city.sunrise)).getCompleteHourString())
    }

    var timeNow: String {
        return String(Date(timeIntervalSinceNow: city.timezone).getCompleteHourString())
    }

    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D.init(latitude: city.lat, longitude: city.lon)
    }
}
