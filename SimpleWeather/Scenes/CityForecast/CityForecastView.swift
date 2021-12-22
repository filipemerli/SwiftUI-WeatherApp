//
//  CityForescastView.swift
//  ForecastApp
//
//  Created by Filipe Merli on 04/12/21.
//

import SwiftUI

struct CityForescastView: View {

    @ObservedObject var viewModel: CityForecastViewModel
    @Environment(\.dismissSearch) var dismissSearch

    init(viewModel: CityForecastViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        ZStack {
            NavigationView {
                VStack {
                    HStack {
                        Text("")
                            .searchable(text: $viewModel.citySearch, placement: .navigationBarDrawer, prompt: "City Search")
                            .onSubmit {
                                dismissSearch()
                            }
                    }
                    if let city = viewModel.dataSource {
                        list(of: city)
                    } else {
                        noResultsView
                    }
                }
                .navigationTitle("Weather Forecast")
                .navigationBarTitleDisplayMode(.inline)
                .navigationViewStyle(StackNavigationViewStyle())
            }
            .navigationViewStyle(StackNavigationViewStyle())
            searchButton
        }
    }

    private var noResultsView: some View {
        VStack {
            Text("No Results for \(viewModel.citySearch)")
                .font(.title2)
        }
    }

    private var searchButton: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Button(action: {
                    print("Button press")
                }, label: {
                    Text("Searches")
                        .font(.body)
                        .frame(width: 82, height: 45)
                        .foregroundColor(.black)
                        .padding(.bottom, 7)
                })
                    .background(Color.gray.opacity(0.25))
                    .cornerRadius(18)
                    .padding()
            }
        }
    }

    private func list(of city: CityForecastViewModel.ListCity) -> some View {
        VStack {
            Text(city.name)
                .font(.title)
            .padding()
            Divider()
            ScrollView {
                VStack {
                    ForEach(city.days) { day in
                        Text(day.id)
                            .font(.title2)
                            ScrollView(.horizontal, showsIndicators: true) {
                                HStack {
                                    ForEach(0..<day.hours.count) { index in
                                        DailyCellView(hour: day.hours[index], temp: day.temps[index])
                                            .padding(20)
                                            .background(Color.gray.opacity(0.25))
                                            .cornerRadius(8)
                                    }
                                }
                            }.padding(10)
                        Divider()
                    }
                }
            }
            .onAppear(perform: {
                guard city.name.count != 0 else { return }
                viewModel.storeCity(city: city)
            })
            .gesture(DragGesture().onChanged{_ in UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)})
        }
    }

    struct DailyCellView: View {
        let hour: String
        let temp: String
        
        var body: some View {
            VStack(alignment: .center, spacing: 5) {
                title
                HStack { }.frame(width: 5, height: 5)
                temperature
            }
        }

        private var title: some View {
            Text("\(hour)h")
                .font(.title3)
        }

        private var temperature: some View {
            Text("\(temp)°C")
                .font(.title2)
        }
    }
}
