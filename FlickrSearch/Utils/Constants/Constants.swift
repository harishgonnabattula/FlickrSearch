//
//  Constants.swift
//  FlickrSearch
//
//  Created by Ninja on 12/1/18.
//  Copyright © 2018 Ninja. All rights reserved.
//

import Foundation

struct API {
    
    let base_url = "https://api.flickr.com/services/rest/"
    private let search_method = "flickr.photos.search"
    private let API_KEY = "77ff9a62ef9bedbadd615bdffd618f2d"
    
    func getSearchParameter() -> [String:String] {
        return [
            "method":search_method,
            "api_key":API_KEY,
            "extras":"url_s",
            "format":"json",
            "nojsoncallback":"1"
        ]
    }
}

extension String {
    func toURL() -> URL? {
        return URL(string: self)
    }
}

let DEFAULT_SEARCH = "Mountains"
let CACHE_SIZE = UInt(50 * 1024 * 1024)
