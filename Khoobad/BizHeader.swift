//
//  BizHeader.swift
//  Khoobad
//
//  Created by Mehrshad Jalilmasir on 6/27/16.
//  Copyright © 2016 Mehrshad Jalilmasir. All rights reserved.
//

import UIKit

protocol Gallery
{
    func moreImage(header : BizHeader)
    func _fav(cell : BizHeader)
    func off(cell : BizHeader)
    func star(cell : BizHeader)
}

var GalleryDelegate:Gallery!

class BizHeader: UIView {

    @IBOutlet weak var BizImage1: UIImageView!
    @IBOutlet weak var BizMoreImageBtn: UIButton!
    @IBOutlet weak var BlurBackground: UIView!
    @IBOutlet weak var FavBtn: UIButton!
    @IBOutlet weak var StarBtn: UIButton!
    @IBOutlet weak var OffBtn: UIButton!
    @IBOutlet weak var Rate: UILabel!
    
    var count = 0
    
    var Biz:HomeBiz!
    {
        didSet
        {
            UpdateUI()
        }
    }
    
    func UpdateUI()
    {
        //BizImage1.image = UIImage(named: "26")
        //getImageURLS()
    }
    
    override func layoutSubviews()
    {
        x()
        print("layoutSubviews")
    }
    
    func x()
    {
        StarBtn.enabled = false
        OffBtn.enabled = false
        
        if self.Biz.off == "0" {
            
            OffBtn.setImage(UIImage(named: "noOff"), forState: UIControlState.Normal)
        }
        else
        {
            OffBtn.setImage(UIImage(named: "percentage"), forState: UIControlState.Normal)
        }
        
        if favorites.count > 0 {
            
            if favorites.contains(Biz.id) {
                
                FavBtn.setImage(UIImage(named: "favorite_set"), forState: UIControlState.Normal)
            }
            else
            {
                FavBtn.setImage(UIImage(named: "main_fav"), forState: UIControlState.Normal)
            }
        }
        else
        {
            FavBtn.setImage(UIImage(named: "main_fav"), forState: UIControlState.Normal)
        }

        if Biz.Special == "0"
        {
            //IsTop.hidden = true
            StarBtn.setImage(UIImage(named: "special"), forState: UIControlState.Normal)
        }
        else{
            
            //IsTop.hidden = false
            StarBtn.setImage(UIImage(named: "notSpecial"), forState: UIControlState.Normal)
        }
        
        self.Rate.layer.cornerRadius = self.Rate.bounds.width / 2
        
        Rate.text = "\(Biz.Rate)"
        
        self.Rate.textColor = UIColor.whiteColor()
        
        if Biz.Rate == 0
        {
            Rate.text = "-/-"
            Rate.textColor = UIColor.grayColor()
        }

        
        if Biz.Rate >= 7 {
            
            
            self.Rate.layer.backgroundColor = UIColor(red: 113/255 , green: 218/255 , blue: 62/255, alpha: 1).CGColor
            //self.BizRateView.layer.borderColor = UIColor.greenColor().CGColor
        }
        else if Biz.Rate >= 5 && Biz.Rate < 7
        {
            
            self.Rate.layer.backgroundColor = UIColor(red: 255/255, green: 242/255, blue: 0/255, alpha: 1).colorWithAlphaComponent(1).CGColor
            //self.BizRateView.layer.borderColor = UIColor.yellowColor().CGColor
        }
        else if Biz.Rate >= 1 && Biz.Rate < 5
        {
            
            self.Rate.layer.backgroundColor = UIColor(red: 239/255, green: 52/255, blue: 62/255, alpha: 1).colorWithAlphaComponent(1).CGColor
            //self.BizRateView.layer.borderColor = UIColor.redColor().CGColor
        }
        
        BlurBackground.layer.cornerRadius = 12.0
        BlurBackground.layer.masksToBounds = true
        BlurBackground.layer.shadowColor = UIColor.blackColor().CGColor
        BlurBackground.layer.shadowOpacity = 0.5
        BlurBackground.alpha = 0.7
        BlurBackground.backgroundColor = UIColor.grayColor()
        
        if Biz.imageAdd == "eshop"
        {
            self.BizImage1.image = UIImage(named: "eshopCover")
            self.BizImage1.contentMode = UIViewContentMode.ScaleAspectFit
        }
        else if Biz.imageAdd == "local"
        {
            self.BizImage1.image = UIImage(named: "local2")
            //self.BizImage1.contentMode = UIViewContentMode.ScaleAspectFit
        }
    }
    
    func addBehavior (){
        print("Add all the behavior here")
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(BizHeader.setImages), name: "ImageURLSLoaded", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(BizHeader.LoadImagesDataError), name: "WithoutImagesURLSReciveData", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(BizHeader.LoadImagesResponseError), name: "WithoutImagesURLSReciveResponse", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(BizHeader.LoadImagesConnectionError), name: "GetImagesURLSServreConnectionProblem", object: nil)
        //NSNotificationCenter.defaultCenter().addObserver(self, selector: "LoadIcons", name: "LoadIcons", object: nil)
        
        //print("here init \(selectedBiz.id)")
        self.Biz = selectedBiz
        getImageURLS()
        //setImages()
    }
    
    deinit
    {
        
    }
    
    //Mark : get images and comments from server if biz is got from server (not local)
    func getImageURLS()
    {
        HomeBiz.getImageURLS(Biz.id)//result will notify...
    }
    
    func  setImages()
    {
        x()
        //if Biz.imageURLS.count > 3 {
            
            //self.BizMoreImageBtn.hidden = false
        //}
        
        print("Biz.imageURLS.count \(Biz.imageURLS.count)")
        
        if Biz.imageURLS.count > 0
        {
            if Biz.imageAdd == "eshop"
            {
                self.BizImage1.image = UIImage(named: "eshopCover")
                self.BizImage1.contentMode = UIViewContentMode.ScaleAspectFit
            }
            else if Biz.imageAdd == "local"
            {
                self.BizImage1.image = UIImage(named: "local2")
                self.BizImage1.contentMode = UIViewContentMode.ScaleAspectFit
            }
            else if Biz.imageURLS[0] == "default"
            {
                print("\(Biz.lat) \(Biz.long)")
                let URL:NSString =  "http://maps.googleapis.com/maps/api/staticmap?center=\(Biz.lat),\(Biz.long)&zoom=13&size=414x200&scale=false&maptype=roadmap&format=png&visual_refresh=true&markers=size:mid%7Ccolor:0x3F51B5%7Clabel:%7C\(Biz.lat),\(Biz.long)"
                let urlStr : NSString = URL.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
                
                let _url0 =  NSURL(string : urlStr as String)
                
                if let url0 = _url0 {
                    
                    let imageDownloader = dataDownloaderServiceTask(url: url0)
                    imageDownloader.Download({ (data) in
                        
                        let image = UIImage(data : data)
                        dispatch_async(dispatch_get_main_queue(), {
                            
                            self.BizImage1.image = image
                        })
                    })
                }
                
            }else
            {
                let _url0 =  NSURL(string : String.localizedStringWithFormat(URLS.Imagess , Biz.imageURLS[0]))
                
                if let url0 = _url0 {
                    
                    let imageDownloader = dataDownloaderServiceTask(url: url0)
                    imageDownloader.Download({ (data) in
                        
                        let image = UIImage(data : data)
                        dispatch_async(dispatch_get_main_queue(), {
                            
                            self.BizImage1.image = image
                        })
                    })
                }
            }
        }
        else if Biz.imageAdd == "eshop"
        {
            self.BizImage1.image = UIImage(named: "eshopCover")
            self.BizImage1.contentMode = UIViewContentMode.ScaleAspectFit
        }
        else if Biz.imageAdd == "local"
        {
            self.BizImage1.image = UIImage(named: "local2")
            self.BizImage1.contentMode = UIViewContentMode.ScaleAspectFit
        }
        else
        {
            print("\(Biz.lat) \(Biz.long)")
            let URL:NSString =  "http://maps.googleapis.com/maps/api/staticmap?center=\(Biz.lat),\(Biz.long)&zoom=13&size=414x200&scale=false&maptype=roadmap&format=png&visual_refresh=true&markers=size:mid%7Ccolor:0x3F51B5%7Clabel:%7C\(Biz.lat),\(Biz.long)"
            print(URL)

            let urlStr : NSString = URL.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
            
            let _url0 =  NSURL(string : urlStr as String)
            
            if let url0 = _url0 {
                
                let imageDownloader = dataDownloaderServiceTask(url: url0)
                imageDownloader.Download({ (data) in
                    
                    let image = UIImage(data : data)
                    dispatch_async(dispatch_get_main_queue(), {
                        
                        self.BizImage1.image = image
                    })
                })
            }
        }
        /*print("\(Biz.lat) \(Biz.long)")
        let URL:NSString =  "http://maps.googleapis.com/maps/api/staticmap?center=\(Double(Biz.lat)!)،\(Double(Biz.long)!)&zoom=13&scale=false&size=200x150&maptype=roadmap&format=png&visual_refresh=true&markers=size:mid%7Ccolor:0xff0000%7Clabel:1%7C\(Double(Biz.lat)!)،\(Double(Biz.long)!)"
        
        print(URL)
        let urlStr : NSString = URL.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
        
        let _url0 =  NSURL(string : urlStr as String)
        
        if let url0 = _url0 {
            
            let imageDownloader = dataDownloaderServiceTask(url: url0)
            imageDownloader.Download({ (data) in
                
                let image = UIImage(data : data)
                dispatch_async(dispatch_get_main_queue(), {
                    
                    self.BizImage1.image = image
                })
            })
        }*/

    }
    
    @IBAction func galleryCliecked(sender: AnyObject) {
        
        GalleryDelegate.moreImage(self)
    }
    
    @IBAction func favCliecked(sender: AnyObject) {
        
        if favorites.count > 0 {
            
            if favorites.contains(Biz.id) {
                
                FavBtn.setImage(UIImage(named: "main_fav"), forState: UIControlState.Normal)
                favorites.removeAtIndex(favorites.indexOf(Biz.id)!)//remove from db
                db.removeFavorite(Biz.id)
            }
            else
            {
                favorites.append(Biz.id)
                FavBtn.setImage(UIImage(named: "favorite_set"), forState: UIControlState.Normal)
                //add to db
                db.addFavorite(Biz.id)
            }
        }
        else
        {
            favorites.append(Biz.id)
            FavBtn.setImage(UIImage(named: "favorite_set"), forState: UIControlState.Normal)
            //add to db
            db.addFavorite(Biz.id)
        }

        GalleryDelegate._fav(self)
    }
    
    @IBAction func starCliecked(sender: AnyObject) {
        
        GalleryDelegate.star(self)
    }
    
    @IBAction func ofCliecked(sender: AnyObject) {
        
        GalleryDelegate.off(self)
    }
    
    func LoadImagesDataError() {
        
        
    }
    func LoadImagesResponseError() {
        
        
    }
    func LoadImagesConnectionError() {
        
        
    }
}
