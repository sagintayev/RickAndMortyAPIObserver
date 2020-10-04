//
//  Extensions.swift
//  RickAndMorty
//
//  Created by Askhat Zhabayev on 2020-09-14.
//  Copyright © 2020 Zhanibek Sagintayev. All rights reserved.
//

import UIKit
import Foundation

// MARK: - Formatter
extension Formatter {
    static let iso8601withFractionalSeconds: DateFormatter = {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
        return formatter
    }()
    
    static let monthDayYearString: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "MMM d, yyyy"
        return formatter
    }()
}

// MARK: - DateDecodingStrategy
extension JSONDecoder.DateDecodingStrategy {
    static let iso8601withFractionalSecondsOrMonthDayYear = custom {
        let container = try $0.singleValueContainer()
        let string = try container.decode(String.self)
        if let date = Formatter.iso8601withFractionalSeconds.date(from: string) ?? Formatter.monthDayYearString.date(from: string) {
            return date
        } else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid date: " + string)
        }
    }
}

// MARK: - NSLayoutConstraint
extension NSLayoutConstraint {
    func withPriority(_ priority: Float) -> Self {
        let priority = UILayoutPriority(priority)
        self.priority = priority
        return self
    }
}
