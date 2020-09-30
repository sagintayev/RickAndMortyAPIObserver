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
    
    var season: Int {
        let firstIndex = code.index(code.firstIndex(of: "S")!, offsetBy: 1)
        let secondIndex = code.firstIndex(of: "E")!
        return Int(String(code[firstIndex..<secondIndex]))!
    }
    var episode: Int {
        let firstIndex = code.index(code.firstIndex(of: "E")!, offsetBy: 1)
        let secondIndex = code.endIndex
        return Int(String(code[firstIndex..<secondIndex]))!
    }
    
    private enum CodingKeys: String, CodingKey  {
        case id, name, created, url, characters
        case code = "episode"
        case airDate = "air_date"
    }
}

extension Episode: GettableFromAPI {
    typealias Resource = Self
    static var resourceName = "episode"
    static var networkHandler = NetworkHandler()
}

struct EpisodesDividedBySeasons {
    var seasons: Int {
        return episodes.keys.count
    }
    
    subscript(index: Int) -> [Episode]? {
        get {
            return episodes[index]
        }
        set {
            episodes[index] = newValue
        }
    }
    
    init(_ episodes: [Episode]) {
        for episode in episodes {
            let season = episode.season
            if self.episodes.keys.contains(season) {
                self.episodes[season]!.append(episode)
            } else {
                self.episodes[season] = [episode]
            }
        }
    }
    
    private var episodes = [Int: [Episode]]()
}
