//
//  Character.swift
//  RickAndMorty
//
//  Created by Askhat Zhabayev on 2020-09-14.
//  Copyright © 2020 Zhanibek Sagintayev. All rights reserved.
//

import Foundation

struct Character {
    
    enum Status {
        case alive
        case dead
        case unknown
    }
    
    enum Gender {
        case male
        case female
        case genderless
        case unknown
    }
    
    let id: Int
    let name: String
    let created: Date
    let url: URL
    let species: String
    let type: String
    let origin: Location
    let gender: Gender
    let status: Status
    let location: Location
    let image: URL
    let episodes: [URL]
}
