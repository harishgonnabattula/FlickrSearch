//
//  Response.swift
//  FlickrSearch
//
//  Created by Ninja on 12/1/18.
//  Copyright © 2018 Ninja. All rights reserved.
//

import Foundation

struct Response: Codable {
    var stat: String
    var photos: FlickrModel
}
