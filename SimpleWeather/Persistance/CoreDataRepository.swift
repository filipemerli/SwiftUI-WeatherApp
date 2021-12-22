//
//  CoreDataRepository.swift
//  SimpleWeather
//
//  Created by Filipe Merli on 20/12/21.
//

import Foundation
import CoreData
import Combine

class CoreDataRepository<Entity: NSManagedObject> {

    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.context = context
    }

    func fetch(sortDescriptors: [NSSortDescriptor] = [], predicate: NSPredicate? = nil) -> AnyPublisher<[City], Error> {
        Deferred { [context] in
            Future { promise in
                context.perform {
                    let request = City.fetchRequest()
                    request.sortDescriptors = sortDescriptors
                    request.predicate = predicate
                    do {
                        let results = try context.fetch(request)
                        promise(.success(results))
                    } catch {
                        promise(.failure(error))
                    }
                }
            }
        }
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
}
