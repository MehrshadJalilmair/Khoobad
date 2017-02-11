//
//  onMapViewController.swift
//  Khoobad
//
//  Created by Mehrshad Jalilmasir on 7/3/16.
//  Copyright © 2016 Mehrshad Jalilmasir. All rights reserved.
//

import UIKit
import MapKit

class onMapViewController: UIViewController , onMapShowSubs , onMapShowBizes{

    //Mark : Just Vars
    var countZarib = 1
    @IBOutlet weak var subCategoryCollView: UICollectionView!
    @IBOutlet weak var categoryCollView: UICollectionView!
    @IBOutlet var mapView: MKMapView!
    
    @IBOutlet var subRightBtn: UIButton!
    @IBOutlet var subLeftBtn: UIButton!
    
    var annonations = [MKAnnotation]()
    
    @IBOutlet var waitingIndicator: UIActivityIndicatorView!
    
    
    //Mark : Loading
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(onMapViewController.reachabilityStatusChanged), name: "ReachStatusChanged" , object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(onMapViewController.popToRoot), name: "popToRoot", object: nil)
        pageNumber = 1
        selectedCategoryID = -1//change it to default
        SelectedSubCategories = [category]()
        categoryCollView.backgroundColor = UIColor.clearColor().colorWithAlphaComponent(0.35)
        subCategoryCollView.backgroundColor = UIColor.clearColor().colorWithAlphaComponent(0.35)
        
        subLeftBtn.hidden = true
        subRightBtn.hidden = true
        subCategoryCollView.hidden = true
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.Plain, target:nil, action:nil)
        
        if let font = UIFont(name: "B Yekan", size: 15) {
            
            self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName :font , NSForegroundColorAttributeName: UIColor.whiteColor()]
        }
        f()//go user location
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
        getBizes()
    }
    func popToRoot()
    {
        self.navigationController?.popToRootViewControllerAnimated(true)//back to previous
    }
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.redColor()
        renderer.lineWidth = 4.0
        
        return renderer
    }

    
    //MARK : Coll View Impls
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        if collectionView == categoryCollView {
            
            return categories.count
        }
        return SelectedSubCategories.count
    }
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int
    {
        return 1
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
    {
        if collectionView == categoryCollView {
            
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("onMapCategoryCell", forIndexPath: indexPath) as! onMapCategoryCollectionViewCell
            cell.Category = categories[indexPath.row]
            cell.delegate = self
            return cell
        }
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("onMapSubCategoryCell", forIndexPath: indexPath) as! onMapSubCategoryCollectionViewCell
        cell.subCategory = SelectedSubCategories[indexPath.row]
        cell.delegate = self
        return cell
    }

    //Mark : category and subCategory selected in cells
    func categorySelected(cell: onMapCategoryCollectionViewCell) {
        
        subLeftBtn.hidden = false
        subRightBtn.hidden = false
        subCategoryCollView.hidden = false
        
        SelectedSubCategories = [category]()
        pageNumber = 1
        selectedCategoryID = -1
        for sub in subCategories {
            
            if (Int((sub.parent_id as? String)!)! == (cell.Category.id)) {
                
                SelectedSubCategories.append(sub)
            }
        }
        let allCase = category(id: cell.Category.id, name: "همه موارد" , desc: "", parent_id: -1)
        SelectedSubCategories.append(allCase)
        
        self.subCategoryCollView.reloadData()
        
        self.title = "\(cell.Category.name)"
    }
    func subCategorySelected(cell: onMapSubCategoryCollectionViewCell) {
        
        self.title = "\(cell.subCategory!.name)"
        selectedCategoryID = cell.subCategory.id
        getBizes()
    }
    func getBizes()
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
                
                print(Bizes)
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
                    print(id)
                    
                    if rate == -1
                    {
                        rate = -1.0
                    }
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
                self.reloadPins()
            })
        }
        else if reachabilityStatus == KNOTREACHABLE || _NOP//isFullLoaded = true for each item
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
            self.reloadPins()
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
            self.reloadPins()
        })
    }
    func reloadPins()
    {
        self.mapView.removeAnnotations(annonations)
        
        var i = 0
        
        annonations = [MKAnnotation]()
        
        for biz in categorySearchResultBizes
        {
            var annotationView:MKPinAnnotationView!
            
            let sourceLocation = CLLocationCoordinate2D(latitude: Double(biz.lat)!, longitude: Double(biz.long)!)
            let sourcePlacemark = MKPlacemark(coordinate: sourceLocation, addressDictionary: nil)
            
            let sourceAnnotation = CustomPointAnnotation()
            
            sourceAnnotation.title = "\(biz.name)"
            sourceAnnotation.subtitle = "\(biz.phone)"
            sourceAnnotation.pinCustomImageURL = "\(biz.imageAdd)"
            sourceAnnotation.id = biz.id
            sourceAnnotation.lat = Double(biz.lat)
            sourceAnnotation.long = Double(biz.long)
            sourceAnnotation.index = i
            if let location = sourcePlacemark.location {
                sourceAnnotation.coordinate = location.coordinate
            }
            annotationView = MKPinAnnotationView(annotation: sourceAnnotation, reuseIdentifier: "pin")
            self.mapView.addAnnotation(annotationView.annotation!)
            annonations.append(sourceAnnotation)
            i = i + 1
        }
        self.mapView.showAnnotations(annonations , animated: true)
        self.waitingIndicator.stopAnimating()
    }
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView?{
        
        if (annotation is MKUserLocation) {
            
            return nil
        }
        
        let reuseIdentifier = "pin"
        
        var v = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseIdentifier)
        if v == nil {
            v = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseIdentifier)
            v!.canShowCallout = true
        }
        else {
            v!.annotation = annotation
        }
        
        let customPointAnnotation = annotation as! CustomPointAnnotation
        
        v!.image = UIImage(named: "main_placeholder")
        let image = UIButton(frame: CGRect(origin: CGPoint(x: 0 , y: 0), size: CGSize(width: 32 , height: 32)))
        
        if customPointAnnotation.pinCustomImageURL == "default" {
            
            
            let URL:NSString =  "http://maps.googleapis.com/maps/api/staticmap?center=\(customPointAnnotation.lat),\(customPointAnnotation.long)&zoom=13&size=414x200&scale=false&maptype=roadmap&format=png&visual_refresh=true&markers=size:mid%7Ccolor:0x3F51B5%7Clabel:%7C\(customPointAnnotation.lat),\(customPointAnnotation.long)"
            print(URL)
            let urlStr : NSString = URL.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
            
            let _url0 =  NSURL(string : urlStr as String)
            
            if let url0 = _url0 {
                
                let imageDownloader = dataDownloaderServiceTask(url: url0)
                imageDownloader.Download({ (data) in
                    
                    let _image = UIImage(data : data)
                    dispatch_async(dispatch_get_main_queue(), {
                        
                        image.setImage(_image, forState: UIControlState.Normal)
                    })
                })
            }
        }
        else if customPointAnnotation.pinCustomImageURL == "eshop"
        {
            image.setImage(UIImage(named: "eshop1") , forState: UIControlState.Normal)
        }
        else if customPointAnnotation.pinCustomImageURL == "local"
        {
            image.setImage(UIImage(named: "local1") , forState: UIControlState.Normal)
        }
        else{
            
            let _url =  NSURL(string : String.localizedStringWithFormat(URLS.Imagess, customPointAnnotation.pinCustomImageURL))
            print(_url)
            
            if let url = _url {
                
                let imageDownloader = dataDownloaderServiceTask(url: url)
                imageDownloader.Download({ (data) in
                    
                    let _image = UIImage(data : data)
                    dispatch_async(dispatch_get_main_queue(), {
                        
                        image.setImage(_image, forState: UIControlState.Normal)
                    })
                })
            }
        }
        
        let rightButton: AnyObject! = image//UIButton(type: UIButtonType.DetailDisclosure)
        v?.rightCalloutAccessoryView = rightButton as? UIView
        
        v?.draggable = true
        v?.canShowCallout = true
        
        let moreInfoButton = UIButton(type: UIButtonType.Custom) as UIButton
        moreInfoButton.frame.size.width = 32
        moreInfoButton.frame.size.height = 32
        moreInfoButton.setImage(UIImage(named: "moreinfo"), forState: .Normal)
        
        v?.leftCalloutAccessoryView = moreInfoButton
    
        return v
    }
    func mapView(mapView: MKMapView!, annotationView view: MKAnnotationView!, calloutAccessoryControlTapped control: UIControl!) {
        
        if control == view.rightCalloutAccessoryView {
            
            return
        }
        else if let annotation = view.annotation as? CustomPointAnnotation {
            
            print("\(annotation.id)")
            self.performSegueWithIdentifier("Show Biz", sender: annotation.index)
        }
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if segue.identifier  == "Show Biz" {
            
            if let bizViewController = segue.destinationViewController as? BizViewController {
                
                bizViewController.BizID = categorySearchResultBizes[(sender as? Int)!].id
                print("sender \(sender)")
                
                selectedBiz = categorySearchResultBizes[(sender as? Int)!]
                currentSelectedBiz = selectedBiz.id
                currentSelectedBizIndex = (sender as? Int)!
                pagingType = 2
                commentPagingType = 2
            }
        }
    }

    //Mark :location and more btn in UI function
    @IBAction func onLocation(sender: AnyObject) {
        
        f()
        
        //reloadPins()
    }
    func f()
    {
        let center = CLLocationCoordinate2D(latitude: user.lat, longitude: user.long)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
        self.mapView.setRegion(region, animated: true)
    }
    @IBAction func onMoreBiz(sender: AnyObject) {
        
        if selectedCategoryID != -1 {
            
            pageNumber = pageNumber + 1
            if pageNumber <= pageNumbers  && reachabilityStatus != KNOTREACHABLE{
                
                getBizes()
            }
        }
    }
    func directMeToBiz(index:Int) {
        
        if (UIApplication.sharedApplication().canOpenURL(NSURL(string:"comgooglemaps://")!)) {
            
            UIApplication.sharedApplication().openURL(NSURL(string:
                "comgooglemaps://?saddr=\(user.lat),\(user.long)&daddr=\(categorySearchResultBizes[index].lat),\(categorySearchResultBizes[index].long)&directionsmode=driving")!)
            
        } else {
            NSLog("Can't use comgooglemaps://");
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        self.view.endEditing(true)
    }
}

class CustomPointAnnotation: MKPointAnnotation {
    
    var pinCustomImageURL:String!
    var id:Int!
    var lat:Double!
    var long:Double!
    var index:Int!
}