//
//  SearchHistoryView.swift
//  SimpleWeather
//
//  Created by Filipe Merli on 09/12/21.
//

import SwiftUI

struct SearchHistoryView: View {

    @ObservedObject var viewModel: SearchHistoryViewModel

    init(viewModel: SearchHistoryViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        List(content: content)
          .onAppear(perform: viewModel.loadFromCoreData)
          .navigationBarTitle("City Search History")
          .listStyle(GroupedListStyle())
    }
}

private extension SearchHistoryView {
    func content() -> some View {
        if let viewModel = viewModel.citiesEntity {
            return AnyView(listView(viewModel: viewModel))
        } else {
            viewModel.loadFromCoreData()
            return AnyView(LoadingIndicator(isAnimating: true, style: .large).eraseToAnyView())
        }
    }

    func listView(viewModel: [City]) -> some View {
        return ListView(viewModel: viewModel)
    }

    struct ListView: View {
        let viewModel: [City]

        var body: some View {
            ForEach(viewModel) { city in
                NavigationLink(
                    destination: CityDetailView(city: city),
                    label: { ItemView(city: city) }
                )
            }
        }
    }

    struct ItemView: View {
        let city: City
        var body: some View {
            Text("\(city.name ?? "Unknown")")
        }
    }
}
