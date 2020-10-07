//
//  ApiServiceInfo.swift
//  RickAndMorty
//
//  Created by Askhat Zhabayev on 2020-09-15.
//  Copyright © 2020 Zhanibek Sagintayev. All rights reserved.
//

import Foundation

struct ApiServiceInfo: Codable {
    let count: Int
    let pages: Int
    let next: String?
    let prev: String?
}

struct ResourcesWithServiceInfo<Resource: Codable>: Codable {
    var results: [Resource]
    let info: ApiServiceInfo
}
