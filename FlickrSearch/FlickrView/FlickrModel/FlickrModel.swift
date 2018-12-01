//
//  FlickrModel.swift
//  FlickrSearch
//
//  Created by Ninja on 12/1/18.
//  Copyright © 2018 Ninja. All rights reserved.
//

import Foundation

struct FlickrModel: Codable {
    
    var page: Int
    var pages: Int
    var perpage: Int
    var total: String
    
    var photo: [FlickrPhoto]
    
    
}

