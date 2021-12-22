//
//  CoreDataController.swift
//  WeatherApp
//
//  Created by Felipe Merli on 08/12/21.
//

import CoreData
import Combine

final class CoreDataController: ObservableObject {

    static let shared = CoreDataController()
    let container = NSPersistentContainer(name: "CityInfo")

    init() {
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Core Data failed to load: \(error.localizedDescription)")
            }
        }
    }

}
