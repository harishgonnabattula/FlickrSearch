//
//  Helper.swift
//  FlickrSearch
//
//  Created by Ninja on 12/1/18.
//  Copyright © 2018 Ninja. All rights reserved.
//

import UIKit
import Alamofire

typealias FlickrFetchResults = (response: FlickrModel?,error: Error?)

struct APIManager {
    
    let Api = API()
    
    func fetchFlickrPhotos(with name:String , page:Int = 1, completionHandler: @escaping (FlickrFetchResults) -> Void) {
        
        var searchParams = Api.getSearchParameter()
        searchParams["text"] = name
        searchParams["page"] = "\(page)"
        
        guard let search_url = Api.base_url.toURL() else {
            return
        }
        getRequest(url: search_url, params: searchParams) { (response) in
            
            if response.result.isSuccess && response.data != nil {
                do {
                    let decoder = JSONDecoder()
                    let flickrResponse = try decoder.decode(Response.self, from: response.data!)
                    // TODO:
                    // Save in Core Data
                    completionHandler((flickrResponse.photos,nil))
                }
                catch {
                    print("Error decoding the data from the server.")
                    completionHandler((nil,nil)) //Fill the error
                }
            }
            else if response.response == nil {
                // TODO:
                //No Internet
                //Load from Core Data
            }
            else {
                completionHandler((nil,response.error))
            }
        }
    }
    
    private func getRequest(url: URL, params: Parameters?, completionHandler: @escaping (DataResponse<Any>) -> Void) {
        
        Alamofire.request(url, method: .get, parameters: params, encoding: URLEncoding.default, headers: nil).validate().responseJSON { (response) in
                completionHandler(response)
            }
    }
    
}


struct DataManager {
    
    
}
