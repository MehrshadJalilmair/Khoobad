//
//  CheChizKojaViewController.swift
//  Khoobad
//
//  Created by Mehrshad Jalilmasir on 6/21/16.
//  Copyright © 2016 Mehrshad Jalilmasir. All rights reserved.
//

import UIKit
import MapKit

var KojaSelectedIndex:Int = 0
var KojaList:[HomeBiz] = [HomeBiz]()

class CheChizKojaViewController: UIViewController , UISearchBarDelegate , UITextFieldDelegate{
    
    @IBOutlet var imageIO: UIImageView!
    @IBOutlet var waitingIndicator: UIActivityIndicatorView!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var resultText: UILabel!
    
    
    //Mark : Just Vars
    var CheChiz:String = ""
    var Koja:String = ""
    
    @IBOutlet var searchBar1: UISearchBar!
    @IBOutlet var searchBar2: UISearchBar!
    
    override func viewWillLayoutSubviews() {
        
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(CheChizKojaViewController.handleSwipes(_:)))
        leftSwipe.direction = .Right
        view.addGestureRecognizer(leftSwipe)
    }
    //Mark : Loading
    override func viewDidLoad() {
        super.viewDidLoad()
    
        waitingIndicator.hidesWhenStopped = true
        
        tableView.keyboardDismissMode = .OnDrag
        
        //let tapGesture = UITapGestureRecognizer(target: self, action: Selector("hideKeyboard"))
        ///tapGesture.cancelsTouchesInView = true
        //tableView.addGestureRecognizer(tapGesture)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(CheChizKojaViewController.reachabilityStatusChanged), name: "ReachStatusChanged" , object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(CheChizKojaViewController.popToRoot), name: "popToRoot", object: nil)
        navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.Plain, target:nil, action:nil)
        
        searchBar1.backgroundImage = UIImage()
        searchBar2.backgroundImage = UIImage()
        
        let searchTextField1: UITextField? = searchBar1.valueForKey("searchField") as? UITextField
        if searchTextField1!.respondsToSelector(Selector("attributedPlaceholder")) {
            //var color = UIColor.purpleColor()
            let attributeDict = [NSForegroundColorAttributeName: UIColor.lightGrayColor().colorWithAlphaComponent(0.5)]
            searchTextField1!.attributedPlaceholder = NSAttributedString(string: "فروشگاه اینترنتی،رستوران،پوشاک...", attributes: attributeDict)
        }
        searchTextField1?.textAlignment = .Right
        
        let searchTextField2: UITextField? = searchBar2.valueForKey("searchField") as? UITextField
        if searchTextField2!.respondsToSelector(Selector("attributedPlaceholder")) {
            //var color = UIColor.purpleColor()
            let attributeDict = [NSForegroundColorAttributeName: UIColor.lightGrayColor().colorWithAlphaComponent(0.5)]
            searchTextField2!.attributedPlaceholder = NSAttributedString(string: "خیابان آزادی،تهران،اصفهان...", attributes: attributeDict)
        }
        searchTextField2?.textAlignment = .Right
        
        self.navigationController?.navigationBarHidden = true
        tableView.separatorStyle = .None
        
        if let font = UIFont(name: "B Yekan", size: 15) {
            
            self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName :font , NSForegroundColorAttributeName: UIColor.whiteColor()]
        }
    }
    func handleSwipes(sender:UISwipeGestureRecognizer) {
        
        if (sender.direction == .Right) {
            
            self.navigationController?.popToRootViewControllerAnimated(true)//back to previous
        }
    }
    func searchBarSearchButtonClicked(searchBar: UISearchBar)
    {
        self.view.endEditing(true)
    }
    func hideKeyboard()
    {
        tableView.endEditing(true)
    }
    func reachabilityStatusChanged()
    {
        if reachabilityStatus == KNOTREACHABLE {
            
            
        }
        else if reachabilityStatus == KREACHABLEWITHWWAN {
            
            
        }
        else if reachabilityStatus == KREACHABLEWITHWIFI {
            
            
        }
        updateTable()
        print("\(reachabilityStatus)")
    }
    override func viewWillAppear(animated: Bool) {
        
        if CheChiz == "" && Koja == ""{
            
            imageIO.hidden = false
            KojaList.removeAll()
            tableView.reloadData()
        }
        self.navigationController?.navigationBarHidden = true
    }
    override func viewWillDisappear(animated: Bool) {
        
        //KojaList = [HomeBiz]()
        if CheChiz == "" && Koja == ""{
            
            imageIO.hidden = false
            KojaList.removeAll()
            tableView.reloadData()
        }
        imageIO.hidden = true
        self.navigationController?.navigationBarHidden = false
    }
    func popToRoot()
    {
        self.navigationController?.popToRootViewControllerAnimated(true)//back to previous
    }
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar == searchBar1 {
            
            CheChiz = searchText
        }
        else
        {
            Koja = searchText
        }
        
        if (NSString(string:CheChiz).length >= 0 && NSString(string:CheChiz).length < 3) && (NSString(string:Koja).length < 3 && NSString(string:CheChiz).length >= 0)
        {
            return
        }
        
        self.updateTable()
    }
    func updateTable()
    {
        if CheChiz == "" && Koja == ""{

            imageIO.hidden = false
            KojaList.removeAll()
            tableView.reloadData()
            return
        }
        
        waitingIndicator.startAnimating()
        
        imageIO.hidden = true
        
        print("\(self.CheChiz)\(self.Koja)")
        
        if CheChiz == "" {
            
            CheChiz = ""
        }
        if Koja == "" {
            
            Koja = ""
        }
        
        /*if CheChiz.containsString(" ")
        {
            CheChiz = CheChiz.stringByReplacingOccurrencesOfString(" ", withString: "")
        }
        if Koja.containsString(" ")
        {
            Koja = Koja.stringByReplacingOccurrencesOfString(" ", withString: "")
        }*/
        
        if (reachabilityStatus != KNOTREACHABLE && !_NOP){
            
            var tmp = "\(URLS.what_where)lat=\(user.lat)&long=\(user.long)&what=\(CheChiz)&where=\(Koja)"
            print(tmp)
            
            tmp = tmp.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
            
            let URL:NSURL = NSURL(string: tmp)!
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
                
                let Bizes = try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions()) as! [NSObject]
                
                print(Bizes)
                
                KojaList = [HomeBiz]()
                
                for object in Bizes
                {
                    print(object)
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
                    
                    KojaList.append(biz)
                }
                if KojaList.count > 0
                {
                    //self.view.endEditing(true)
                    self.resultText.text = "نتایج مشابه"
                }
                else
                {
                    KojaList.removeAll()
                    //self.tableView.reloadData()
                    self.resultText.text = "نتایج مشابه  -   موردی یافت نشد!"
                }
                self.waitingIndicator.stopAnimating()
                self.tableView.reloadData()
            })
            
        }
        else if reachabilityStatus == KNOTREACHABLE || !_NOP//isFullLoaded = true for each item
        {
            //local reading
            //NSNotificationCenter.defaultCenter().postNotificationName("HomedisLoadingIndicator", object: nil)
            if CheChiz == "" {
                
                return
            }
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
            KojaList.removeAll()
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
            
            KojaList = [HomeBiz]()
            
            for biz in dbBizes {
                
                if biz.count < 6 {
                    
                    continue
                }
                
                let name = biz[3]
                
                if name.containsString(self.CheChiz) || name.containsString(self.CheChiz.capitalizedString) || name.containsString(self.CheChiz.lowercaseString) || name.containsString(self.CheChiz.uppercaseString){
                    
                    let lat = Double(biz[1])
                    let long = Double(biz[2])
                    
                    let phone = biz[4]
                    let id = Int(biz[0])
                    
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
                    
                    KojaList.append(_biz)
                    
                    if KojaList.count > 99
                    {
                        break
                    }
                }
            }
            
            var i = 0
            var j = 0
            
            for _ in KojaList
            {
                for _ in KojaList
                {
                    if i != j
                    {
                        if KojaList[i].distance < KojaList[j].distance
                        {
                            //swap(&Bizes[bizesIDS[i]], &Bizes[bizesIDS[j]])
                            swap(&KojaList[i], &KojaList[j])
                        }
                    }
                    j = j + 1
                }
                
                j = 0
                i = i + 1
            }

            if KojaList.count > 0
            {
                //self.view.endEditing(true)
                self.resultText.text = "نتایج مشابه"
            }
            else
            {
                KojaList.removeAll()
                //self.tableView.reloadData()
                self.resultText.text = "نتایج مشابه  -   موردی یافت نشد!"
            }
            
            self.waitingIndicator.stopAnimating()
            self.tableView.reloadData()
        })
    }
    
    //MARK : Table View Impls
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        
        return KojaList.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("what_whereCell", forIndexPath: indexPath) as! CheChizKojaCell
        
        let biz = KojaList[indexPath.row]
        
        cell.homeBiz = biz
        
        cell.selectionStyle = .None
        
        return cell
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        self.performSegueWithIdentifier("Show Biz", sender: indexPath.row)
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        return 114
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if segue.identifier  == "Show Biz" {
            
            if let bizViewController = segue.destinationViewController as? BizViewController {
                
                
                bizViewController.BizID = KojaList[sender as! Int].id
                print("sender \(sender)")
                selectedBiz = KojaList[sender as! Int]
                currentSelectedBiz = selectedBiz.id
                currentSelectedBizIndex = sender as! Int
                pagingType = 3
            }
        }
    }
    
    @IBAction func back(sender: AnyObject) {
        
        self.navigationController?.popToRootViewControllerAnimated(true)//back to previous
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        self.view.endEditing(true)
    }
}
