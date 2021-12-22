//
//  CityForecastViewModel.swift
//  ForecastApp
//
//  Created by Filipe Merli on 04/12/21.
//

import Foundation
import Combine
import SwiftUI

final class CityForecastViewModel: ObservableObject {

    private let context = CoreDataController.shared.container.viewContext
    private let weatherClient: ForecastAPIClientProtocol

    @Published var dataSource: ListCity?
    @Published var citySearch: String = ""

    private var bag = Set<AnyCancellable>()

    init(weatherClient: ForecastAPIClientProtocol, scheduler: DispatchQueue = DispatchQueue(label: "CityForecastViewModel")) {
        self.weatherClient = weatherClient
        $citySearch
            .dropFirst(1)
            .debounce(for: .seconds(0.5), scheduler: scheduler)
            .sink(receiveValue: getWeather(city:))
            .store(in: &bag)
    }

    deinit {
        bag.removeAll()
    }

    func storeCity(city: CityForecastViewModel.ListCity) {
        guard let savedCities = getAllStoreaged() else { return }
        guard !(savedCities.map { $0.name }.contains(city.name)) else { return }
        let cityToStore = City(context: context)
        cityToStore.id = UUID()
        cityToStore.country = city.country
        cityToStore.name = city.name
        cityToStore.lat = city.lat
        cityToStore.lon = city.lon
        cityToStore.sunset = Int32(city.sunset)
        cityToStore.sunrise = Int32(city.sunrise)
        cityToStore.population = Int32(city.population)
        try? context.save()
    }

    func getWeather(city: String) {
        weatherClient.getForecastForCity(city: city)
            .map { ListCity.init(model: $0) }
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] value in
                    guard let self = self else { return }
                    switch value {
                    case .failure:
                        self.dataSource = nil
                    case .finished:
                        break
                    }
                },
                receiveValue: { [weak self] forecast in
                    guard let self = self else { return }
                    self.dataSource = forecast
                })
            .store(in: &bag)
    }

    private func getAllStoreaged() -> [City]? {
        do {
            let citiesEntities = try context.fetch(City.fetchRequest())
            return citiesEntities
        } catch {
            return nil
        }
    }
}

extension CityForecastViewModel {

    struct ListCity: Identifiable {
        let city: CityInfoDataModdel?
        let id: Int
        let name: String
        let days: [ForecastDay]
        let country: String
        let lat: Double
        let lon: Double
        let sunset: Int
        let sunrise: Int
        let population: Int
        let timezone: Double
        
        init(model: CityForecastResponse) {
            city = model.city
            id = model.city?.id ?? .zero
            name = model.city?.name ?? ""
            days = CityForecastViewModel.parseForecastDay(model: model)
            country = model.city?.country ?? ""
            lat = model.city?.coord?.lat ?? .zero
            lon = model.city?.coord?.lon ?? .zero
            sunset = model.city?.sunset ?? .zero
            sunrise = model.city?.sunrise ?? .zero
            population = model.city?.population ?? .zero
            timezone = model.city?.timezone ?? .zero
        }
    }

    struct ForecastDay: Identifiable {
        let id: String
        let hours: [String]
        let temps: [String]

        init(id: String, hours: [String], temps: [String]) {
            self.id = id
            self.hours = hours
            self.temps = temps
        }
    }
}

extension CityForecastViewModel {

    private static func parseDays(model: [DailyForecast]) -> [String] {
        return model.map { Date(timeIntervalSince1970: $0.dt ?? 0.0).getDayString() }
    }

    private static func parseHours(model: [DailyForecast]) -> [String] {
        return model.map { Date(timeIntervalSince1970: $0.dt ?? 0.0).getHourString() }
    }

    private static func parseTemps(model: [DailyForecast]) -> [String] {
        return model.map { String($0.main?.temp ?? .zero) }
    }

    private static func parseForecastDay(model: CityForecastResponse) -> [ForecastDay] {
        var result: [ForecastDay] = []
        let modelList = model.list ?? []
        let days: [String] = parseDays(model: modelList)
        let temps: [String] = parseTemps(model: modelList)
        let hours: [String] = parseHours(model: modelList)
        var hoursToAppend: [String] = []
        var tempsToAppend: [String] = []
        var index = 0
        for day in days {
            if days.count > index {
                hoursToAppend.append(hours[index])
                tempsToAppend.append(temps[index])
                let nextIndex = index + 1
                if !(nextIndex < days.count && day == days[nextIndex]) {
                    result.append(ForecastDay(id: day, hours: hoursToAppend, temps: tempsToAppend))
                    hoursToAppend.removeAll()
                    tempsToAppend.removeAll()
                }
            }
            index += 1
        }
        return result
    }
}
