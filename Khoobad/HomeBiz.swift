//
//  HomeBiz.swift
//  Khoobad
//
//  Created by Mehrshad Jalilmasir on 6/7/16.
//  Copyright © 2016 Mehrshad Jalilmasir. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import HomeKit

class HomeBiz: NSObject {
    
    var isFullLoaded: Bool = false//just certain that is loaded full from db or should got from net
    var Rate = -1.0
    var imageURLS = [String]()
    var imageURLSGOT = false
    var Comments = [Int : HomeBizComment]()
    var CommentsIDS = [Int]()
    var CommentsPageCount = 0
    var currentPage = 1
    var CommentsGOT = false//we have read page = 0 get from current page if loading more
    var id:Int = 0
    var uuid:String = ""
    var category_id:Int = 0
    var name:String = ""
    var address:String = ""
    var phone:String = ""
    var lat:String = ""
    var long:String = ""
    var desc:String = ""
    var slogan:String = ""
    var created_at:String = ""
    var updated_at:String = ""
    var imageAdd:String = ""
    var Special = "0"
    var off = "0"
    var distance:Double = 0.0
    var categories = [String]()
    
    init(id:Int  , uuid:String , category_id:Int , name:String , address:String , phone:String , lat:String , long:String , desc :String , slogan:String , created_at:String , updated_at:String , image : String , fullyLoad: Bool , Rate:Double , ImageURLS:[String] , ImageURLSGot:Bool , Comments:[Int : HomeBizComment] , CommentsIDS:[Int] , CommentsGOT:Bool , CommentsPageCount:Int , Special:String , off:String , distance:Double , categories:[String]) {
        
        self.id = id
        self.uuid = uuid
        self.category_id = category_id
        self.name = name
        self.address = address
        self.phone = phone
        self.lat = lat
        self.long = long
        self.desc = desc
        self.slogan = slogan
        self.created_at = created_at
        self.updated_at = updated_at
        self.imageAdd = image
        self.isFullLoaded = fullyLoad
        self.Rate = Rate
        self.imageURLS = ImageURLS
        self.imageURLSGOT = ImageURLSGot
        //image will download in Cell view Class for each item
        self.Comments = Comments
        self.CommentsGOT = CommentsGOT
        self.CommentsPageCount = CommentsPageCount
        self.Special = Special
        self.off = off
        self.distance = distance
        self.categories = categories
    }
    
    //with rest api---->getting Home Bizes
    class func getBizes(lat:CLLocationDegrees , long:CLLocationDegrees , NetOrLoc:Bool)
    {
        var bizes = [Int : HomeBiz]()
        var bizesIDS = [Int]()
        var status = ""
        var count = 0
        //var distance = 0
        
        //NSNotificationCenter.defaultCenter().postNotificationName("HomeLoadingIndicator", object: nil)
        
        if NetOrLoc{//isFullLoaded = false for each
            
            let URL:NSURL = NSURL(string: String.localizedStringWithFormat(URLS.HomeBiz , "\(lat)" , "\(long)"))!
            let HomeBizRequest : NSURLRequest = NSURLRequest(URL: URL)
            
            print(URL)
            
            NSURLConnection.sendAsynchronousRequest(HomeBizRequest, queue: NSOperationQueue.mainQueue(), completionHandler: { (response , data , error) in
                
                //NSNotificationCenter.defaultCenter().postNotificationName("HomedisLoadingIndicator", object: nil)
                
                if data == nil{
                    
                    //ui error or change to local
                    NSNotificationCenter.defaultCenter().postNotificationName("WithoutBizesReciveData", object: nil)
                    
                    return
                }
                    
                guard let httpResponse = response as? NSHTTPURLResponse
                    else
                {
                    //ui error or change to local
                    NSNotificationCenter.defaultCenter().postNotificationName("WithoutReciveBizesResponse", object: nil)
                    
                    return
                }
                
                if httpResponse.statusCode < 200 || httpResponse.statusCode >= 300 //|| httpResponse.MIMEType == "application/json"
                {
                    //ui error or change to local
                    NSNotificationCenter.defaultCenter().postNotificationName("GetBizesServreConnectionProblem", object: nil)
        
                    return
                }
                
                let Bizes = try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions())
                
                //print(Bizes)
                /*print((Bizes["count"] as! Int))
                print((Bizes["distance"] as! Int))
                print((Bizes["status"] as! String))
                print((Bizes["places"] as! [NSObject]))*/
                
                count = (Bizes["count"] as! Int)
                //distance = (Bizes["distance"] as! Int)
                status = (Bizes["status"] as! String)
                let places = (Bizes["places"] as! [NSObject])
                
                for object in places{
                    
                    guard let ActualBiz = object as? [String : AnyObject] else
                    {
                        continue
                    }
                    
                    let id:String = ActualBiz["id"] as! String
                    let uuid:String = ActualBiz["uuid"] as! String
                    //let category_id:Int = ActualBiz["uuid:String"] as! Int
                    let name:String = ActualBiz["name"] as! String
                    let address:String = ActualBiz["address"] as! String
                    let phone:String = ActualBiz["phone"] as! String
                    let lat:String = ActualBiz["lat"] as! String
                    let long:String = ActualBiz["long"] as! String
                    let desc:String = ActualBiz["desc"] as! String
                    let slogan:String = ActualBiz["slogan"]as! String
                    var image:String = ActualBiz["image"]as! String
                    let rate:Double = ActualBiz["rate"]as! Double
                    let special:String = ActualBiz["special"]as! String
                    let off:String = ActualBiz["off"]as! String
                    
                    print(id)
                    //let created_at:String = ActualBiz["created_at"] as! String
                    //let updated_at:String = ActualBiz["updated_at"] as! String
                    
                    let locationBiz = CLLocation(latitude: Double(user.lat), longitude: Double(user.long))
                    //print("biz \(Double(self.homeBiz.lat)) \(Double(self.homeBiz.long))")
                    let locationUser = CLLocation(latitude: Double(lat)!, longitude: Double(long)!)
                    //print("user \(Double(self.homeBiz.lat)) \(Double(self.homeBiz.long))")
                    var distance:Double = locationUser.distanceFromLocation(locationBiz)
                    
                    if (lat == "0" && long == "0")
                    {
                        distance = 0.0
                        image = "eshop"
                    }
                    
                    let biz = HomeBiz(id: Int(id)!, uuid: uuid, category_id: 0, name: name, address: address, phone: phone, lat: lat, long: long, desc: desc, slogan: slogan, created_at: "", updated_at: "" , image: image , fullyLoad: false , Rate: rate , ImageURLS: [], ImageURLSGot: false , Comments: [:] , CommentsIDS: [] , CommentsGOT: false , CommentsPageCount: 0 , Special: special , off: off , distance: distance , categories: [])
                    
                    bizes[Int(id)!] = biz
                    
                    if bizesIDS.count > 0
                    {
                        if !bizesIDS.contains(Int(id)!)
                        {
                            bizesIDS.append(Int(id)!)
                        }
                    }
                    else{
                        
                        bizesIDS.append(Int(id)!)
                    }
                }
                
                HomeBizes =  HomeBizResults(HomeBizes: bizes , HomeBizesIDS: bizesIDS , HomeBizesCount: count, HomeBizesDistance: 0, HomeBizesStatus: status)
                print("Home Biz Number : \(HomeBizes.HomeBizesCount)")
                NSNotificationCenter.defaultCenter().postNotificationName("reloadTableView", object: nil)
                
            })
        }
        else{//isFullLoaded = true for each item
            
            //local reading
            //NSNotificationCenter.defaultCenter().postNotificationName("HomedisLoadingIndicator", object: nil)
            print("loca reading DB")//type = 0
            readLocalAlgorithm(lat, long: long, type: 0)
        }
    }
    
    //with rest api---->getting comments and images
    class func getImageURLS(biz_id:Int)
    {
        //NSNotificationCenter.defaultCenter().postNotificationName("LoadIcons", object: nil)
        if(!selectedBiz.isFullLoaded && !_NOP)//from net
        {
            let URL:NSURL = NSURL(string: String.localizedStringWithFormat(URLS.BizImagess , "\(biz_id)"))!
            let HomeBizRequest : NSURLRequest = NSURLRequest(URL: URL)
            
            print(URL)
            
            NSURLConnection.sendAsynchronousRequest(HomeBizRequest, queue: NSOperationQueue.mainQueue(), completionHandler: { (response , data , error) in
                
                if (pagingType == 0){ HomeBizes.HomeBizesArr[biz_id]!.imageURLSGOT = false}
                else if(pagingType == 1){nearestBizes[currentSelectedBizIndex].imageURLSGOT = false}
                else if(pagingType == 2){categorySearchResultBizes[currentSelectedBizIndex].imageURLSGOT = false}
                else if(pagingType == 3){
                    print(currentSelectedBizIndex)
                    print(KojaList.count)
                    KojaList[currentSelectedBizIndex].imageURLSGOT = false}
                else if(pagingType == 4 && simpleBizes.count > currentSelectedBizIndex){
                    print(currentSelectedBizIndex)
                    //print(KojaList.count)
                    simpleBizes[currentSelectedBizIndex].imageURLSGOT = false}
                
                if data == nil{
                    
                    //ui error or change to local
                    NSNotificationCenter.defaultCenter().postNotificationName("WithoutImagesURLSReciveData", object: nil)
                    return
                }
                
                guard let httpResponse = response as? NSHTTPURLResponse
                    else
                {
                    //ui error or change to local
                    NSNotificationCenter.defaultCenter().postNotificationName("WithoutImagesURLSReciveResponse", object: nil)
                    
                    return
                }
                
                if httpResponse.statusCode < 200 || httpResponse.statusCode >= 300 //|| httpResponse.MIMEType == "application/json"
                {
                    //ui error or change to local
                    NSNotificationCenter.defaultCenter().postNotificationName("GetImagesURLSServreConnectionProblem", object: nil)
                    
                    return
                }
                
                let BizImageURLS = try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions())
                
                if(pagingType == 0){HomeBizes.HomeBizesArr[biz_id]!.imageURLSGOT = false}
                else if(pagingType == 1){nearestBizes[currentSelectedBizIndex].imageURLSGOT = false}
                else if(pagingType == 2){categorySearchResultBizes[currentSelectedBizIndex].imageURLSGOT = false}
                else if(pagingType == 3){KojaList[currentSelectedBizIndex].imageURLSGOT = false}
                else if(pagingType == 4 && simpleBizes.count > currentSelectedBizIndex){simpleBizes[currentSelectedBizIndex].imageURLSGOT = false}
                
                let urls = (BizImageURLS["data"] as! [NSObject])
                
                if(pagingType == 0){
                    (HomeBizes.HomeBizesArr[biz_id]!.imageURLS) = [String]()
                }
                else if(pagingType == 1){
                    nearestBizes[currentSelectedBizIndex].imageURLS = [String]()
                    }
                else if(pagingType == 2){
                    categorySearchResultBizes[currentSelectedBizIndex].imageURLS = [String]()
                    }
                else if(pagingType == 3){
                    KojaList[currentSelectedBizIndex].imageURLS = [String]()
                }else if(pagingType == 4 && simpleBizes.count > currentSelectedBizIndex){
                    simpleBizes[currentSelectedBizIndex].imageURLS = [String]()
                }
                
                for object in urls{
                    
                    guard let actualUrl = object as? [String : AnyObject] else
                    {
                        continue
                    }
                    let url:String = actualUrl["url"] as! String
                    
                    if(pagingType == 0){
                        
                        (HomeBizes.HomeBizesArr[biz_id]!.imageURLS).append(url)}
                    else if(pagingType == 1){
                        
                        nearestBizes[currentSelectedBizIndex].imageURLS.append(url)}
                    else if(pagingType == 2){
                        
                        categorySearchResultBizes[currentSelectedBizIndex].imageURLS.append(url)}
                    else if(pagingType == 3){
                        
                        KojaList[currentSelectedBizIndex].imageURLS.append(url)}
                    else if(pagingType == 4 && simpleBizes.count > currentSelectedBizIndex){
                        
                        simpleBizes[currentSelectedBizIndex].imageURLS.append(url)}
                    print(url)
                }
                NSNotificationCenter.defaultCenter().postNotificationName("ImageURLSLoaded", object: nil)
            })
        }
        else{
            
            //loading local -- > defaults
            //NSNotificationCenter.defaultCenter().postNotificationName("ImageURLSLoaded", object: nil)
        }
    }
    
    //with rest api---->getting Home Bizes
    class func getNearestHomeBizes(lat:CLLocationDegrees , long:CLLocationDegrees , NetOrLoc:Bool)
    {
        var bizes = [HomeBiz]()
        
        //NSNotificationCenter.defaultCenter().postNotificationName("HomeLoadingIndicator", object: nil)
        
        if NetOrLoc {//isFullLoaded = false for each
            
            let URL:NSURL = NSURL(string: String.localizedStringWithFormat(URLS.nearestBizes , "\(lat)" , "\(long)"))!
            let HomeBizRequest : NSURLRequest = NSURLRequest(URL: URL)
            
            print(URL)
            
            NSURLConnection.sendAsynchronousRequest(HomeBizRequest, queue: NSOperationQueue.mainQueue(), completionHandler: { (response , data , error) in
                
                //NSNotificationCenter.defaultCenter().postNotificationName("HomedisLoadingIndicator", object: nil)
                
                if data == nil{
                    
                    //ui error or change to local
                    NSNotificationCenter.defaultCenter().postNotificationName("WithoutNearestReciveData", object: nil)
                    
                    return
                }
                
                guard let httpResponse = response as? NSHTTPURLResponse
                    else
                {
                    //ui error or change to local
                    NSNotificationCenter.defaultCenter().postNotificationName("WithoutReciveNearestResponse", object: nil)
                    
                    return
                }
                
                if httpResponse.statusCode < 200 || httpResponse.statusCode >= 300 //|| httpResponse.MIMEType == "application/json"
                {
                    //ui error or change to local
                    NSNotificationCenter.defaultCenter().postNotificationName("GetNearestServreConnectionProblem", object: nil)
                    
                    return
                }
                
                let Bizes = try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions())
                
                print(Bizes)
                let places = (Bizes["places"] as! [NSObject])
                
                for object in places{
                    
                    guard let ActualBiz = object as? [String : AnyObject] else
                    {
                        continue
                    }
                    
                    let id:Int = ActualBiz["id"] as! Int
                    let uuid:String = ActualBiz["uuid"] as! String
                    //let category_id:Int = ActualBiz["uuid:String"] as! Int
                    let name:String = ActualBiz["name"] as! String
                    let address:String = ActualBiz["address"] as! String
                    let phone:String = ActualBiz["phone"] as! String
                    let lat:String = ActualBiz["lat"] as! String
                    let long:String = ActualBiz["long"] as! String
                    let desc:String = ActualBiz["desc"] as! String
                    let slogan:String = ActualBiz["slogan"]as! String
                    var image:String = ActualBiz["image"]as! String
                    var rate:Double = ActualBiz["rate"]as! Double
                    let special:String = ActualBiz["special"]as! String
                    let off:String = ActualBiz["off"]as! String
                    
                    if rate == -1
                    {
                        rate = -1.0
                    }
                    
                    print(id)
                    //let created_at:String = ActualBiz["created_at"] as! String
                    //let updated_at:String = ActualBiz["updated_at"] as! String
                    
                    let locationBiz = CLLocation(latitude: Double(user.lat), longitude: Double(user.long))
                    //print("biz \(Double(self.homeBiz.lat)) \(Double(self.homeBiz.long))")
                    let locationUser = CLLocation(latitude: Double(lat)!, longitude: Double(long)!)
                    //print("user \(Double(self.homeBiz.lat)) \(Double(self.homeBiz.long))")
                    var distance:Double = locationUser.distanceFromLocation(locationBiz)
                    
                    if (lat == "0" && long == "0")
                    {
                        distance = 0.0
                        image = "eshop"
                    }
                    
                    let biz = HomeBiz(id: id, uuid: uuid, category_id: 0, name: name, address: address, phone: phone, lat: lat, long: long, desc: desc, slogan: slogan, created_at: "", updated_at: "" , image: image , fullyLoad: false , Rate: rate , ImageURLS: [], ImageURLSGot: false , Comments: [:] , CommentsIDS: [] , CommentsGOT: false , CommentsPageCount: 0 , Special: special , off: off , distance: distance , categories: [])
                    
                    bizes.append(biz)
                }
                nearestBizes = bizes
                NSNotificationCenter.defaultCenter().postNotificationName("reloadNearestTableView", object: nil)
            })
        }
        else{//isFullLoaded = true for each item
            
            //local reading
            //NSNotificationCenter.defaultCenter().postNotificationName("HomedisLoadingIndicator", object: nil)
            print("loca reading DB")//type = 1
            readLocalAlgorithm(lat, long: long, type: 1)
        }
    }
    
    class func readLocalAlgorithm(lat:CLLocationDegrees , long:CLLocationDegrees , type:Int)
    {
        dispatch_async(dispatch_get_main_queue(), {
            
            
            if dbRates.count == 0 {
                
                if dbLines.count == 0 {
                    
                    if db.getOstanRatesRecord(user.lat, long: user.long).count > 0 {
                        
                        dbRatesLines = (db.getOstanRatesRecord(user.lat, long: user.long)[0].valueForKey("ratesText") as! String).componentsSeparatedByString("\n")
                    }
                }
                for rate in dbRatesLines
                {
                    dbRates.append(rate.componentsSeparatedByString("\t"))
                }
            }
            if dbBizes.count == 0 {
                
                if dbLines.count == 0 {
                    
                    if db.getLocalDBPath() != "" {
                        
                        dbLines = db.getLocalDBPath().componentsSeparatedByString("\n")
                    }
                }
                for line in dbLines {
                    
                    dbBizes.append(line.componentsSeparatedByString("\t"))
                }
            }
            
            if dbBizes.count == 0 {
                
                return
            }
            
            if  type == 0 {//150 Meters
                
                var Bizes = [Int : HomeBiz]()
                var bizesIDS = [Int]()
                let status = "1"
                var count = 0
                let distance = 15
                
                for biz in dbBizes {
                    
                    
                    if biz.count < 6 {
                        
                        continue
                    }
                    
                    //print(biz.componentsSeparatedByString("\t"))
                    
                    let lat = Double(biz[1])
                    let long = Double(biz[2])
                    
                    let locationUser = CLLocation(latitude: Double(user.lat), longitude: Double(user.long))
                    //print("biz \(Double(self.homeBiz.lat)) \(Double(self.homeBiz.long))")
                    let locationBiz = CLLocation(latitude: lat!, longitude: long!)
                    //print("user \(Double(self.homeBiz.lat)) \(Double(self.homeBiz.long))")
                    let distance = locationUser.distanceFromLocation(locationBiz)
                    
                    if distance <= 350 {
                        
                        let name = biz[3]
                        let phone = biz[4]
                        let id = Int(biz[0])
                        
                        let cats = biz[5].componentsSeparatedByString(",")
                        
                        let locationBiz = CLLocation(latitude: Double(user.lat), longitude: Double(user.long))
                        //print("biz \(Double(self.homeBiz.lat)) \(Double(self.homeBiz.long))")
                        let locationUser = CLLocation(latitude: Double(lat!), longitude: Double(long!))
                        //print("user \(Double(self.homeBiz.lat)) \(Double(self.homeBiz.long))")
                        var distance:Double = locationUser.distanceFromLocation(locationBiz)
                        var image = ""
                        
                        if (lat == 0 && long == 0)
                        {
                            distance = 0.0
                            image = "eshop"
                        }
                        
                        var rate = -1.0
                        if dbRates.count > 0
                        {
                            for _rate in dbRates
                            {
                                if Int(_rate[0]) == id{
                                    
                                    rate = Double(_rate[1])!
                                }
                            }
                        }
                        
                        let _biz = HomeBiz(id: id!, uuid: "", category_id: 0, name: name, address: "-", phone: phone, lat: String(lat!), long: String(long!), desc: "-", slogan: "-", created_at: "", updated_at: "" , image: image , fullyLoad: true , Rate: rate , ImageURLS: [], ImageURLSGot: false , Comments: [:] , CommentsIDS: [] , CommentsGOT: false , CommentsPageCount: 0 , Special: "0" , off: "0" , distance: distance , categories: cats)
                        
                        Bizes[id!] = _biz
                        
                        if bizesIDS.count > 0
                        {
                            if !bizesIDS.contains(id!)
                            {
                                bizesIDS.append(id!)
                            }
                        }
                        else{
                            
                            bizesIDS.append(id!)
                        }
                        count = count + 1
                        
                        if count > 15
                        {
                            break
                        }
                    }
                }
                
                HomeBizes =  HomeBizResults(HomeBizes: Bizes , HomeBizesIDS: bizesIDS , HomeBizesCount: count, HomeBizesDistance: distance, HomeBizesStatus: status)
                NSNotificationCenter.defaultCenter().postNotificationName("reloadTableView", object: nil)
            }
            else if type == 1//Closest five
            {
                var Bizes = [HomeBiz]()
                
                for biz in dbBizes {
                    
                    if biz.count < 6 {
                        
                        continue
                    }
                    
                    let lat = Double(biz[1])
                    let long = Double(biz[2])
                    
                    let locationUser = CLLocation(latitude: Double(user.lat), longitude: Double(user.long))
                    //print("biz \(Double(self.homeBiz.lat)) \(Double(self.homeBiz.long))")
                    let locationBiz = CLLocation(latitude: lat!, longitude: long!)
                    //print("user \(Double(self.homeBiz.lat)) \(Double(self.homeBiz.long))")
                    let distance = locationUser.distanceFromLocation(locationBiz)
                    
                    if distance <= 350 {
                        
                        let name = biz[3]
                        let phone = biz[4]
                        let id = Int(biz[0])
                        
                        let locationBiz = CLLocation(latitude: Double(user.lat), longitude: Double(user.long))
                        //print("biz \(Double(self.homeBiz.lat)) \(Double(self.homeBiz.long))")
                        let locationUser = CLLocation(latitude: lat!, longitude: long!)
                        //print("user \(Double(self.homeBiz.lat)) \(Double(self.homeBiz.long))")
                        var distance:Double = locationUser.distanceFromLocation(locationBiz)
                        var image = ""
                        
                        if (lat == 0 && long == 0)
                        {
                            distance = 0.0
                            image = "eshop"
                        }
                        else
                        {
                            image = "local"
                        }
                        
                        let cats = biz[5].componentsSeparatedByString(",")
                        
                        var rate = -1.0
                        if dbRates.count > 0
                        {
                            for _rate in dbRates
                            {
                                if Int(_rate[0]) == id{
                                    
                                    rate = Double(_rate[1])!
                                }
                            }
                        }
                        
                        let _biz = HomeBiz(id: id!, uuid: "", category_id: 0, name: name, address: "-", phone: phone, lat: String(lat!), long: String(long!), desc: "-", slogan: "-", created_at: "", updated_at: "" , image: image , fullyLoad: true , Rate: rate , ImageURLS: [], ImageURLSGot: false , Comments: [:] , CommentsIDS: [] , CommentsGOT: false , CommentsPageCount: 0 , Special: "0" , off: "0" , distance: distance , categories: cats)
                        Bizes.append(_biz)
                        
                        if Bizes.count > 30
                        {
                            break
                        }
                    }
                }
                
                var i = 0
                var j = 0
                
                for _ in Bizes
                {
                    for _ in Bizes
                    {
                        if i != j
                        {
                            if Bizes[i].distance < Bizes[j].distance
                            {
                                //swap(&Bizes[bizesIDS[i]], &Bizes[bizesIDS[j]])
                                swap(&Bizes[i], &Bizes[j])
                            }
                        }
                        j = j + 1
                    }
                    
                    j = 0
                    i = i + 1
                }
                
                nearestBizes = Bizes
                NSNotificationCenter.defaultCenter().postNotificationName("reloadNearestTableView", object: nil)
            }
        })
    }
}
