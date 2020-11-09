//
//  ImageCache.swift
//  RickAndMorty
//
//  Created by Zhanibek Sagintayev on 2020-11-09.
//  Copyright © 2020 Zhanibek Sagintayev. All rights reserved.
//

import Foundation

class ImageCache: NSObject {
    private var cache = NSCache<NSURL, NSData>()
    
    subscript(url: URL) -> Data? {
        get {
            cache.object(forKey: url as NSURL) as Data?
        }
        set(data) {
            guard let data = data else { return }
            cache.setObject(data as NSData, forKey: url as NSURL)
        }
    }
}
