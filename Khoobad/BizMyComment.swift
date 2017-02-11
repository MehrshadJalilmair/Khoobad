//
//  BizMyComment.swift
//  Khoobad
//
//  Created by Mehrshad Jalilmasir on 7/17/16.
//  Copyright © 2016 Mehrshad Jalilmasir. All rights reserved.
//

import UIKit


protocol myComment
{
    func commentOnBiz(cell : BizMyComment)
}

class BizMyComment: UITableViewCell {
    
    
    @IBOutlet var comments_top: UIImageView!
    @IBOutlet var user_image: UIImageView!
    @IBOutlet var background: UIView!
    @IBOutlet var myCommentBtn: UIButton!
    
    var delegate:myComment!
    
    var set:Bool!
    {
        didSet
        {
            updateUI()
        }
    }
    
    func updateUI()
    {
        myCommentBtn.titleLabel?.textAlignment = .Right
        myCommentBtn.setTitle("ثبت نظر من راجع به \(selectedBiz.name)", forState: UIControlState.Normal)
        
        let image : UIImage = self.resizeImageWithAspect(UIImage(named: "commebts_top")!,scaledToMaxWidth: 32.0, maxHeight: 32.0)
        comments_top.image = image
        
        background.layer.cornerRadius = 5
        background.layer.masksToBounds = false
        background.layer.borderWidth = 0.5
        background.layer.borderColor = UIColor(red: 0, green: 162, blue: 232, alpha: 0.5).CGColor
        //commentBackground.layer.shadowColor = UIColor(red: 73, green: 141, blue: 154, alpha: 1).colorWithAlphaComponent(0.5).CGColor
        background.layer.shadowOffset = CGSize(width: 0, height: 0)
        background.layer.shadowOpacity = 0.8
        
        self.user_image.layer.borderColor = UIColor.lightGrayColor().colorWithAlphaComponent(0.5).CGColor
        self.user_image.layer.borderWidth = 1.0
        self.user_image.layer.cornerRadius = self.user_image.layer.bounds.size.width/2
        self.user_image.layer.masksToBounds = true
        
        if user.imageAddress == "" || user.imageAddress == "default" {
            
            
        }
        else
        {
            let _url =  NSURL(string : String.localizedStringWithFormat(URLS.UserImage , user.imageAddress))
            if let url = _url {
                
                let imageDownloader = dataDownloaderServiceTask(url: url)
                imageDownloader.Download({ (data) in
                    
                    let image = UIImage(data : data)
                    dispatch_async(dispatch_get_main_queue(), {
                        
                        
                        self.user_image.image = image
                    })
                })
            }
        }
    }
    
    
    
    private func _resizeWithAspect_doResize(image: UIImage,size: CGSize)->UIImage{
        if UIScreen.mainScreen().respondsToSelector(#selector(NSDecimalNumberBehaviors.scale)){
            UIGraphicsBeginImageContextWithOptions(size,false,UIScreen.mainScreen().scale);
        }
        else
        {
            UIGraphicsBeginImageContext(size);
        }
        
        image.drawInRect(CGRectMake(0, 0, size.width, size.height));
        let newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        return newImage;
    }
    
    func resizeImageWithAspect(image: UIImage,scaledToMaxWidth width:CGFloat,maxHeight height :CGFloat)->UIImage
    {
        let oldWidth = image.size.width;
        let oldHeight = image.size.height;
        
        let scaleFactor = (oldWidth > oldHeight) ? width / oldWidth : height / oldHeight;
        
        let newHeight = oldHeight * scaleFactor;
        let newWidth = oldWidth * scaleFactor;
        let newSize = CGSizeMake(newWidth, newHeight);
        
        return self._resizeWithAspect_doResize(image, size: newSize);
    }
    
    @IBAction func GoToCommentPage(sender: AnyObject) {
        
        delegate.commentOnBiz(self)
    }
}
