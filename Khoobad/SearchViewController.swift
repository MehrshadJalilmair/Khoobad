//
//  SearchViewController.swift
//  Khoobad
//
//  Created by Mehrshad Jalilmasir on 6/15/16.
//  Copyright © 2016 Mehrshad Jalilmasir. All rights reserved.
//

import UIKit

var nearestBizes:[HomeBiz] = [HomeBiz]()

var categories:[category] = [category]()
var subCategories:[category] = [category]()
var SelectedSubCategories:[category] = [category]()

class SearchViewController: UIViewController , UISearchBarDelegate{

    //Mark : just vars
    var refreshControl: UIRefreshControl!
    var isAnimating = false
    
    @IBOutlet weak var nearestBizTableView: UITableView!
    @IBOutlet weak var nearSearchBtn: UIButton!
    @IBOutlet weak var categorySearchBtn: UIButton!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var searchSuggests:[String] = [String]()
    
    @IBOutlet var waitingIndicator: UIActivityIndicatorView!
    
    //Mark : Loading funcs
    override func viewDidLoad() {
        super.viewDidLoad()
        
        popRequest = false
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.Plain, target:nil, action:nil)
        
        setNotificationsThatWillRecive()
        
        _init()
    }
    override func viewWillDisappear(animated: Bool) {
        
        self.searchBar.endEditing(true)
        //print("here here")
    }
    func setNotificationsThatWillRecive()
    {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(SearchViewController.reachabilityStatusChanged), name: "ReachStatusChanged" , object: nil)
        //reload TableView when data recieved from server or errors in receive
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(SearchViewController.reloadTableData), name: "reloadNearestTableView", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(SearchViewController.DataError), name: "WithoutNearestReciveData", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(SearchViewController.ResponseError), name: "WithoutNearestReciveResponse", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(SearchViewController.ConnectionError), name: "GetNearestServreConnectionProblem", object: nil)
    }
    func _init()
    {
        if let font = UIFont(name: "B Yekan", size: 15) {
            
            self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName :font , NSForegroundColorAttributeName: UIColor.whiteColor()]
        }
        
        let searchTextField: UITextField? = searchBar.valueForKey("searchField") as? UITextField
        if searchTextField!.respondsToSelector(Selector("attributedPlaceholder")) {
            //var color = UIColor.purpleColor()
            let attributeDict = [NSForegroundColorAttributeName: UIColor.lightGrayColor().colorWithAlphaComponent(0.5)]
            searchTextField!.attributedPlaceholder = NSAttributedString(string: "به دنبال چه چیزی هستی؟", attributes: attributeDict)
        }
        searchTextField?.textAlignment = .Right
        self.searchBar.layer.cornerRadius = 5.0
        self.searchBar.layer.masksToBounds = true
        
        /*searchTextField?.rightView = searchTextField?.leftView
        searchTextField!.leftViewMode = UITextFieldViewMode.Never
        searchTextField!.rightViewMode = UITextFieldViewMode.Always*/
        
        //categorySearchBtn.enabled = false
        //nearSearchBtn.enabled = false
        
        commentOrSearchFirst = -1
        nearestBizTableView.separatorStyle = .None
        
        settingPullRefresh()
        
        waitingIndicator.hidesWhenStopped = true
        waitingIndicator.startAnimating()
        getNearests()
        sharedVars.getCategories()
        
        nearSearchBtn.setImage(self.resizeImageWithAspect(UIImage(named: "human_location")!, scaledToMaxWidth: 32.0, maxHeight: 32.0), forState: UIControlState.Normal)
        categorySearchBtn.setImage(self.resizeImageWithAspect(UIImage(named: "category_search")!, scaledToMaxWidth: 32.0, maxHeight: 32.0), forState: UIControlState.Normal)
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
    //Mark Net Stutus Changing Notify
    func reachabilityStatusChanged()
    {
        if reachabilityStatus == KNOTREACHABLE {
            
            
        }
        else if reachabilityStatus == KREACHABLEWITHWWAN {
            
            
        }
        else if reachabilityStatus == KREACHABLEWITHWIFI {
            
            
        }
        print("\(reachabilityStatus)")
        getNearests()
    }
    func settingPullRefresh()
    {
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(SearchViewController.PullToRefresh), forControlEvents: UIControlEvents.ValueChanged)
        nearestBizTableView.addSubview(refreshControl)
        //loadCustomRefreshContents()
    }
    func PullToRefresh() {
        
        if refreshControl.refreshing {
            if !isAnimating {
                //animateRefreshStep1()
                //isAnimating = !isAnimating
                getNearests()
            }
        }
        
    }
    override func viewWillAppear(animated: Bool) {
        
        commentOrSearchFirst = -1
        popRequest = false
    }

    // Mark : Button funcs
    @IBAction func categorySreach(sender: AnyObject) {
        
        //self.performSegueWithIdentifier("categorySreach", sender: sender)
    }
    @IBAction func nearSearch(sender: AnyObject) {
        
    }
    func getNearests()
    {
        nearestBizes.removeAll()
        nearestBizTableView.reloadData()
        
        if (reachabilityStatus == KNOTREACHABLE || _NOP) {
            
            HomeBiz.getNearestHomeBizes(user.lat, long: user.long, NetOrLoc: false)
        }
        else if reachabilityStatus != KNOTREACHABLE && !_NOP
        {
            HomeBiz.getNearestHomeBizes(user.lat, long: user.long, NetOrLoc: true)
        }
    }
    
    
    //Mark : search bar Impls and methods
    func searchBarTextDidBeginEditing(searchBar: UISearchBar)
    {
        print("searchBarTextDidBeginEditing")
        pagingType = 3
        commentPagingType = 2
        commentOrSearchFirst = -1
        /*let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("KojaSearch")
        presentViewController(vc, animated: true, completion:nil)*/
        self.performSegueWithIdentifier("KojaSearch", sender: searchBar)
    }
    
    //MARK : Table View Impls
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        
         return nearestBizes.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("nearBizCell", forIndexPath: indexPath) as! nearBizInSearchTableViewCell
        
        let biz = nearestBizes[indexPath.row]
        
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
                
                bizViewController.BizID = nearestBizes[sender as! Int].id
                print("sender \(sender)")
                selectedBiz = nearestBizes[sender as! Int]
                currentSelectedBiz = selectedBiz.id
                currentSelectedBizIndex = sender as! Int
                pagingType = 1
                commentPagingType = 2
            }
        }
        else if segue.identifier  == "categorySearch" {
            
            //if let ViewController = segue.destinationViewController as? categorySearchViewController {
                
                
            //}
        }
    }
    func reloadTableData() {
        
        waitingIndicator.stopAnimating()
        refreshControl.endRefreshing()
        //isAnimating = !isAnimating
        nearestBizTableView.reloadData()
        //nearestBizTableView.reloadData()
    }
    func DataError() {
        
        waitingIndicator.stopAnimating()
        refreshControl.endRefreshing()
        //isAnimating = !isAnimating
    }
    func ResponseError() {
        
        waitingIndicator.stopAnimating()
        refreshControl.endRefreshing()
        //isAnimating = !isAnimating
    }
    func ConnectionError() {
     
        waitingIndicator.stopAnimating()
        refreshControl.endRefreshing()
       // isAnimating = !isAnimating
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        self.view.endEditing(true)
    }
}
