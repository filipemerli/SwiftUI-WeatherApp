//
//  SearchHistoryViewModel.swift
//  SimpleWeather
//
//  Created by Felipe Merli on 19/12/21.
//

import Foundation
import SwiftUI
import Combine

final class SearchHistoryViewModel: ObservableObject {

    @Published var citiesEntity: [City]?
//    @Published var citiesEntity: CoreDataRepository<City>?
//    @Published var dataSource: [City]?
    private let context = CoreDataController.shared.container.viewContext
//    private var disposables = Set<AnyCancellable>()
    
    init() {
        loadFromCoreData()
    }

    func loadFromCoreData() {
//        citiesEntity?
//            .fetch()
//            .map { $0 }
//            .receive(on: DispatchQueue.main)
//            .sink(receiveCompletion: { [weak self] value in
//                guard let self = self else { return }
//                switch value {
//                case .failure:
//                    self.citiesEntity = nil
//                case .finished:
//                    break
//                }
//            }, receiveValue: { [weak self] cities in
//                guard let self = self else { return }
//                self.dataSource = cities
//            })
//            .store(in: &disposables)
        do {
            citiesEntity = try context.fetch(City.fetchRequest())
        } catch {
            fatalError()
        }
    }

    
}

//struct SearchHistoryRowViewModel {
//    private let city: City
//
//    init(city: City) {
//        self.city = city
//    }
//
//    var name: String {
//        return city.name ?? "Unknown"
//    }
//}
