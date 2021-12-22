//
//  CityDetailView.swift
//  SimpleWeather
//
//  Created by Filipe Merli on 09/12/21.
//

import SwiftUI

struct CityDetailView: View {

    private let city: City
    private let viewModel: CityDetailViewModel

    init(city: City) {
        self.city = city
        self.viewModel = CityDetailViewModel(city: city)
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .center) {
                Text("\(viewModel.dataModel.cityName)")
                    .font(.title2)
                
                Text("\(viewModel.dataModel.cityCountry)")
                    .font(.footnote)
            }
            MapView(coordinates: viewModel.dataModel.coordinate)
                .cornerRadius(12)
                .frame(height: 300)
                .disabled(true)
            VStack(alignment: .center) {
                HStack {
                    Text("Time now:")
                    Text(viewModel.dataModel.timeNow)
                        .foregroundColor(.gray)
                }

                HStack {
                    Text("Sunrise:")
                    Text("\(viewModel.dataModel.sunrise)")
                        .foregroundColor(.gray)
                }

                HStack {
                    Text("Sunset:")
                    Text("\(viewModel.dataModel.sunset)")
                        .foregroundColor(.gray)
                }

                HStack {
                    Text("Population:")
                    Text(viewModel.dataModel.population)
                        .foregroundColor(.gray)
                }
            }
            .padding()
        }
        .padding()
    }
}
