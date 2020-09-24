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
        let url: URL?
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            name = try container.decode(String.self, forKey: .name)
            // there are cases when url obtained by API is empty string
            url = try? container.decode(URL.self, forKey: .url)
        }
    }
    
    let id: Int
    let name: String
    let created: Date
    let url: URL
    let species: String
    let type: String?
    let origin: LocationShortVersion
    let gender: Gender
    let status: Status
    let location: LocationShortVersion
    let image: URL
    let episodes: [URL]
    
    func getImage(completion: @escaping (Data) -> Void) {
        Character.networkHandler.getByURL(image) { (data, error) in
            if let data = data {
                completion(data)
            }
        }
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        created = try container.decode(Date.self, forKey: .created)
        url = try container.decode(URL.self, forKey: .url)
        species = try container.decode(String.self, forKey: .species)
        let typeString = try container.decode(String.self, forKey: .type)
        type = typeString != "" ? typeString : nil
        origin = try container.decode(LocationShortVersion.self, forKey: .origin)
        gender = try container.decode(Gender.self, forKey: .gender)
        status = try container.decode(Status.self, forKey: .status)
        location = try container.decode(LocationShortVersion.self, forKey: .location)
        image = try container.decode(URL.self, forKey: .image)
        episodes = try container.decode([URL].self, forKey: .episodes)
    }
    
    private enum CodingKeys: String, CodingKey {
        case id, name, created, url, species, type, origin, gender,
            status, location, image
        case episodes = "episode"
    }
}

extension Character: GettableFromAPI {
    typealias Resource = Self
    static var resourceName = "character"
    static var networkHandler = NetworkHandler()
}
