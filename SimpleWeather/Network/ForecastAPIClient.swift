//
//  ForecastAPIClient.swift
//  ForecastApp
//
//  Created by Filipe Merli on 04/12/21.
//

import Foundation
import Combine

protocol ForecastAPIClientProtocol {
    func getForecastForCity(city: String) -> AnyPublisher<CityForecastResponse, CustomError>
}

enum CustomError: Error {
    case parsing(description: String)
    case network(description: String)
}

class ForecastAPIClient: ForecastAPIClientProtocol {

    private let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }

    func getForecastForCity(city: String) -> AnyPublisher<CityForecastResponse, CustomError> {
        guard let url = buildForecastComponents(city: city).url else {
          let error = CustomError.network(description: "Couldn't create URL")
          return Fail(error: error).eraseToAnyPublisher()
        }
        return session.dataTaskPublisher(for: URLRequest(url: url))
          .mapError { error in
          .network(description: error.localizedDescription)
          }
          .flatMap(maxPublishers: .max(1)) { pair in
              self.decode(pair.data)
          }
          .eraseToAnyPublisher()
    }
}

private extension ForecastAPIClient {
    struct ForecastAPI {
        static let scheme = "https"
        static let host = "api.openweathermap.org"
        static let path = "/data/2.5"
        static let appId = "f9e58cca76c9758dc063bd226e6fa183"
    }

    func buildForecastComponents(city: String) -> URLComponents {
        var components = URLComponents()
        components.scheme = ForecastAPI.scheme
        components.host = ForecastAPI.host
        components.path = ForecastAPI.path + "/forecast"
        components.queryItems = [
            URLQueryItem(name: "q", value: city),
            URLQueryItem(name: "mode", value: "json"),
            URLQueryItem(name: "units", value: "metric"),
            URLQueryItem(name: "appid", value: ForecastAPI.appId)
        ]

        return components
        
    }

    func buildWeatherComponents(city: String) -> URLComponents {
        var components = URLComponents()
        components.scheme = ForecastAPI.scheme
        components.host = ForecastAPI.host
        components.path = ForecastAPI.path + "/weather"
        components.queryItems = [
            URLQueryItem(name: "q", value: city),
            URLQueryItem(name: "mode", value: "json"),
            URLQueryItem(name: "units", value: "metric"),
            URLQueryItem(name: "appid", value: ForecastAPI.appId)
        ]

        return components
    }

    func decode<T: Decodable>(_ data: Data) -> AnyPublisher<T, CustomError> {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        
        return Just(data)
            .decode(type: T.self, decoder: decoder)
            .mapError { error in
            .parsing(description: error.localizedDescription)
            }
            .eraseToAnyPublisher()
    }
}
