//
//  Episode.swift
//  RickAndMorty
//
//  Created by Askhat Zhabayev on 2020-09-14.
//  Copyright © 2020 Zhanibek Sagintayev. All rights reserved.
//

import Foundation

struct Episode: Codable {
    let id: Int
    let name: String
    let created: Date
    let url: URL
    let code: String
    let airDate: Date
    let characters: [URL]
    
    private enum CodingKeys: String, CodingKey  {
        case id, name, created, url, characters
        case code = "episode"
        case airDate = "air_date"
    }
}
