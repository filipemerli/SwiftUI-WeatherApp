//
//  SimpleWeatherApp.swift
//  SimpleWeather
//
//  Created by Felipe Merli on 08/12/21.
//

import SwiftUI

@main
struct SimpleWeatherApp: App {


    let persistenceController = CoreDataController.shared
    
    var body: some Scene {
        WindowGroup {
            let weatherClient = ForecastAPIClient()
            CityForescastView(viewModel: CityForecastViewModel(weatherClient: weatherClient))
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
