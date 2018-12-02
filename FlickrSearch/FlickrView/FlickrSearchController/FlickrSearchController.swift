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
        fetchFlickrPhotos()
        NotificationCenter.default.post(name: NSNotification.Name("In Process"), object: isFetching)
        
        ImageCache.default.maxDiskCacheSize = CACHE_SIZE
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
    
    private func fetchFlickrPhotos(with text: String = DEFAULT_SEARCH, pageNo: Int = 1) {
        apiManager.fetchFlickrPhotos(with: text, page: pageNo) { (results) in
            self.isFetching = false
            guard let data = results.response else {
                NotificationCenter.default.post(name: NSNotification.Name("Error"), object: true)
                return
            }
            NotificationCenter.default.post(name: NSNotification.Name("In Process"), object: self.isFetching)
            self.totalPages = data.pages
            self.updateSearchText(value: text)
            self.updateDataSource(data: data, append: pageNo == 1)
        }
    }

}

extension FlickrSearchController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchText = searchBar.text!
        fetchFlickrPhotos(with: searchBar.text!)
        NotificationCenter.default.post(name: NSNotification.Name("In Process"), object: isFetching)
    }
}

extension FlickrSearchController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        
        if indexPaths.contains(where: isLoadingCell) {
            self.currentPage += 1
            if self.currentPage <= self.totalPages {
                if !isFetching {
                    isFetching = true
                    fetchFlickrPhotos(with: searchText, pageNo: self.currentPage)
                    NotificationCenter.default.post(name: NSNotification.Name("In Process"), object: isFetching)
                }
            }
            else {
                print("Page overflow")
            }
        }
    }
    func isLoadingCell(for indexPath: IndexPath) -> Bool {
        return indexPath.row >= dataSource.count - 6
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
