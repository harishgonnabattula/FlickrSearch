//
//  FlickrImageCollectionViewController.swift
//  FlickrSearch
//
//  Created by Ninja on 12/1/18.
//  Copyright © 2018 Ninja. All rights reserved.
//

import UIKit
import Lightbox

fileprivate let reuseIdentifier = "FlickrImage"
fileprivate let SECTIONS_NUM = 1
fileprivate let itemsPerRow: CGFloat = 3
fileprivate let sectionInsets = UIEdgeInsets(top: 10.0, left: 5.0, bottom: 50.0, right: 5.0)
fileprivate let HEADER_IDENTIFIER = "header"
fileprivate let FOOTER_IDENTIFIER = "footer"
let HEIGHT = CGFloat(50.0)

class FlickrImageCollectionViewController: UICollectionViewController {

    private(set) var dataSource = [FlickrPhoto]()
    private var searchText = DEFAULT_SEARCH
    fileprivate var SUPPLEMENTARY_VIEW_SIZE : CGSize {
        get {
            return CGSize(width: collectionView.bounds.size.width, height: HEIGHT)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Register cell classes
        self.collectionView!.register(UINib(nibName: "FlickrImageCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: reuseIdentifier)
        let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout
        layout?.sectionHeadersPinToVisibleBounds = true
        layout?.sectionFootersPinToVisibleBounds = true
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.scrollsToTop = true
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout
        layout?.invalidateLayout()
    }
    
    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return SECTIONS_NUM
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return SUPPLEMENTARY_VIEW_SIZE
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return SUPPLEMENTARY_VIEW_SIZE
    }
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                             withReuseIdentifier: HEADER_IDENTIFIER,
                                                                             for: indexPath) as! FlickrImageCollectionReusableView
            headerView.resultsLabel.text = "Showing results for \(searchText)"
            return headerView
        case UICollectionView.elementKindSectionFooter:
            let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                             withReuseIdentifier: FOOTER_IDENTIFIER,
                                                                             for: indexPath) as! FlickrFooterCollectionReusableView
            
            return footerView
        default:
            assert(false, "Unexpected element kind")
            
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! FlickrImageCollectionViewCell
        cell.configureCell(data: dataSource[indexPath.row])
        return cell
    }
    
    
    
}


// MARK: FLow Layout
extension FlickrImageCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow

        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
}


// MARK: Updating datasource
extension FlickrImageCollectionViewController {
    
    func updateDataSource(data: FlickrModel?, append: Bool, photos: [FlickrPhoto] = []) {
        guard let model = data else {
            if photos.count == 0 {
                self.dataSource = []
            }
            self.dataSource = photos
            self.collectionView.reloadData()
            return
        }
        if !append {
            self.dataSource += model.photo
        }
        else {
            self.dataSource = model.photo
        }
        
        self.collectionView.reloadData()
    }
    
    func updateSearchText(value: String) {
        self.searchText = value
    }
}
