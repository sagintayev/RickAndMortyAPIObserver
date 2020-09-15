//
//  NetworkHandler.swift
//  RickAndMorty
//
//  Created by Askhat Zhabayev on 2020-09-14.
//  Copyright © 2020 Zhanibek Sagintayev. All rights reserved.
//

import Foundation

struct NetworkHandler {
    let baseURL = "https://rickandmortyapi.com/api/"
    private let urlSession = URLSession.shared
    
    func getByPartOfURL(_ partOfURL: String, completion: @escaping (Data?, Error?) -> Void) {
        guard let url = URL(string: baseURL + partOfURL) else { return }
        getByURL(url, completion: completion)
    }
    
    func getByURL(_ url: String, completion: @escaping (Data?, Error?) -> Void) {
        guard let url = URL(string: url) else { return }
        getByURL(url, completion: completion)
    }
    
    func getByURL(_ url: URL, completion: @escaping (Data?, Error?) -> Void) {
        urlSession.dataTask(with: url) { (data, response, error) in
            completion(data, error)
        }.resume()
    }
}
