//
//  FlickrFooterCollectionReusableView.swift
//  FlickrSearch
//
//  Created by Ninja on 12/1/18.
//  Copyright © 2018 Ninja. All rights reserved.
//

import UIKit

class FlickrFooterCollectionReusableView: UICollectionReusableView {
        
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var updateStatusLabel: UILabel!
    
    override func awakeFromNib() {
        NotificationCenter.default.addObserver(self, selector: #selector(FlickrFooterCollectionReusableView.updateStatus(sender:)), name: NSNotification.Name("In Process"),object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(FlickrFooterCollectionReusableView.updateErrorStatus(sender:)), name: NSNotification.Name("Error"),object: nil)
        activityIndicator.hidesWhenStopped = true
    }
    
    @objc private func updateStatus(sender: Notification) {
        guard let isUpdating = sender.object as? Bool else {
            return
        }
        if isUpdating {
            activityIndicator.startAnimating()
            updateStatusLabel.text = "Loading Data..Please stop scrolling."
        }
        else {
            let df = DateFormatter()
            df.timeStyle = .short
            let time = df.string(from: Date())
            DispatchQueue.main.asyncAfter(deadline: .now()+1) { [unowned self] in
                self.activityIndicator.stopAnimating()
                self.updateStatusLabel.text = "Last updated at \(time)"
            }
            
        }
    }
     @objc private func updateErrorStatus(sender: Notification) {
        self.activityIndicator.stopAnimating()
        self.updateStatusLabel.text = "Error. Maybe no Internet!!"
    }
    
}
