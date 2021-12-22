//
//  Array+Extensions.swift
//  SimpleWeather
//
//  Created by Felipe Merli on 21/12/21.
//

import Foundation

public extension Array where Element: Hashable {
    static func removeDuplicates(_ elements: [Element]) -> [Element] {
        var seen = Set<Element>()
        return elements.filter{ seen.insert($0).inserted }
    }
}
