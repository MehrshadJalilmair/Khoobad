//
//  simpleBizs.swift
//  Khoobad
//
//  Created by Mehrshad Jalilmasir on 7/20/16.
//  Copyright © 2016 Mehrshad Jalilmasir. All rights reserved.
//

import UIKit
import MapKit

var simpleBizes:[HomeBiz] = [HomeBiz]()

class simpleBizs: UIViewController {

    @IBOutlet var tableView: UITableView!
    @IBOutlet var waitingIndicator: UIActivityIndicatorView!
    var firstLoad = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(simpleBizs.reachabilityStatusChanged), name: "ReachStatusChanged" , object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(simpleBizs.popToRoot), name: "popToRoot", object: nil)
        if let font = UIFont(name: "B Yekan", size: 15) {
            
            self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName :font , NSForegroundColorAttributeName: UIColor.whiteColor()]
        }
        tableView.separatorStyle = .None
        navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.Plain, target:nil, action:nil)
        
        if simpleBizesORFavs {
            
            getSimpleBizs()
        }
        else
        {
            self.navigationItem.title = "لیست علاقه مندی ها"
            if favorites.count > 0
            {
                getFavorits()
            }
        }
    }
    override func viewWillAppear(animated: Bool) {
        
        firstLoad = firstLoad + 1
        
        self.tableView.reloadData()
        if favorites.count > simpleBizes.count && !simpleBizesORFavs && firstLoad > 1
        {
            if favorites.count > 0
            {
                getFavorits()
            }
        }
    }
    func reachabilityStatusChanged()
    {
        if reachabilityStatus == KNOTREACHABLE {
            
            
        }
        else if reachabilityStatus == KREACHABLEWITHWWAN {
            
            
        }
        else if reachabilityStatus == KREACHABLEWITHWIFI {
            
            
        }
        print("\(reachabilityStatus)")
        if simpleBizesORFavs {
            
            getSimpleBizs()
        }
        else
        {
            getFavorits()
        }
    }
    func getSimpleBizs()
    {
        waitingIndicator.startAnimating()
        if (reachabilityStatus != KNOTREACHABLE && !_NOP){
            
            let URL:NSURL = NSURL(string: String.localizedStringWithFormat(URLS.similar_biz, "\(selectedBiz.id)"))!
            let BizRequest : NSURLRequest = NSURLRequest(URL: URL)
            
            print(URL)
            
            NSURLConnection.sendAsynchronousRequest(BizRequest, queue: NSOperationQueue.mainQueue(), completionHandler: { (response , data , error) in
                
                //NSNotificationCenter.defaultCenter().postNotificationName("HomedisLoadingIndicator", object: nil)
                
                
                if data == nil{
                    
                    //ui error or change to loca
                    self.waitingIndicator.stopAnimating()
                    return
                }
                
                guard let httpResponse = response as? NSHTTPURLResponse
                    else
                {
                    self.waitingIndicator.stopAnimating()
                    //ui error or change to local
                    return
                }
                
                if httpResponse.statusCode < 200 || httpResponse.statusCode >= 300 //|| httpResponse.MIMEType == "application/json"
                {
                    self.waitingIndicator.stopAnimating()
                    //ui error or change to local
                    return
                }
                
                let Bizes = try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions()) as! [NSObject]
                
                print(Bizes)
                
                //KojaList = [HomeBiz]()
                simpleBizes = [HomeBiz]()
                
                for object in Bizes
                {
                    print(object)
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
                    let image:String = ActualBiz["image"]as! String
                    let rate:Double = ActualBiz["rate"]as! Double
                    let special:String = ActualBiz["special"]as! String
                    let off:String = ActualBiz["off"]as! String
                    
                    //print(ActualBiz)
                    //let created_at:String = ActualBiz["created_at"] as! String
                    //let updated_at:String = ActualBiz["updated_at"] as! String
                    
                    let locationBiz = CLLocation(latitude: Double(user.lat), longitude: Double(user.long))
                    //print("biz \(Double(self.homeBiz.lat)) \(Double(self.homeBiz.long))")
                    let locationUser = CLLocation(latitude: Double(lat)!, longitude: Double(long)!)
                    //print("user \(Double(self.homeBiz.lat)) \(Double(self.homeBiz.long))")
                    let distance:Double = locationUser.distanceFromLocation(locationBiz)
                    
                    let biz = HomeBiz(id: Int(id)!, uuid: uuid, category_id: 0, name: name, address: address, phone: phone, lat: lat, long: long, desc: desc, slogan: slogan, created_at: "", updated_at: "" , image: image , fullyLoad: false , Rate: rate , ImageURLS: [], ImageURLSGot: false , Comments: [:] , CommentsIDS: [] , CommentsGOT: false , CommentsPageCount: 0 , Special: special , off: off , distance: distance , categories: [])
                    
                    simpleBizes.append(biz)
                }
                self.waitingIndicator.stopAnimating()
                self.tableView.reloadData()
            })
            
        }
        else //isFullLoaded = true for each item
        {
            //local reading
            //NSNotificationCenter.defaultCenter().postNotificationName("HomedisLoadingIndicator", object: nil)
        }
    }
    func getFavorits()
    {
        waitingIndicator.startAnimating()
        if (reachabilityStatus != KNOTREACHABLE && !_NOP){
            
            simpleBizes.removeAll()
            self.tableView.reloadData()
            
            for biz_id in favorites {
                
                //print(biz_id)
                let url = NSURL(string: String.localizedStringWithFormat(URLS.bizdetail , "\(biz_id)"))
                let request = NSMutableURLRequest(URL: url!)
                
                let session = NSURLSession.sharedSession()
                let task = session.dataTaskWithRequest(request) {
                    (
                    let data, let response, let error) in
                    
                    if data == nil{
                        
                        self.waitingIndicator.stopAnimating()
                        return
                    }
                    
                    guard let httpResponse = response as? NSHTTPURLResponse
                        else
                    {
                        self.waitingIndicator.stopAnimating()
                        return
                    }
                    
                    if httpResponse.statusCode < 200 || httpResponse.statusCode >= 300 //|| httpResponse.MIMEType == "application/json"
                    {
                        self.waitingIndicator.stopAnimating()
                        return
                    }
                    
                    let ActualBiz = try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions())
                    //print(ActualBiz)
                    
                    let id:Int = ActualBiz["id"] as! Int
                    //let uuid:String = ActualBiz["uuid"] as! String
                    //let category_id:Int = ActualBiz["uuid:String"] as! Int
                    let name:String = ActualBiz["name"] as! String
                    let address:String = ActualBiz["address"] as! String
                    let phone:String = ActualBiz["phone"] as! String
                    let lat:String = ActualBiz["lat"] as! String
                    let long:String = ActualBiz["long"] as! String
                    let desc:String = ActualBiz["desc"] as! String
                    let slogan:String = ActualBiz["slogan"]as! String
                    
                    
                    var image:String!
                    
                    if ActualBiz["image"] is NSNull
                    {
                        image = "default"
                    }
                    else
                    {
                        image = ActualBiz["image"] as! String
                    }
                    
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
                    
                    let biz = HomeBiz(id: id, uuid: "", category_id: 0, name: name, address: address, phone: phone, lat: lat, long: long, desc: desc, slogan: slogan, created_at: "", updated_at: "" , image: image , fullyLoad: false , Rate: rate , ImageURLS: [], ImageURLSGot: false , Comments: [:] , CommentsIDS: [] , CommentsGOT: false , CommentsPageCount: 0 , Special: special , off: off , distance: distance , categories: [])
                    
                    simpleBizes.append(biz)
                    dispatch_async(dispatch_get_main_queue(), {
                    
                        if simpleBizes.count == favorites.count
                        {
                            self.waitingIndicator.stopAnimating()
                        }
                        self.tableView.reloadData()
                    })
                }
                task.resume()
            }
        }
        else if (reachabilityStatus == KNOTREACHABLE || _NOP)
        {
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
            
            if dbBizes.count == 0 {//load db if not loaded yet
                
                if dbLines.count == 0 {
                    
                    if db.getLocalDBPath() != "" {
                        
                        dbLines = db.getLocalDBPath().componentsSeparatedByString("\n")
                    }
                }
                
                for line in dbLines {
                    
                    dbBizes.append(line.componentsSeparatedByString("\t"))
                }
            }
            simpleBizes.removeAll()
            self.tableView.reloadData()
            print("local reading DB")
            self.readFromLocal()
        }
    }
    func readFromLocal()
    {
        dispatch_async(dispatch_get_main_queue(), {
            
            if dbBizes.count == 0{
                
                return
            }
            
            simpleBizes = [HomeBiz]()
            
            for biz in dbBizes {
                
                if biz.count < 6 {
                    
                    continue
                }
                
                let id = Int(biz[0])
                
                if favorites.contains(id!){
                    
                    let lat = Double(biz[1])
                    let long = Double(biz[2])
                    let name = biz[3]
                    let phone = biz[4]
                    
                    
                    let locationBiz = CLLocation(latitude: Double(user.lat), longitude: Double(user.long))
                    //print("biz \(Double(self.homeBiz.lat)) \(Double(self.homeBiz.long))")
                    let locationUser = CLLocation(latitude: lat! , longitude: long!)
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
                    
                    let _biz = HomeBiz(id: id!, uuid: "", category_id: 0, name: name, address: "-", phone: phone, lat: String(lat!), long: String(long!), desc: "-", slogan: "-", created_at: "", updated_at: "" , image: image , fullyLoad: true , Rate: rate , ImageURLS: [], ImageURLSGot: false , Comments: [:] , CommentsIDS: [] , CommentsGOT: true , CommentsPageCount: 0 , Special: "0" , off: "0" , distance: distance , categories: cats)
                    
                    simpleBizes.append(_biz)
                }
            }
            
            var i = 0
            var j = 0
            
            for _ in simpleBizes
            {
                for _ in simpleBizes
                {
                    if i != j
                    {
                        if simpleBizes[i].distance < simpleBizes[j].distance
                        {
                            //swap(&Bizes[bizesIDS[i]], &Bizes[bizesIDS[j]])
                            swap(&simpleBizes[i], &simpleBizes[j])
                        }
                    }
                    j = j + 1
                }
                
                j = 0
                i = i + 1
            }
            
            self.waitingIndicator.stopAnimating()
            self.tableView.reloadData()
        })
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        
        return simpleBizes.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("simpleBizCell", forIndexPath: indexPath) as! simpleBizCell
        
        let biz = simpleBizes[indexPath.row]
        
        cell.homeBiz = biz
        
        cell.selectionStyle = .None
        
        return cell
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        return 114
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        self.performSegueWithIdentifier("Show Biz", sender: indexPath.row)
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if segue.identifier  == "Show Biz" {
            
            if let bizViewController = segue.destinationViewController as? BizViewController {
                
                bizViewController.BizID = simpleBizes[sender as! Int].id
                print("sender \(sender)")
                
                selectedBiz = simpleBizes[sender as! Int]
                currentSelectedBiz = selectedBiz.id
                currentSelectedBizIndex = sender as! Int
                pagingType = 4
                commentPagingType = 0
            }
        }
    }
    func popToRoot()
    {
        self.navigationController?.popToRootViewControllerAnimated(true)//back to previous
    }
}
