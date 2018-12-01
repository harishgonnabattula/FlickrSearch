//
//  Helper.swift
//  FlickrSearch
//
//  Created by Ninja on 12/1/18.
//  Copyright © 2018 Ninja. All rights reserved.
//

import UIKit
import Alamofire

struct Helper {
    static func getViewControllerBy(id: StoryBoardIDs) -> UIViewController {
        return UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: id.rawValue)
    }
}

struct AuthenticationHelper {

    private static func checkAuthorization() -> Bool{
        //return !(Auth.auth().currentUser == nil)
        return true
    }
    static func loadVC() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate

        if !checkAuthorization() {
            appDelegate.window?.rootViewController = Helper.getViewControllerBy(id: StoryBoardIDs.LOGIN)
        }
        else{
            appDelegate.window?.rootViewController = Helper.getViewControllerBy(id: StoryBoardIDs.FLICK_SEARCH)
        }
    }
}


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
        
        Alamofire.request(search_url, method: .get, parameters: searchParams, encoding: URLEncoding.default, headers: nil).validate().responseJSON { (response) in
            
            if response.result.isSuccess && response.data != nil{
                do {
                    let decoder = JSONDecoder()
                    let flickrResponse = try decoder.decode(Response.self, from: response.data!)
                    completionHandler((flickrResponse.photos,nil))
                }
                catch {
                    print("Error decoding the data from the server.")
                    completionHandler((nil,nil)) //Fill the error
                }
            }
            else {
                completionHandler((nil,response.error))
            }
        }
    }
}

