//
//  Constants.swift
//  FlickrSearch
//
//  Created by Ninja on 12/1/18.
//  Copyright © 2018 Ninja. All rights reserved.
//

import Foundation


enum StoryBoardIDs: String {
    case LOGIN = "Login"
    case FLICK_SEARCH = "FlickrSearchNavigation"
}

enum LoginStatusCodes {
    case LoginSuccess
    case LoginFailed
}

enum AlertStatus: String {
    case Loading
    case Uploading
    case Success
    case Failure
    case Other
}



let DELAY_TIME = 2.0


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



//https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=675894853ae8ec6c242fa4c077bcf4a0&text=dogs&extras=url_s&format=json&nojsoncallback=1
