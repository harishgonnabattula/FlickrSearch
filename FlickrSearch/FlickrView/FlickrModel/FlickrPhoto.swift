//
//  FlickrPhoto.swift
//  FlickrSearch
//
//  Created by Ninja on 12/1/18.
//  Copyright © 2018 Ninja. All rights reserved.
//

import Foundation

struct FlickrPhoto: Codable {
    private var id: String
    private var owner: String
    private var secret: String
    private var server: String
    private var farm: Int
    private var url_s: String?
    var width_s: String?
    var height_s: String?
    var title: String
    var ispublic: Int
    
    lazy var photoUrl: URL? = {
        return url_s?.toURL()
    }()
}




