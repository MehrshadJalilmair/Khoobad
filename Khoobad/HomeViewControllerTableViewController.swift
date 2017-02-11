//
//  HomeViewControllerTableViewController.swift
//  Khoobad
//
//  Created by Mehrshad Jalilmasir on 6/7/16.
//  Copyright © 2016 Mehrshad Jalilmasir. All rights reserved.
//

import UIKit
import CoreLocation

var simpleBizesORFavs = true//true = simpleBizes , false = favorite list

class HomeViewControllerTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate , CLLocationManagerDelegate{
    
    //Mark : Just Vars
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    @IBOutlet weak var mainBtn1: UIButton!
    @IBOutlet weak var mainBtn2: UIButton!
    @IBOutlet weak var mainBtn3: UIButton!
    @IBOutlet weak var mainBtn4: UIButton!
    @IBOutlet weak var mainBtn5: UIButton!
    @IBOutlet weak var mainBtn6: UIButton!
    
    @IBOutlet weak var mainBack1: UIView!
    @IBOutlet weak var mainBack2: UIView!
    @IBOutlet weak var mainBack3: UIView!
    
    @IBOutlet weak var HomeBizesTableView: UITableView!
    var refreshControl: UIRefreshControl!
    var customView: UIView!
    var labelsArray: Array<UILabel> = []
    var isAnimating = false
    var currentColorIndex = 0
    var currentLabelIndex = 0
    
    //Mark : Loading Funcs
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*let customTabBarItem:UITabBarItem = UITabBarItem(title: nil, image: UIImage(named: "web24")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal), selectedImage: UIImage(named: "hm_color"))
        tabBarItem = customTabBarItem*/
        mainBtn1.titleLabel?.textAlignment = .Center
        mainBtn2.titleLabel?.textAlignment = .Center
        mainBtn3.titleLabel?.textAlignment = .Center
        mainBtn4.titleLabel?.textAlignment = .Center
        mainBtn5.titleLabel?.textAlignment = .Center
        mainBtn6.titleLabel?.textAlignment = .Center
        
        mainBack1.layer.cornerRadius = 5.0
        mainBack1.layer.masksToBounds = true
        mainBack2.layer.cornerRadius = 5.0
        mainBack2.layer.masksToBounds = true
        mainBack3.layer.cornerRadius = 5.0
        mainBack3.layer.masksToBounds = true
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.Plain, target:nil, action:nil)
        
        settingPullRefresh()
        
        setNotificationsThatWillRecive()

        HomeBizesTableView.separatorStyle = .None
        //NSTimer.scheduledTimerWithTimeInterval(2, target: self, selector: "dbLoading", userInfo: nil, repeats: false)
        if let font = UIFont(name: "B Yekan", size: 15) {
            
            self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName :font , NSForegroundColorAttributeName: UIColor.whiteColor()]
        }
        
        let rightBarButtonItems = self.navigationItem.rightBarButtonItems! as [UIBarButtonItem]
        
        var i = 0
        for item in rightBarButtonItems
        {
            if i == 0 {
                
                item.image = resizeImageWithAspect(UIImage(named: "user_menu")!, scaledToMaxWidth: 24.0, maxHeight: 24.0)
            }
            if i == 1 {
                
                item.image = resizeImageWithAspect(UIImage(named: "main_menu")!, scaledToMaxWidth: 24.0, maxHeight: 24.0)
            }
            i = i + 1
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
    func dbLoading()
    {
        print(db.getBizs().count)
        print(user.lat)
        
        /*else if db.getBizs().count < db.getLocalDBCount()
        {
            let qualityOfServiceClass = QOS_CLASS_BACKGROUND
            let backgroundQueue = dispatch_get_global_queue(qualityOfServiceClass, 0)
            dispatch_async(backgroundQueue, {
                
                print("adding all records")
                let localPath = db.getLocalDBPath()
                
                do {
                    let text = NSString(string: localPath)
                    var lines:[String] = text.componentsSeparatedByString("\n")
                    lines.removeRange(0...(db.getBizs().count - 1))
                    
                    print(db.getBizs().count)
                    print(lines.count)
                    for line in lines
                    {
                        if line.componentsSeparatedByString("\t").count == 5
                        {
                            print("\(line.componentsSeparatedByString("\t")[0]) \(line.componentsSeparatedByString("\t")[1]) \(line.componentsSeparatedByString("\t")[2]) \(line.componentsSeparatedByString("\t")[3]) \(line.componentsSeparatedByString("\t")[4])")
                            db.addLocalDBRecord(line.componentsSeparatedByString("\t")[3],
                                phone: line.componentsSeparatedByString("\t")[4],
                                id: Int(line.componentsSeparatedByString("\t")[0])!,
                                lat: Double(line.componentsSeparatedByString("\t")[1])!,
                                long: Double(line.componentsSeparatedByString("\t")[2])!)
                        }
                    }
                }
                catch
                {
                    /* error handling here */
                }
            })
        }*/
    }
    override func viewWillAppear(animated: Bool) {
        
        //notify internet status changing from AppDelegate
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(HomeViewControllerTableViewController.reachabilityStatusChanged), name: "ReachStatusChanged" , object: nil)
        commentOrSearchFirst = -1
        
        if logRegRequest {
            
            logRegRequest = false
            user.login()
        }
    }
    func setNotificationsThatWillRecive()
    {
        
        //self.reachabilityStatusChanged()
        
        //reload TableView when data recieved from server or errors in receive
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(HomeViewControllerTableViewController.reloadTableData), name: "reloadTableView", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(HomeViewControllerTableViewController.DataError), name: "WithoutBizesReciveData", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(HomeViewControllerTableViewController.ResponseError), name: "WithoutBizesReciveResponse", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(HomeViewControllerTableViewController.ConnectionError), name: "GetBizesServreConnectionProblem", object: nil)
        
        //indicator view -- show and hide
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(HomeViewControllerTableViewController.HomeLoadingIndicator), name: "HomeLoadingIndicator", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(HomeViewControllerTableViewController.HomedisLoadingIndicator), name: "HomedisLoadingIndicator", object: nil)
    }
    
    //Mark Net Stutus Changing Notify
    func reachabilityStatusChanged()
    {
        HomeBizes.HomeBizesArr.removeAll()
        HomeBizes.HomeBizesIDS.removeAll()
        HomeBizes.HomeBizesCount = 0
        HomeBizesTableView.reloadData()
        
        if reachabilityStatus == KNOTREACHABLE || _NOP{
            HomeBiz.getBizes(user.lat, long: user.long, NetOrLoc: false)
        }
        else if reachabilityStatus == KREACHABLEWITHWWAN && !_NOP{
            
            HomeBiz.getBizes(user.lat, long: user.long, NetOrLoc: true)
        }
        else if reachabilityStatus == KREACHABLEWITHWIFI && _NOP{
            
            HomeBiz.getBizes(user.lat, long: user.long, NetOrLoc: true)
        }
        print("\(reachabilityStatus)")
    }
    
    //Mark : show and dis show indicator
    func HomeLoadingIndicator()
    {
        indicator = Indicator(view: view, message: "بارگذاری...")
    }
    func HomedisLoadingIndicator()
    {
        indicator.hide()
    }
    
    //MARK : setting up pull refresh
    func scrollViewDidScrollToTop(scrollView: UIScrollView) {
        
        
    }
    func settingPullRefresh()
    {
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(HomeViewControllerTableViewController.PullToRefresh), forControlEvents: UIControlEvents.ValueChanged)
        HomeBizesTableView.addSubview(refreshControl)
        //loadCustomRefreshContents()
    }
    func PullToRefresh() {

        if refreshControl.refreshing {
            if !isAnimating {
                //animateRefreshStep1()
                user.chaeckLocationManagerPermission()
            }
        }
        
    }
    func loadCustomRefreshContents() {
        
        let refreshContents = NSBundle.mainBundle().loadNibNamed("RefreshContents", owner: self, options: nil)
        
        customView = refreshContents[0] as! UIView
        customView.frame = refreshControl.bounds
        customView.backgroundColor = UIColor.clearColor()
        customView.layer.cornerRadius = 3.0
        customView.layer.masksToBounds = false
        customView.layer.shadowColor = UIColor.blackColor().colorWithAlphaComponent(0.2).CGColor
        customView.layer.shadowOffset = CGSize(width: 0, height: 0)
        customView.layer.shadowOpacity = 0.8
        
        for i in 0 ..< customView.subviews.count {
            labelsArray.append(customView.viewWithTag(i + 1) as! UILabel)
        }
        
        refreshControl.addSubview(customView)
    }
    func animateRefreshStep1() {
        isAnimating = true
        
        UIView.animateWithDuration(0.05, delay: 0.0, options: UIViewAnimationOptions.CurveLinear, animations: { () -> Void in
            self.labelsArray[self.currentLabelIndex].transform = CGAffineTransformMakeRotation(CGFloat(M_PI_4))
            self.labelsArray[self.currentLabelIndex].textColor = self.getNextColor()
            
            }, completion: { (finished) -> Void in
                
                UIView.animateWithDuration(0.05, delay: 0.0, options: UIViewAnimationOptions.CurveLinear, animations: { () -> Void in
                    self.labelsArray[self.currentLabelIndex].transform = CGAffineTransformIdentity
                    self.labelsArray[self.currentLabelIndex].textColor = UIColor.blackColor()
                    
                    }, completion: { (finished) -> Void in
                        self.currentLabelIndex += 1
                        
                        if self.currentLabelIndex < self.labelsArray.count {
                            self.animateRefreshStep1()
                        }
                        else {
                            self.animateRefreshStep2()
                        }
                })
        })
    }
    func animateRefreshStep2() {
        UIView.animateWithDuration(0.01, delay: 0.0, options: UIViewAnimationOptions.CurveLinear, animations: { () -> Void in
            self.labelsArray[0].transform = CGAffineTransformMakeScale(1.5, 1.5)
            self.labelsArray[1].transform = CGAffineTransformMakeScale(1.5, 1.5)
            self.labelsArray[2].transform = CGAffineTransformMakeScale(1.5, 1.5)
            self.labelsArray[3].transform = CGAffineTransformMakeScale(1.5, 1.5)
            self.labelsArray[4].transform = CGAffineTransformMakeScale(1.5, 1.5)
            self.labelsArray[5].transform = CGAffineTransformMakeScale(1.5, 1.5)
            self.labelsArray[6].transform = CGAffineTransformMakeScale(1.5, 1.5)
            
            }, completion: { (finished) -> Void in
                UIView.animateWithDuration(0.01, delay: 0.0, options: UIViewAnimationOptions.CurveLinear, animations: { () -> Void in
                    self.labelsArray[0].transform = CGAffineTransformIdentity
                    self.labelsArray[1].transform = CGAffineTransformIdentity
                    self.labelsArray[2].transform = CGAffineTransformIdentity
                    self.labelsArray[3].transform = CGAffineTransformIdentity
                    self.labelsArray[4].transform = CGAffineTransformIdentity
                    self.labelsArray[5].transform = CGAffineTransformIdentity
                    self.labelsArray[6].transform = CGAffineTransformIdentity
                    
                    }, completion: { (finished) -> Void in
                        if self.refreshControl.refreshing {
                            self.currentLabelIndex = 0
                            self.animateRefreshStep1()
                        }
                        else {
                            self.isAnimating = false
                            self.currentLabelIndex = 0
                            for i in 0 ..< self.labelsArray.count {
                                self.labelsArray[i].textColor = UIColor.blackColor()
                                self.labelsArray[i].transform = CGAffineTransformIdentity
                            }
                        }
                })
        })
    }
    func getNextColor() -> UIColor {
        var colorsArray: Array<UIColor> = [UIColor.magentaColor(), UIColor.brownColor(), UIColor.yellowColor(), UIColor.redColor(), UIColor.greenColor(), UIColor.blueColor(), UIColor.orangeColor()]
        
        if currentColorIndex == colorsArray.count {
            currentColorIndex = 0
        }
        
        let returnColor = colorsArray[currentColorIndex]
        currentColorIndex += 1
        
        return returnColor
    }
    
    
    //MARK : Table View Impls
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
    
        return HomeBizes.HomeBizesCount
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("HomeBizCell", forIndexPath: indexPath) as! HomeBizViewCell
        
        let biz = HomeBizes.HomeBizesArr[HomeBizes.HomeBizesIDS[indexPath.row]]
        
        cell.homeBiz = biz
        
        cell.selectionStyle = .None
        
        return cell
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        self.performSegueWithIdentifier("Show Biz", sender: indexPath.row)
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if segue.identifier  == "Show Biz" {
            
            if let bizViewController = segue.destinationViewController as? BizViewController {
            
                bizViewController.BizID = HomeBizes.HomeBizesIDS[(sender as? Int)!]
                print("sender \(sender)")
                
                selectedBiz = HomeBizes.HomeBizesArr[HomeBizes.HomeBizesIDS[(sender as? Int)!]]!
                currentSelectedBiz = selectedBiz.id
                currentSelectedBizIndex = -1
                pagingType = 0
                commentPagingType = 0
            }
        }
        else if segue.identifier  == "Show Favs" {
            
            simpleBizesORFavs = false
        }
    }
    func reloadTableData() {
        
        HomeBizesTableView.reloadData()
        refreshControl.endRefreshing()
    }
    func DataError() {
        
        refreshControl.endRefreshing()
    }
    func ResponseError() {
        
        refreshControl.endRefreshing()
    }
    func ConnectionError() {
        
        refreshControl.endRefreshing()
    }
    
    //Mark : End Of LifeCycle
    deinit
    {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "reachabilityChanged", object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "reloadTableView", object: nil)
    }
    
    //Mark : Bar Buttons Funcs
    @IBAction func userProfile(sender: AnyObject) {
        
        if !user.isLogin
        {
            user.login()
        }
        else
        {
            profile()
        }
    }
    func profile()
    {
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let content = storyboard.instantiateViewControllerWithIdentifier("userProfile")
        let partialModal: EMPartialModalViewController = EMPartialModalViewController(rootViewController: content, contentHeight: 250)
        
        presentViewController(partialModal, animated: true)
        {
            print("presenting view controller - done")
        }
    }
    @IBAction func menu(sender: AnyObject) {
        
        let alertController = UIAlertController(title: "منو", message: "", preferredStyle: .ActionSheet)
        
        let bizCon = UIAlertAction(title: "ثبت کسب و کار", style: .Default) { (action) in
            
            if user.isLogin
            {
                let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let content = storyboard.instantiateViewControllerWithIdentifier("registerBiz")
                let partialModal: EMPartialModalViewController = EMPartialModalViewController(rootViewController: content, contentHeight: UIScreen.mainScreen().bounds.height - 200)
                
                self.presentViewController(partialModal, animated: true)
                {
                    print("presenting view controller - done")
                }
            }
            else
            {
                user.login()
            }
        }
        alertController.addAction(bizCon)
        
        let favorites = UIAlertAction(title: "لیست علاقه مندی", style: .Default) { (action) in
            
            if user.isLogin
            {
                self.performSegueWithIdentifier("Show Favs", sender: self)
            }
            else
            {
                user.login()
            }
        }
        alertController.addAction(favorites)
        
        let cancel = UIAlertAction(title: "بازگشت", style: .Cancel) { (action) in
           
            
        }
        alertController.addAction(cancel)
        
        self.presentViewController(alertController, animated: true) {
            
            
        }
    }
    
    //Mark Links
    @IBAction func search1(sender: AnyObject) {
        gotoSearch()
    }
    @IBAction func search2(sender: AnyObject) {
        gotoSearch()
    }
    @IBAction func comment1(sender: AnyObject) {
        gotoComment()
    }
    @IBAction func comment2(sender: AnyObject) {
        gotoComment()
    }
    @IBAction func addbiz1(sender: AnyObject) {
        addBiz()
    }
    @IBAction func addbiz2(sender: AnyObject) {
        addBiz()
    }
    func gotoSearch()
    {
        let tababarController = appDelegate.window!.rootViewController as! RAMAnimatedTabBarController
        tababarController.setSelectIndex(from: 1, to: 0)
    }
    func gotoComment()
    {
        let tababarController = appDelegate.window!.rootViewController as! RAMAnimatedTabBarController
        tababarController.setSelectIndex(from: 1, to: 2)
    }
    func addBiz()
    {
        if user.isLogin
        {
            let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let content = storyboard.instantiateViewControllerWithIdentifier("registerBiz")
            let partialModal: EMPartialModalViewController = EMPartialModalViewController(rootViewController: content, contentHeight: UIScreen.mainScreen().bounds.height - 200)
            
            self.presentViewController(partialModal, animated: true)
            {
                print("presenting view controller - done")
            }
        }
        else
        {
            user.login()
        }
    }    
}
