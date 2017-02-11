//
//  BizViewController.swift
//  Khoobad
//
//  Created by Mehrshad Jalilmasir on 6/9/16.
//  Copyright © 2016 Mehrshad Jalilmasir. All rights reserved.
//

import UIKit
import MapKit

var currentSelectedBiz = -1
var currentSelectedBizIndex = -1
var selectedBiz:HomeBiz!
var pagingType = 0//certains change under which array : From Home = 0, From search = 1 , From comment = 1 , From categorySearchResults = 2 , From Map = 2 , From Che Chiz Koja Search Modal = 3, From similar  Bizes = 4

var cellForLikeOrDislike:HomeBizCommentViewCell!

class BizViewController: UIViewController , Infoing , Gallery , myComment{

    
    //Mark : Just Vars    
    @IBOutlet weak var mainScrollview: UITableView!
    @IBOutlet weak var bizHeader: UIView!
    var headerMaskLayer:CAShapeLayer!
    
    let detailTransitioningDelegate: PresentationManager = PresentationManager()
    var BizID = 0
    var Biz:HomeBiz!
    
    //Mark : Loading Funcs
    override func viewDidLoad() {
        super.viewDidLoad()
    
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(BizViewController.popToRoot), name: "popToRoot", object: nil)
        //Biz = HomeBizes.HomeBizesArr[HomeBizes.HomeBizesIDS[BizIndex]]!
        //selectedBiz = self.Biz
        mainScrollview.allowsSelection = false
        commentOrSearchFirst = -1
    
        self.Biz = selectedBiz
        currentSelectedBiz = Biz.id
        print(Biz.id)
        
        bizHeader = mainScrollview.tableHeaderView as? BizHeader
        GalleryDelegate = self
        mainScrollview.tableHeaderView = nil
        mainScrollview.addSubview(bizHeader)
        
        mainScrollview.contentInset = UIEdgeInsets(top: 200, left: 0, bottom: 0, right: 0)
        mainScrollview.contentOffset = CGPoint(x: 0, y: -200)
        
        headerMaskLayer = CAShapeLayer()
        headerMaskLayer.fillColor = UIColor.blackColor().CGColor
        bizHeader.layer.mask = headerMaskLayer
        
        updateHeaderView()
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.Plain, target:nil, action:nil)
        
        setNotificationsThatWillRecive()
    
        print("loding")
        if let font = UIFont(name: "B Yekan", size: 15) {
            
            self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName :font , NSForegroundColorAttributeName: UIColor.whiteColor()]
        }
    }
    func popToRoot()
    {
        self.navigationController?.popToRootViewControllerAnimated(true)//back to previous
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    
        updateHeaderView()
        currentSelectedBiz = Biz.id
        //Biz = HomeBizes.HomeBizesArr[HomeBizes.HomeBizesIDS[BizIndex]]!
        //selectedBiz = self.Biz
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        updateHeaderView()
    }
    func updateHeaderView()
    {
        var headerRect = CGRect(x: 0, y: -185 , width: mainScrollview.bounds.width, height: 200)
        if mainScrollview.contentOffset.y < -185 {
            
            headerRect.origin.y = mainScrollview.contentOffset.y
            headerRect.size.height = -mainScrollview.contentOffset.y
        }
        
        bizHeader.frame = headerRect
        
        let path = UIBezierPath()
        path.moveToPoint(CGPoint(x: headerRect.width, y: 0))
        path.addLineToPoint(CGPoint(x: 0, y: 0))
        path.addLineToPoint(CGPoint(x: 0, y: headerRect.height))
        path.addLineToPoint(CGPoint(x: headerRect.width, y: headerRect.height))//-20
        
        headerMaskLayer?.path = path.CGPath
    }

    override func viewWillAppear(animated: Bool) {
        
        //simpleBizes = [HomeBiz]()
        commentPagingType = 0
        currentSelectedBiz = Biz.id
        print("viewappear \(currentSelectedBiz)")
    }
    func setNotificationsThatWillRecive()
    {
        //reload TableView when data recieved from server or errors in receive --->Net Reading
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(BizViewController.LoadCommntsDataError), name: "WithoutCommentsReciveData", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(BizViewController.LoadCommntsResponseError), name: "WithoutReciveCommentsResponse", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(BizViewController.LoadCommntsConnectionError), name: "GetCommentsServreConnectionProblem", object: nil)
        
        //indicator view -- show and hide
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(BizViewController.LoginLoadingIndicator), name: "LoginLoadingIndicator", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(BizViewController.LogindisLoadingIndicator), name: "LogindisLoadingIndicator", object: nil)
    }
    
    //Mark : show and dis show indicator -- not work now
    func LoginLoadingIndicator()
    {
        indicator = Indicator(view: view, message: "ورود...")
    }
    func LogindisLoadingIndicator()
    {
        indicator.hide()
    }
    
    //MARK : Table View Impls
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 4
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = UITableViewCell()
        
    
            
            if indexPath.row == 0 {
                
                let cell = tableView.dequeueReusableCellWithIdentifier("Biz Description", forIndexPath: indexPath) as! HeaderDescriptionTableViewCell
                cell.Biz = self.Biz
                //cell.delegate = self
                cell.selectionStyle = UITableViewCellSelectionStyle.None
                return cell
            }
            else if indexPath.row == 1
            {
                
                let cell = tableView.dequeueReusableCellWithIdentifier("Biz Info", forIndexPath: indexPath) as! HeaderInfoTableViewCell
                cell.layer.backgroundColor = UIColor(red: 250/255, green: 250/255, blue: 250/255, alpha: 1).CGColor
                cell.Biz = self.Biz
                cell.delegate = self
                cell.selectionStyle = UITableViewCellSelectionStyle.None
                return cell
            }else if indexPath.row == 2
            {
                
                let cell = tableView.dequeueReusableCellWithIdentifier("Biz Comment", forIndexPath: indexPath) as! BizMyComment
                cell.delegate = self
                cell.set = true
                cell.selectionStyle = UITableViewCellSelectionStyle.None
                return cell
            }else if indexPath.row == 3
            {
                
                let cell = tableView.dequeueReusableCellWithIdentifier("Biz Comments", forIndexPath: indexPath) as! CommentsTableViewCell
                cell.Biz = self.Biz
                cell.layer.backgroundColor = UIColor.groupTableViewBackgroundColor().CGColor
                cell.selectionStyle = UITableViewCellSelectionStyle.None
                return cell
            }
    
        return cell
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        if indexPath.row == 0 {
            
            return 96
        }
        else if indexPath.row == 1
        {
            
            return 140
        }
        else if indexPath.row == 2
        {
            
            return 150
        }
        else if indexPath.row == 3
        {
            return 400
        }
        
        return 0
    }
    func LoadCommntsDataError() {
        
        
    }
    func LoadCommntsResponseError() {
        
        
    }
    func LoadCommntsConnectionError() {
        
        
    }
    
    //Mark : Going to Another View
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "Maping"
        {
            let detailViewController = segue.destinationViewController as! MapViewController
            detailViewController.Biz = self.Biz
            detailViewController.transitioningDelegate = detailTransitioningDelegate
            detailViewController.modalPresentationStyle = .Custom
        }
        else if segue.identifier == "Gallery"
        {
            let detailViewController = segue.destinationViewController as! GalleryViewController
            detailViewController.Biz = self.Biz
            detailViewController.transitioningDelegate = detailTransitioningDelegate
            detailViewController.modalPresentationStyle = .Custom
        }
        else if segue.identifier  == "Add Comment" {
            
            if pagingType == 3 {//not from what_where
                
                commentOrSearchFirst = 1
                //do nothing
            }
            else
            {
                commentOrSearchFirst = 1
                commentPagingType = 3
                selectedBiz = self.Biz
                currentSelectedBiz = selectedBiz.id
                currentSelectedBizIndex = -1
                pagingType = 0
                /*if let bizViewController = segue.destinationViewController as? commentViewController {
                 
                 //bizViewController.BizID = nearestBizes[sender as! Int].id
                 selectedBiz = nearestBizes[sender as! Int]
                 currentSelectedBiz = selectedBiz.id
                 currentSelectedBizIndex = sender as! Int
                 pagingType = 1
                 }*/
            }
        }
        else if segue.identifier == "simpleBizs"
        {
            simpleBizesORFavs = true
        }
    }
    
    //MArk : View Functionality Like More...,Locatation,Recomendeds,....
    func star(cell: BizHeader) {//dont usage
        
        
    }
    func off(cell: BizHeader) {
        
        
    }
    func _fav(cell: BizHeader) {
        
        //do nothing
    }
    func call(cell: HeaderInfoTableViewCell) {
        
        if Biz.phone != "" {
            
            if let url = NSURL(string: "tel://\(self.Biz.phone)") {
                
                print("call")
                UIApplication.sharedApplication().openURL(url)
            }
        }
    }
    func moreInfo(cell: HeaderInfoTableViewCell) {
        
        /*let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("moreInfo") 
        vc.transitioningDelegate = self.detailTransitioningDelegate
        vc.modalPresentationStyle = .Custom
        presentViewController(vc, animated: true, completion:nil)*/
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let content = storyboard.instantiateViewControllerWithIdentifier("moreInfo")
        let partialModal: EMPartialModalViewController = EMPartialModalViewController(rootViewController: content, contentHeight: UIScreen.mainScreen().bounds.height - 100)
        
        self.presentViewController(partialModal, animated: true)
        {
            print("presenting view controller - done")
        }
    }
    func map(cell: HeaderInfoTableViewCell) {
        
        //self.performSegueWithIdentifier("Maping", sender: self)
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("Map") as! MapViewController
        vc.Biz = self.Biz
        vc.transitioningDelegate = detailTransitioningDelegate
        vc.modalPresentationStyle = .Custom
        presentViewController(vc, animated: true, completion:nil)
    }
    func order(cell: HeaderInfoTableViewCell) {
        
        if reachabilityStatus == KNOTREACHABLE || _NOP {
            
            return
        }
        self.performSegueWithIdentifier("simpleBizs", sender: self)
    }
    func moreImage(heaser: BizHeader) {
        
        print("galleryCliecked")
        if Biz.imageURLS.count > 1 {
            
            //self.performSegueWithIdentifier("Gallery", sender: self)
            let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewControllerWithIdentifier("Gallery") as! GalleryViewController
            vc.Biz = self.Biz
            vc.transitioningDelegate = detailTransitioningDelegate
            vc.modalPresentationStyle = .Custom
            presentViewController(vc, animated: true, completion:nil)
        }
    }
    func commentOnBiz(cell: BizMyComment) {
        
        self.performSegueWithIdentifier("Add Comment", sender: self)
    }
}

extension BizViewController:UIScrollViewDelegate
{
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        updateHeaderView()
    }
}

