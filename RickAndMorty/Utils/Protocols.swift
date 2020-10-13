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
    static func getByID(_ id: Int, completion: @escaping (Result<Resource, Error>) -> Void)
    static func getByPageNumber(_ number: Int, completion: @escaping (Result<ResourcesWithServiceInfo<Resource>, Error>) -> Void)
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
    
    static func getByID(_ id: Int, completion: @escaping (Result<Resource, Error>) -> Void) {
        networkHandler.getByPartOfURL("\(resourceName)/\(id)") { (data, error) in
            guard let data = data else {
                if let error = error {
                    completion(.failure(error))
                }
                return
            }
            do {
                let resource = try getDecoder().decode(Resource.self, from: data)
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
    
    private static func getDecoder() -> JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601withFractionalSecondsOrMonthDayYear
        return decoder
    }
}
