//
//  commentSearchViewController.swift
//  Khoobad
//
//  Created by Mehrshad Jalilmasir on 6/20/16.
//  Copyright © 2016 Mehrshad Jalilmasir. All rights reserved.
//

import UIKit

class commentSearchViewController: UIViewController , UISearchBarDelegate , UITextFieldDelegate{

    //Mark : Just Vars
    var refreshControl: UIRefreshControl!
    var customView: UIView!
    var labelsArray: Array<UILabel> = []
    var isAnimating = false
    var currentColorIndex = 0
    var currentLabelIndex = 0
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var searchSuggests:[String] = [String]()
    
    @IBOutlet var waitingIndicator: UIActivityIndicatorView!
    
    //Mark : Loading funcs
    override func viewDidLoad() {
        super.viewDidLoad()

        setNotificationsThatWillRecive()
        //همین حالا در مورد کسب و کارهای اطراف خود نظر دهید
        
        _init()
    }
    override func viewWillDisappear(animated: Bool) {
        
        self.searchBar.endEditing(true)
        //print("here here")
    }
    func setNotificationsThatWillRecive()
    {
        //reload TableView when data recieved from server or errors in receive
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(commentSearchViewController.reachabilityStatusChanged), name: "ReachStatusChanged" , object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(commentSearchViewController.reloadTableData), name: "reloadNearestTableView", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(commentSearchViewController.DataError), name: "WithoutNearestReciveData", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(commentSearchViewController.ResponseError), name: "WithoutNearestReciveResponse", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(commentSearchViewController.ConnectionError), name: "GetNearestServreConnectionProblem", object: nil)
    }
    func _init()
    {
        if let font = UIFont(name: "B Yekan", size: 15) {
            
            self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName :font , NSForegroundColorAttributeName: UIColor.whiteColor()]
        }
        //self.searchBar.layer.borderColor = UIColor.blueColor().CGColor
        //self.searchBar.layer.borderWidth = 1
        //self.searchBar.layer.cornerRadius = 3.0
        //self.searchBar.clipsToBounds = true
        //self.searchBar.barTintColor = UIColor.blueColor()
        //self.searchBar.setImage(UIImage(named: "placeholder.png"), forSearchBarIcon: UISearchBarIcon.Search, state: UIControlState.Normal)
        self.searchBar.layer.cornerRadius = 8.0
        self.searchBar.layer.masksToBounds = true
        
        let searchTextField: UITextField? = searchBar.valueForKey("searchField") as? UITextField
        if searchTextField!.respondsToSelector(Selector("attributedPlaceholder")) {
            //var color = UIColor.purpleColor()
            let attributeDict = [NSForegroundColorAttributeName: UIColor.lightGrayColor().colorWithAlphaComponent(0.5)]
            searchTextField!.attributedPlaceholder = NSAttributedString(string: "به دنبال چه چیزی هستی؟", attributes: attributeDict)
        }
        searchTextField?.textAlignment = .Right
        
        tableView.separatorStyle = .None

        settingPullRefresh()
        
        waitingIndicator.hidesWhenStopped = true
        waitingIndicator.startAnimating()
        getNearests()
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
        getNearests()
        print("\(reachabilityStatus)")
    }
    func settingPullRefresh()
    {
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(commentSearchViewController.PullToRefresh), forControlEvents: UIControlEvents.ValueChanged)
        tableView.addSubview(refreshControl)
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
    func getNearests()
    {
        nearestBizes.removeAll()
        tableView.reloadData()
        
        if (reachabilityStatus == KNOTREACHABLE || _NOP){
            
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
        commentPagingType = 1
        pagingType = 3
        commentOrSearchFirst = -1
        /*self.dismissViewControllerAnimated(true, completion: {})
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("KojaSearch")
        presentViewController(vc, animated: true, completion:nil)*/
        self.performSegueWithIdentifier("KojaSearch", sender: searchBar)
    }
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        
        self.view.endEditing(true)
    }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
        
        print("touchesBegan")
    }
    /*func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
        if !searchText.isEmpty {
        
            print("textDidChange")
        }
        
    }
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        
        self.searchBar.resignFirstResponder()
     
        print("searchBarSearchButtonClicked")
        self.performSegueWithIdentifier("showKoja", sender: searchBar)
        
    }
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        
        self.searchBar.resignFirstResponder()
   
        print("searchBarCancelButtonClicked")
    }*/
    
    //MARK : Table View Impls
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        if tableView == self.tableView
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
        
        return nearestBizes.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("CommentTableViewCell", forIndexPath: indexPath) as! CommentTableViewCell
        
        let biz = nearestBizes[indexPath.row]
        
        cell.homeBiz = biz
        
        cell.selectionStyle = .None
        
        return cell
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        currentSelectedBiz = nearestBizes[indexPath.row].id
        self.performSegueWithIdentifier("Add Comment", sender: indexPath.row)
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        
        if segue.identifier  == "Add Comment" {
            
            commentOrSearchFirst = 1
            commentPagingType = 1
            selectedBiz = nearestBizes[sender as! Int]
            currentSelectedBiz = selectedBiz.id
            currentSelectedBizIndex = sender as! Int
            pagingType = 1
            /*if let bizViewController = segue.destinationViewController as? commentViewController {
                
                //bizViewController.BizID = nearestBizes[sender as! Int].id
                selectedBiz = nearestBizes[sender as! Int]
                currentSelectedBiz = selectedBiz.id
                currentSelectedBizIndex = sender as! Int
                pagingType = 1
            }*/
        }
    }
    func reloadTableData() {
        
        tableView.reloadData()
        refreshControl.endRefreshing()
        waitingIndicator.stopAnimating()
        //isAnimating = !isAnimating
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
        //isAnimating = !isAnimating
    }
}
