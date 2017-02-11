//
//  fullImageViewController.swift
//  Khoobad
//
//  Created by Mehrshad Jalilmasir on 7/13/16.
//  Copyright © 2016 Mehrshad Jalilmasir. All rights reserved.
//

import UIKit

class fullImageViewController: UIViewController {

    
    @IBOutlet var image: UIImageView!
    var _image = NSURL()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let imageDownloader = dataDownloaderServiceTask(url: _image)
        imageDownloader.Download({ (data) in
            
            let image = UIImage(data : data)
            dispatch_async(dispatch_get_main_queue(), {
                
                self.image.image = image
            })
        })
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(fullImageViewController.popToRoot), name: "popToRoot", object: nil)
    }
    @IBAction func close(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true, completion: {})
    }
    func popToRoot()
    {
        parentViewController?.dismissViewControllerAnimated(true, completion: {})//back to previous
    }
}
