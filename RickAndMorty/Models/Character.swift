//
//  Character.swift
//  RickAndMorty
//
//  Created by Askhat Zhabayev on 2020-09-14.
//  Copyright © 2020 Zhanibek Sagintayev. All rights reserved.
//

import Foundation

struct Character: Codable {
    
    enum Status: String, Codable {
        case alive = "Alive"
        case dead = "Dead"
        case unknown = "unknown"
    }
    
    enum Gender: String, Codable {
        case male = "Male"
        case female = "Female"
        case genderless = "Genderless"
        case unknown = "unknown"
    }
    
    struct LocationShortVersion: Codable {
        let name: String
        let url: URL
    }
    
    let id: Int
    let name: String
    let created: Date
    let url: URL
    let species: String
    let type: String
    let origin: LocationShortVersion
    let gender: Gender
    let status: Status
    let location: LocationShortVersion
    let image: URL
    let episodes: [URL]
    
    private enum CodingKeys: String, CodingKey {
        case id, name, created, url, species, type, origin, gender,
            status, location, image
        case episodes = "episode"
    }
}
