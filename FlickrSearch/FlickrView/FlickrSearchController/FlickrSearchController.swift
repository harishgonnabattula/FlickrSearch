//
//  FlickrSearchController.swift
//  FlickrSearch
//
//  Created by Ninja on 12/1/18.
//  Copyright © 2018 Ninja. All rights reserved.
//

import UIKit
import Kingfisher
import Lightbox
import Alamofire

fileprivate let BUFFER_SIZE = 6

class FlickrSearchController: FlickrImageCollectionViewController {
    
    private let apiManager = APIManager.init()
    private var currentPage = 1
    private var totalPages = 0
    private let searchController = UISearchController(searchResultsController: nil)
    private var searchText = DEFAULT_SEARCH
    private var isFetching = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initSearchView()
        fetchFlickrPhotos() // Initial Photos fetch
        ImageCache.default.maxDiskCacheSize = CACHE_SIZE  // Limiting Image cache size
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(FlickrSearchController.handleImageTap(sender:)), name: Notification.Name(rawValue: "Image Pressed"), object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func initSearchView() {
        // Setup the Search Controller
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Images"
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
    }
}

extension FlickrSearchController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchText = searchBar.text!
        fetchFlickrPhotos(with: searchBar.text!)
    }
}

// MARK: Prefetching for inifinte scrolling
extension FlickrSearchController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        
        if indexPaths.contains(where: isLoadingCell) {
            self.currentPage += 1
            // Until the current page is less than total pages, keep making calls
            if self.currentPage <= self.totalPages {
                if !isFetching {
                    fetchFlickrPhotos(with: searchText, pageNo: self.currentPage)
                }
            }
            else {
                print("Page overflow") // When our current page crosses the total pages.
            }
        }
    }
    
    // If current index path is greater than the total count - 6 then we will make the next page call.
    func isLoadingCell(for indexPath: IndexPath) -> Bool {
        return indexPath.row >= dataSource.count - BUFFER_SIZE
    }
}

extension FlickrSearchController {
    @objc func handleImageTap(sender:Notification) {
        guard var photo = sender.object as? FlickrPhoto, let url = photo.photoUrl else {
            return
        }
        guard let img = ImageCache.default.retrieveImageInMemoryCache(forKey: url.absoluteString) else {
            return
        }
        let images = [ LightboxImage(image: img, text: photo.title, videoURL: nil)]
        // Create an instance of LightboxController.
        let controller = LightboxController(images: images)
        
        // Use dynamic background.
        controller.dynamicBackground = true
        
        // Present your controller.
        present(controller, animated: true, completion: nil)
    }
}

// MARK: Fetching Photos Logic with Offline Handling

extension FlickrSearchController {
    private func fetchFlickrPhotos(with text: String = DEFAULT_SEARCH, pageNo: Int = 1) {
        updateSearchText(value: text)
        
        if !NetworkReachabilityManager()!.isReachable {
            // Wait for the collection view to initialize before sending notification. This is for the info on the footer.
            DispatchQueue.main.asyncAfter(deadline: .now()+1) {
                NotificationCenter.default.post(name: NSNotification.Name("Error"), object: true)
            }
            guard let key = userDefaults.object(forKey: "lastQuery") as? String, let data = userDefaults.data(forKey: key) else {
                return
            }
            do {
                let photos = try JSONDecoder().decode(Array<FlickrPhoto>.self, from: data)
                updateDataSource(data: nil, append: false, photos: photos)
            }
            catch {
                print("Error")
            }
        }
        else {
            isFetching = true
            NotificationCenter.default.post(name: NSNotification.Name("In Process"), object: isFetching)
            apiManager.fetchFlickrPhotos(with: text, page: pageNo) { (results) in
                self.isFetching = false
                guard let data = results.response else {
                    NotificationCenter.default.post(name: NSNotification.Name("Error"), object: true)
                    return
                }
                NotificationCenter.default.post(name: NSNotification.Name("In Process"), object: self.isFetching)
                self.totalPages = data.pages
                self.updateDataSource(data: data, append: pageNo != 1)
            }
        }
    }
}
