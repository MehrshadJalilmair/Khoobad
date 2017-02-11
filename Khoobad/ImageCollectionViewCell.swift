//
//  ImageCollectionViewCell.swift
//  Khoobad
//
//  Created by Mehrshad Jalilmasir on 6/26/16.
//  Copyright © 2016 Mehrshad Jalilmasir. All rights reserved.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var image: UIImageView!
    
    var url : NSURL!
        {
        didSet {
        self.updateUI()
        }
    }
    
    private func updateUI()
    {
        if let url1 = url {
            
            let imageDownloader = dataDownloaderServiceTask(url: url1)
            imageDownloader.Download({ (data) in
                
                let image = UIImage(data : data)
                dispatch_async(dispatch_get_main_queue(), {
                    
                    self.image.image = image
                    self.image.layer.cornerRadius = 5.0
                    self.image.layer.masksToBounds = true
                })
            })
        }
    }
}
