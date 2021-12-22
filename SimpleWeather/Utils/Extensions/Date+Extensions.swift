//
//  Date+Extensions.swift
//  SimpleWeather
//
//  Created by Felipe Merli on 09/12/21.
//

import Foundation

extension Date {
    func getDayString() -> String {
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "EEEE, MMM dd yyyy"
        return dateFormat.string(from: self)
    }

    func getHourString() -> String {
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "HH"
        return dateFormat.string(from: self)
    }

    func getCompleteHourString() -> String {
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "HH:mm:ss"
        return dateFormat.string(from: self)
    }
}
