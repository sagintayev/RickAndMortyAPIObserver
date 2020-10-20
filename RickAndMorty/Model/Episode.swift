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
    
    var season: Int? {
        guard let seasonIndex = code.firstIndex(of: "S") else { return nil }
        guard let episodeIndex = code.firstIndex(of: "E") else { return nil }
        let startIndex = code.index(seasonIndex, offsetBy: 1)
        return Int(String(code[startIndex..<episodeIndex]))
    }
    var episode: Int? {
        guard let episodeIndex = code.firstIndex(of: "E") else { return nil }
        let startIndex = code.index(episodeIndex, offsetBy: 1)
        return Int(String(code[startIndex...]))
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
    
    init?(_ episodes: [Episode]) {
        for episode in episodes {
            guard let season = episode.season else { return nil }
            if self.episodes.keys.contains(season) {
                self.episodes[season]?.append(episode)
            } else {
                self.episodes[season] = [episode]
            }
        }
    }
    
    private var episodes = [Int: [Episode]]()
}
