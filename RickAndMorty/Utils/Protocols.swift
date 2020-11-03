//
//  Protocols.swift
//  RickAndMorty
//
//  Created by Askhat Zhabayev on 2020-10-13.
//  Copyright © 2020 Zhanibek Sagintayev. All rights reserved.
//

import Foundation

// MARK: - GettableFromAPI
protocol GettableFromAPI: Codable {
    associatedtype Resource: Codable
    
    static var resourceName: String { get }
    static var networkHandler: NetworkHandler { get set }
    
    static func getAll(completion: @escaping (Result<[Resource], Error>) -> Void)
    static func getByIDs(_ id: [Int], completion: @escaping (Result<[Resource], Error>) -> Void)
    static func getByPageNumber(_ number: Int, completion: @escaping (Result<ResourcesWithServiceInfo<Resource>, Error>) -> Void)
    static func getByFilter(_ filter: Filter, completion: @escaping (Result<ResourcesWithServiceInfo<Resource>, Error>) -> Void)
}

// MARK: - Filter
protocol Filter {
    var queryString: String { get }
}

// MARK: - SearchControllerDelegate
protocol SearchControllerDelegate {
    func searchStarted(with filter: Filter)
}

// MARK: - CharacterFilterViewDelegate
protocol CharacterFilterViewDelegate {
    func nameTextFieldValueChanged(_ name: String?)
    func speciesTextFieldValueChanged(_ species: String?)
    func typeTextFieldValueChanged(_ type: String?)
    func statusSegmentedControlValueChanged(_ selectedIndex: Int)
    func genderSegmentedControlValueChanged(_ selectedIndex: Int)
    func cancelButtonTapped()
    func searchButtonTapped()
}

protocol Toggleable {
    var toggleHandler: (() -> Void)? { get set }
}

// MARK: - GettableFromAPI extension
extension GettableFromAPI {
    
    static func getAll(completion: @escaping (Result<[Resource], Error>) -> Void) {
        networkHandler.getByPartOfURL(resourceName) { (data, error) in
            guard let data = data else {
                if let error = error {
                    completion(.failure(error))
                }
                return
            }
            do {
                var resources = try getDecoder().decode(ResourcesWithServiceInfo<Resource>.self, from: data)
                let gatherAllResourcesGroup = DispatchGroup()
                if resources.info.pages > 1 {
                    for pageNumber in 2...resources.info.pages {
                        gatherAllResourcesGroup.enter()
                        getByPageNumber(pageNumber) { (result) in
                            if case .success(let resourcesOnPage) = result {
                                resources.results.append(contentsOf: resourcesOnPage.results)
                                gatherAllResourcesGroup.leave()
                            }
                        }
                    }
                }
                gatherAllResourcesGroup.notify(queue: .main) {
                    completion(.success(resources.results))
                }
            } catch let error {
                completion(.failure(error))
            }
        }
    }
    
    static func getByIDs(_ ids: [Int], completion: @escaping (Result<[Resource], Error>) -> Void) {
        networkHandler.getByPartOfURL("\(resourceName)/\(ids.map {String($0)}.joined(separator: ","))") { (data, error) in
            guard let data = data else {
                if let error = error {
                    completion(.failure(error))
                }
                return
            }
            do {
                var resource: [Resource]
                if ids.count == 1 {
                    let singleResource = try getDecoder().decode(Resource.self, from: data)
                    resource = [singleResource]
                } else {
                    resource = try getDecoder().decode([Resource].self, from: data)
                }
                completion(.success(resource))
            } catch let error {
                completion(.failure(error))
            }
        }
    }
    
    static func getByPageNumber(_ number: Int, completion: @escaping ((Result<ResourcesWithServiceInfo<Resource>, Error>) -> Void)) {
        networkHandler.getByPartOfURL("\(resourceName)/?page=\(number)") { (data, error) in
            guard let data = data else {
                if let error = error {
                    completion(.failure(error))
                }
                return
            }
            do {
                let resources = try getDecoder().decode(ResourcesWithServiceInfo<Resource>.self, from: data)
                completion(.success(resources))
            } catch let error {
                completion(.failure(error))
            }
        }
    }
    
    static func getByFilter(_ filter: Filter, completion: @escaping (Result<ResourcesWithServiceInfo<Resource>, Error>) -> Void) {
        networkHandler.getByPartOfURL("\(resourceName)/\(filter.queryString)") { (data, error) in
            guard let data = data else {
                if let error = error {
                    completion(.failure(error))
                }
                return
            }
            do {
                let resources = try getDecoder().decode(ResourcesWithServiceInfo<Resource>.self, from: data)
                completion(.success(resources))
            } catch let error {
                completion(.failure(error))
            }
        }
    }
    
    static func getIDFromUrl(_ url: URL) -> Int? {
        let url = url.absoluteString
        return getIDFromUrl(url)
    }
    
    static func getIDFromUrl(_ url: String) -> Int? {
        guard url.contains(resourceName) else { return nil }
        guard let lastSlashIndex = url.lastIndex(of: "/") else { return nil }
        let idStartIndex = url.index(lastSlashIndex, offsetBy: 1)
        return Int(url[idStartIndex...])
    }
    
    private static func getDecoder() -> JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601withFractionalSecondsOrMonthDayYear
        return decoder
    }
}
