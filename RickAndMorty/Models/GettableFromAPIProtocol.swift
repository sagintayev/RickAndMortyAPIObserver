//
//  GettableFromAPIProtocol.swift
//  RickAndMorty
//
//  Created by Askhat Zhabayev on 2020-09-15.
//  Copyright © 2020 Zhanibek Sagintayev. All rights reserved.
//

import Foundation


protocol GettableFromAPI: Codable {
    associatedtype Resource: Codable
    
    static var resourceName: String { get }
    static var networkHandler: NetworkHandler { get set }
    
    static func getAll(completion: @escaping ([Resource]) -> Void)
    static func getByID(_ id: Int, completion: @escaping (Resource) -> Void)
    static func getByPageNumber(_ number: Int, completion: @escaping ([Resource]) -> Void)
}

extension GettableFromAPI {
    
    static func getAll(completion: @escaping ([Resource]) -> Void) {
        //
    }
    
    static func getByID(_ id: Int, completion: @escaping (Resource) -> Void) {
        networkHandler.getByPartOfURL(resourceName + "/" + String(id)) { (data, error) in
            if let data = data {
                if let resource = try? getDecoder().decode(Resource.self, from: data) {
                    completion(resource)
                }
            }
        }
    }
    
    static func getByPageNumber(_ number: Int, completion: @escaping (([Resource]) -> Void)) {
        networkHandler.getByPartOfURL("\(resourceName)/?page=\(number)") { (data, error) in
            if let data = data {
                if let resources = try? getDecoder().decode(ResourcesWithServiceInfo<Resource>.self, from: data) {
                    print(resources.info)
                    completion(resources.results)
                }
            }
        }
    }
    
    private static func getDecoder() -> JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601withFractionalSecondsOrMonthDayYear
        return decoder
    }
}
