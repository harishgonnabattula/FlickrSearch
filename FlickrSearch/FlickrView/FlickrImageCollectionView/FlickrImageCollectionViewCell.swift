//
//  FlickrImageCollectionViewCell.swift
//  FlickrSearch
//
//  Created by Ninja on 12/1/18.
//  Copyright © 2018 Ninja. All rights reserved.
//

import UIKit
import Kingfisher

class FlickrImageCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak private var imageView: UIImageView!
    fileprivate var tapGesture: UITapGestureRecognizer!
    fileprivate var photo: FlickrPhoto?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(FlickrImageCollectionViewCell.handleTap(sender:)))
        imageView.addGestureRecognizer(tapGesture)
    }
    
    func configureCell(data: FlickrPhoto) {
        var tData = data
        guard let url = tData.photoUrl else {
            return
        }
        photo = data
        imageView.kf.indicatorType = .activity
        imageView.kf.setImage(with: url)
    }
    
    @objc func handleTap(sender: UITapGestureRecognizer) {
        NotificationCenter.default.post(name: Notification.Name(rawValue: "Image Pressed"), object: photo)
    }

}
