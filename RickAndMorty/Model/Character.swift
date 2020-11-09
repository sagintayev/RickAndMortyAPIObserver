//
//  Character.swift
//  RickAndMorty
//
//  Created by Askhat Zhabayev on 2020-09-14.
//  Copyright © 2020 Zhanibek Sagintayev. All rights reserved.
//

import Foundation

// MARK: - Character
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
    
    enum Species: String, Codable {
        case alien = "Alien"
        case robot = "Robot"
        case cronenberg = "Cronenberg"
        case human = "Human"
        case disease = "Disease"
        case humanoid = "Humanoid"
        case mythologicalCreature = "Mythological Creature"
        case poopybutthole = "Poopybutthole"
        case animal = "Animal"
        case planet = "Planet"
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
    let species: Species
    let type: String?
    let origin: LocationShortVersion
    let gender: Gender
    let status: Status
    let location: LocationShortVersion
    let image: URL
    let episodes: [URL]
    
    private static var imageCache = ImageCache()
    
    func getImage(completion: @escaping (Data) -> Void) {
        if let imageData = Character.imageCache[image] {
            completion(imageData as Data)
        }
        Character.networkHandler.getByURL(image) { (data, error) in
            if let data = data {
                Character.imageCache[image] = data
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
        species = try container.decode(Species.self, forKey: .species)
        let typeString = try container.decode(String.self, forKey: .type)
        type = typeString != "" ? typeString : nil
        origin = try container.decode(LocationShortVersion.self, forKey: .origin)
        gender = try container.decode(Gender.self, forKey: .gender)
        status = try container.decode(Status.self, forKey: .status)
        location = try container.decode(LocationShortVersion.self, forKey: .location)
        image = try container.decode(URL.self, forKey: .image)
        episodes = try container.decode([URL].self, forKey: .episodes)
    }
    
    enum CodingKeys: String, CodingKey {
        case id, name, created, url, species, type, origin, gender,
            status, location, image
        case episodes = "episode"
    }
}

// MARK: - Character extension GettableFromAPI
extension Character: GettableFromAPI {
    typealias Resource = Self
    static var resourceName = "character"
    static var networkHandler = NetworkHandler()
}

// MARK: - CharacterFilter
struct CharacterFilter {
    var available = true
    var page: Int {
        get {
            guard let page = filter[pageKey] as? String else { return 1 }
            return Int(page) ?? 1
        }
        set {
            filter[pageKey] = String(newValue)
        }
    }
    
    var name: String? {
        get {
            return filter[nameKey] ?? nil
        }
        set {
            filter[nameKey] = newValue
        }
    }
    
    var species: Character.Species? {
        get {
            guard let species = filter[speciesKey] as? String else { return nil }
            return Character.Species(rawValue: species)
        }
        set {
            filter[speciesKey] = newValue?.rawValue
        }
    }
    
    var type: String? {
        get {
            return filter[typeKey] ?? nil
        }
        set {
            filter[typeKey] = newValue
        }
    }
    
    var status: Character.Status? {
        get {
            guard let status = filter[statusKey] as? String else { return nil }
            return Character.Status(rawValue: status)
        }
        set {
            filter[statusKey] = newValue?.rawValue
        }
    }
    
    var gender: Character.Gender? {
        get {
            guard let gender = filter[genderKey] as? String else { return nil }
            return Character.Gender(rawValue: gender)
        }
        set {
            filter[genderKey] = newValue?.rawValue
        }
    }
    
    private let pageKey = "page"
    private let nameKey = Character.CodingKeys.name.rawValue
    private let speciesKey = Character.CodingKeys.species.rawValue
    private let typeKey = Character.CodingKeys.type.rawValue
    private let statusKey = Character.CodingKeys.status.rawValue
    private let genderKey = Character.CodingKeys.gender.rawValue
    private var filter = [String: String?]()
}

// MARK: - CharacterFilter extension Filter
extension CharacterFilter: Filter {
    var queryString: String {
        guard !filter.isEmpty else { return "" }
        let spaceSymbol = "%20"
        var query = "?"
        for (parameter, value) in filter {
            guard var value = value else { continue }
            value = value.replacingOccurrences(of: " ", with: spaceSymbol)
            query.append("\(parameter)=\(value)")
            query.append("&")
        }
        query.removeLast()
        return query
    }
}
