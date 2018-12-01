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
fileprivate let sectionInsets = UIEdgeInsets(top: 10.0, left: 0.0, bottom: 50.0, right: 0.0)
fileprivate let headerIdentifier = "header"

class FlickrImageCollectionViewController: UICollectionViewController {

    private(set) var dataSource = [FlickrPhoto]()
    private var searchText = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Register cell classes
        self.collectionView!.register(UINib(nibName: "FlickrImageCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: reuseIdentifier)

    }
    
    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return SECTIONS_NUM
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.size.width, height: 50.0)
    }

    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                             withReuseIdentifier: headerIdentifier,
                                                                             for: indexPath) as! FlickrImageCollectionReusableView
            headerView.resultsLabel.text = "Showing results for \(searchText)"
            return headerView
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

extension FlickrImageCollectionViewController {
    
    func updateDataSource(data: FlickrModel?, append: Bool) {
        guard let model = data else {
            self.dataSource = []
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
