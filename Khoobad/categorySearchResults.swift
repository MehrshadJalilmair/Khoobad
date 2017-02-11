//
//  categorySearchResults.swift
//  Khoobad
//
//  Created by Mehrshad Jalilmasir on 7/8/16.
//  Copyright © 2016 Mehrshad Jalilmasir. All rights reserved.
//

import UIKit
import MapKit

var categorySearchResultBizes:[HomeBiz] = [HomeBiz]()
var pageNumber = 1
var pageNumbers = 1
var selectedCategoryID:Int!
var selectedCategoryName:String!
var selectedSubCategoryName:String!

class categorySearchResults: UIViewController {

    //Mark : Just VARS
    @IBOutlet weak var resultsTableView: UITableView!
    @IBOutlet var waitingIndicator: UIActivityIndicatorView!
    
    //MARK : Loading
    override func viewDidLoad() {
        super.viewDidLoad()

        if let font = UIFont(name: "B Yekan", size: 15) {
            
            self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName :font , NSForegroundColorAttributeName: UIColor.whiteColor()]
        }
        navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.Plain, target:nil, action:nil)
        
        resultsTableView.separatorStyle = .None
        self.title = "نتایج برای \(selectedCategoryName)-\(selectedSubCategoryName)"
        //self.navigationController!.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "CaviarDreams", size: 14)!]
        pageNumber = 1
        getResultBizes()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(categorySearchResults.reachabilityStatusChanged), name: "ReachStatusChanged" , object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(categorySearchResults.popToRoot), name: "popToRoot", object: nil)
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
        getResultBizes()
    }
    func popToRoot()
    {
        self.navigationController?.popToRootViewControllerAnimated(true)//back to previous
    }
    func getResultBizes()
    {
        waitingIndicator.startAnimating()
        if (reachabilityStatus != KNOTREACHABLE && !_NOP){
            
            let URL:NSURL = NSURL(string: (String.localizedStringWithFormat(URLS.biz_category , "\(selectedCategoryID)" , "\(pageNumber)" , "\(user.lat)" , "\(user.long)")))!
            let BizRequest : NSURLRequest = NSURLRequest(URL: URL)
            
            print(URL)
            
            NSURLConnection.sendAsynchronousRequest(BizRequest, queue: NSOperationQueue.mainQueue(), completionHandler: { (response , data , error) in
                
                //NSNotificationCenter.defaultCenter().postNotificationName("HomedisLoadingIndicator", object: nil)
                
                if data == nil{
                    
                    //ui error or change to loca
                    
                    return
                }
                
                guard let httpResponse = response as? NSHTTPURLResponse
                    else
                {
                    //ui error or change to local
                    return
                }
                
                if httpResponse.statusCode < 200 || httpResponse.statusCode >= 300 //|| httpResponse.MIMEType == "application/json"
                {
                    //ui error or change to local
                    return
                }
                
                let Bizes = try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions())
                
                //print(Bizes)
                let places = (Bizes["bizs"] as! [NSObject])
                
                pageNumber = (Bizes["page_num"] as! Int)
                pageNumbers = (Bizes["total_pages"] as! Int)
                
                if pageNumber == 1 || pageNumber == 0
                {
                    categorySearchResultBizes = [HomeBiz]()
                }
                
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
            
                    //print(ActualBiz)
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
                    
                    categorySearchResultBizes.append(biz)
                }
                self.reloadTableData()
            })

        }
        else if reachabilityStatus == KNOTREACHABLE || _NOP //isFullLoaded = true for each item
        {
            //local reading
            //NSNotificationCenter.defaultCenter().postNotificationName("HomedisLoadingIndicator", object: nil)
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
            pageNumber = 1
            pageNumbers = 1
            categorySearchResultBizes.removeAll()
            self.resultsTableView.reloadData()
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
            
            categorySearchResultBizes = [HomeBiz]()
            
            for biz in dbBizes {
                
                if biz.count < 6 {
                    
                    continue
                }
                
                let lat = Double(biz[1])
                let long = Double(biz[2])
                let name = biz[3]
                let phone = biz[4]
                let id = Int(biz[0])
                let cats = biz[5].componentsSeparatedByString(",")
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
                
                if cats.contains(String(selectedCategoryID)){
                
                    categorySearchResultBizes.append(_biz)
                    if categorySearchResultBizes.count > 99
                    {
                        break
                    }
                }
                else if selectedCategoryID < 15
                {
                    for subCat in SelectedSubCategories
                    {
                        for _subCat in cats
                        {
                            if _subCat == String(subCat.id)
                            {
                                categorySearchResultBizes.append(_biz)
                            }
                        }
                    }
                    if categorySearchResultBizes.count > 99
                    {
                        break
                    }
                }
            }
            
            var i = 0
            var j = 0
            
            for _ in categorySearchResultBizes
            {
                for _ in categorySearchResultBizes
                {
                    if i != j
                    {
                        if categorySearchResultBizes[i].distance < categorySearchResultBizes[j].distance
                        {
                            //swap(&Bizes[bizesIDS[i]], &Bizes[bizesIDS[j]])
                            swap(&categorySearchResultBizes[i], &categorySearchResultBizes[j])
                        }
                    }
                    j = j + 1
                }
                
                j = 0
                i = i + 1
            }
            
            self.waitingIndicator.stopAnimating()
            self.resultsTableView.reloadData()
        })
    }
    
    //MARK : Table View Impls
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        if tableView == self.resultsTableView
        {
            return 108
        }
        return 15
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        
        return categorySearchResultBizes.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("categorySearchResultCell", forIndexPath: indexPath) as! categorySearchResultsCell
        
        let biz = categorySearchResultBizes[indexPath.row]
        
        cell.homeBiz = biz
        
        cell.selectionStyle = .None
        
        if indexPath.row == categorySearchResultBizes.count - 1 && reachabilityStatus != KNOTREACHABLE{
            
            if pageNumbers > 1 {
                
                if pageNumber <= pageNumbers {
                    
                    pageNumber = pageNumber + 1
                    getResultBizes()
                }
            }
        }

        return cell
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        currentSelectedBiz = categorySearchResultBizes[indexPath.row].id
        self.performSegueWithIdentifier("Show Biz", sender: indexPath.row)
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        
        if segue.identifier  == "Show Biz" {
            
            if let bizViewController = segue.destinationViewController as? BizViewController {
                
                bizViewController.BizID = categorySearchResultBizes[sender as! Int].id
                selectedBiz = categorySearchResultBizes[sender as! Int]
                currentSelectedBiz = selectedBiz.id
                currentSelectedBizIndex = sender as! Int
                pagingType = 2
                commentPagingType = 2
            }
        }
    }
    func reloadTableData() {
        
        waitingIndicator.stopAnimating()
        self.resultsTableView.reloadData()
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        self.view.endEditing(true)
    }
}
