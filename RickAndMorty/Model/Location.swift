//
//  Location.swift
//  RickAndMorty
//
//  Created by Askhat Zhabayev on 2020-09-14.
//  Copyright © 2020 Zhanibek Sagintayev. All rights reserved.
//

import Foundation

struct Location {
    let id: Int
    let name: String
    let created: Date
    let url: URL
    let type: String
    let dimension: String
    let residents: [URL]
}

extension Location: GettableFromAPI {
    typealias Resource = Self
    static var resourceName = "location"
    static var networkHandler = NetworkHandler()
}
