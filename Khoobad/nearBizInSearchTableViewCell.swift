//
//  nearBizInSearchTableViewCell.swift
//  Khoobad
//
//  Created by Mehrshad Jalilmasir on 6/17/16.
//  Copyright © 2016 Mehrshad Jalilmasir. All rights reserved.
//

import UIKit
import CoreData
import MapKit

class nearBizInSearchTableViewCell: UITableViewCell {

        
        @IBOutlet weak var background: UIView!
        @IBOutlet weak var BizImage: UIImageView!
        @IBOutlet weak var IsTop: UIImageView!
        @IBOutlet weak var BizName: UILabel!
        @IBOutlet weak var BizDesc: UILabel!
        @IBOutlet weak var BizPhone: UILabel!
        @IBOutlet weak var BizAddress: UILabel!
        
    @IBOutlet weak var BizRate: UILabel!
    
        var homeBiz : HomeBiz!
            {
            didSet {
            self.updateUI()
            }
        }
        
        private func updateUI()
        {
            background.backgroundColor = UIColor.whiteColor()
            background.layer.cornerRadius = 3.0
            background.layer.masksToBounds = false
            background.layer.shadowColor = UIColor.blackColor().colorWithAlphaComponent(0.5).CGColor
            background.layer.shadowOffset = CGSize(width: 0, height: 0)
            background.layer.shadowOpacity = 0.8
            
            BizImage.layer.cornerRadius = 10
            BizImage.clipsToBounds = true
            BizImage.layer.borderWidth = 0.5
            BizImage.layer.borderColor = UIColor.clearColor().CGColor
            
            if homeBiz.Special == "0"
            {
                //IsTop.hidden = true
                IsTop.image = UIImage()
            }
            else{
                
                //IsTop.hidden = false
                IsTop.image = UIImage(named: "notSpecial")
                background.layer.shadowColor = UIColor.blackColor().colorWithAlphaComponent(1).CGColor
            }
            BizName.text = homeBiz.name
            BizDesc.text = homeBiz.desc
            if homeBiz.desc == ""{
                
                BizDesc.text = "-"
            }
            //let locationBiz = CLLocation(latitude: Double(user.lat), longitude: Double(user.long))
            //print("biz \(Double(self.homeBiz.lat)) \(Double(self.homeBiz.long))")
            //let locationUser = CLLocation(latitude: Double(self.homeBiz.lat)!, longitude: Double(self.homeBiz.long)!)
            //print("user \(Double(self.homeBiz.lat)) \(Double(self.homeBiz.long))")
            //let distance = locationUser.distanceFromLocation(locationBiz)
            
            if self.homeBiz.distance < 1000
            {
                BizPhone.text = "\(String(format: "%.1f" , self.homeBiz.distance)) متر"
            }
            else
            {
                BizPhone.text = "\(String(format: "%.1f" , self.homeBiz.distance/1000)) کیلومتر"
            }

            BizAddress.text = homeBiz.address
            
            self.BizRate.layer.cornerRadius = self.BizRate.bounds.width / 2
            
            BizRate.text = "\(homeBiz.Rate)"
            
            self.BizRate.textColor = UIColor.whiteColor()
            
            if homeBiz.imageAdd == "default" && !_NOP{
                
                let URL:NSString =  "http://maps.googleapis.com/maps/api/staticmap?center=\(homeBiz.lat),\(homeBiz.long)8&zoom=13&size=144x144&scale=false&maptype=roadmap&format=png&visual_refresh=true&markers=size:mid%7Ccolor:0x3F51B5%7Clabel:%7C\(homeBiz.lat),\(homeBiz.long)"
                let urlStr : NSString = URL.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
                print(URL)
                
                let _url0 =  NSURL(string : urlStr as String)
                
                if let url0 = _url0 {
                    
                    let imageDownloader = dataDownloaderServiceTask(url: url0)
                    imageDownloader.Download({ (data) in
                        
                        let image = UIImage(data : data)
                        dispatch_async(dispatch_get_main_queue(), {
                            
                            self.BizImage.image = image
                        })
                    })
                }
            }
            else if homeBiz.imageAdd == "eshop"
            {
                self.BizImage.image = UIImage(named: "eshop1")
            }
            else if homeBiz.imageAdd == "local"
            {
                self.BizImage.image = UIImage(named: "local1")
            }
            else if homeBiz.imageAdd != "" && !_NOP{
                
                let _url =  NSURL(string : String.localizedStringWithFormat(URLS.Imagess, homeBiz.imageAdd))
                print(_url)
                
                if let url = _url {
                    
                    let imageDownloader = dataDownloaderServiceTask(url: url)
                    imageDownloader.Download({ (data) in
                        
                        let image = UIImage(data : data)
                        dispatch_async(dispatch_get_main_queue(), {
                            
                            self.BizImage.image = image
                        })
                    })
                }
            }
            /*else if reachabilityStatus == KNOTREACHABLE
            {
                let tmp = BizImage.frame.origin as CGPoint
                self.BizImage.frame = CGRectMake(tmp.x, tmp.y, 32, 32)
                self.BizImage.image = UIImage(named: homeBiz.categories[0])
                NSNotificationCenter.defaultCenter().postNotificationName("reloadNearestTableView", object: nil)
            }*/
            else
            {
                self.BizImage.image = UIImage(named: "default_image")
            }
            
            
            if homeBiz.Rate >= 7 {
                
                
                self.BizRate.layer.backgroundColor = UIColor(red: 113/255 , green: 218/255 , blue: 62/255, alpha: 1).CGColor
                //self.BizRateView.layer.borderColor = UIColor.greenColor().CGColor
            }
            else if homeBiz.Rate >= 5 && homeBiz.Rate < 7
            {
                
                self.BizRate.layer.backgroundColor = UIColor(red: 242/255, green: 231/255, blue: 0/255, alpha: 1).colorWithAlphaComponent(1).CGColor
                //self.BizRateView.layer.borderColor = UIColor.yellowColor().CGColor
            }
            else if homeBiz.Rate >= 1 && homeBiz.Rate < 5
            {
                
                self.BizRate.layer.backgroundColor = UIColor(red: 239/255, green: 52/255, blue: 62/255, alpha: 1).colorWithAlphaComponent(1).CGColor
                //self.BizRateView.layer.borderColor = UIColor.redColor().CGColor
            }
            else
            {
                BizRate.text = "-/-"
                BizRate.textColor = UIColor.grayColor()
                self.BizRate.layer.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1).colorWithAlphaComponent(1).CGColor
            }
    }
}
