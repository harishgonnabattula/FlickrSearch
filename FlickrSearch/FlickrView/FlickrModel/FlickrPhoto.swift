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
    private var width_s: String?
    private var height_s: String?
    var title: String
    var ispublic: Int
    
    lazy var photoUrl: URL? = {
        return url_s?.toURL()
    }()
}


//
//https://farm1.staticflickr.com/2/1418878_1e92283336_o.jpg
//
//https://farm{farm-id}.staticflickr.com/{server-id}/{id}_{o-secret}_o.(jpg|gif|png)

