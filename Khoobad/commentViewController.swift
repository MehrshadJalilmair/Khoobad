//
//  commentViewController.swift
//  Khoobad
//
//  Created by Mehrshad Jalilmasir on 6/15/16.
//  Copyright © 2016 Mehrshad Jalilmasir. All rights reserved.
//

import UIKit

var logRegRequest = false
var commentOrSearchFirst = -1
var commentPagingType = -1//after ok func comment go to which page in back

class commentViewController: UIViewController , UITextViewDelegate{

    //Mark Just Varabiles
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    @IBOutlet weak var rateBar: CosmosView!
    @IBOutlet weak var comment: UITextView!
    @IBOutlet weak var sendBtn: UIButton!
    @IBOutlet weak var searchCommentPage: UIView!
    
    @IBOutlet weak var Khoob: M13Checkbox!
    
    @IBOutlet weak var Motevaset: M13Checkbox!
    
    @IBOutlet weak var Zaeef: M13Checkbox!
    
    var openion:String = "0"
    
    var flag:Bool = false // rated
    
    var alert = SCLAlertView()
    let appearance = SCLAlertView.SCLAppearance(
        showCloseButton: false,
        kTitleFont: UIFont(name: "HelveticaNeue", size: 14)!,
        kTextFont: UIFont(name: "HelveticaNeue", size: 12)!,
        kButtonFont: UIFont(name: "HelveticaNeue-Bold", size: 12)!
    )
    
    @IBOutlet var arzid: UIButton!
    @IBOutlet var nyarzid: UIButton!
    @IBOutlet var middarzid: UIButton!
    
    
    //Mark : Loading
    override func viewDidLoad() {
        super.viewDidLoad()
        
        InitUI()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(commentViewController.popToRoot), name: "popToRoot", object: nil)
    }
    override func viewDidDisappear(animated: Bool) {
        
        if commentPagingType != 3 {
            
            commentOrSearchFirst = -1
        }
        
        print("viewDidDisappear")
    }
    override func viewWillLayoutSubviews() {
        
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(commentViewController.handleSwipes(_:)))
        leftSwipe.direction = .Right
        view.addGestureRecognizer(leftSwipe)
    }
    func handleSwipes(sender:UISwipeGestureRecognizer) {
        
        if (sender.direction == .Right) {
            
            self.navigationController?.popToRootViewControllerAnimated(true)//back to previous
        }
    }
    func popToRoot()
    {
        self.navigationController?.popToRootViewControllerAnimated(true)//back to previous
    }
    override func viewWillAppear(animated: Bool) {
        
        print("currentSelectedBiz viewWillAppear")
        InitUI()
    }
    func InitUI()
    {
        arzid.titleLabel?.textAlignment = .Right
        nyarzid.titleLabel?.textAlignment = .Right
        middarzid.titleLabel?.textAlignment = .Right
        
        /*if let font = UIFont(name: "B Yekan", size: 15) {
            
            self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName :font , NSForegroundColorAttributeName: UIColor.whiteColor()]
        }*/
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.Plain, target:nil, action:nil)
        //comment.contentVerticalAlignment = UIControlContentVerticalAlignment.Top
        //comment.layer.cornerRadius = 3.0
        //comment.layer.shadowColor = UIColor.clearColor().CGColor
        //comment.layer.borderColor = UIColor.clearColor().CGColor
        
        if commentOrSearchFirst == 55
        {
            commentOrSearchFirst = 1
        }
        print("currentSelectedBiz \(currentSelectedBiz)")
        if commentOrSearchFirst == -1 {
            
            searchCommentPage.hidden = false

            //self.title = ""
        }
        else
        {
            self.title = "دیدگاه من"
            searchCommentPage.hidden = true
            //comment.backgroundColor = UIColor.whiteColor()
            comment.layer.cornerRadius = 10.0
            comment.layer.masksToBounds = false
            comment.layer.shadowColor = UIColor.blackColor().colorWithAlphaComponent(0.5).CGColor
            comment.layer.shadowOffset = CGSize(width: 0, height: 0)
            comment.layer.shadowOpacity = 0.8
            comment.textColor = UIColor.lightGrayColor()
            
            //comment.becomeFirstResponder()
            comment.selectedTextRange = comment.textRangeFromPosition(comment.beginningOfDocument, toPosition: comment.beginningOfDocument)
            
            comment.text = "نظر من برای \(selectedBiz.name)"
            
            comment.textAlignment = .Right
            comment.delegate = self
        
            //comment.insertText("نظر من برای \(selectedBiz.name)...")
            rateBar.rating = 0.5
            rateBar.text = "1"
            rateBar.settings.updateOnTouch = true
            rateBar.textSize = 12
            // Show only fully filled stars
            rateBar.settings.fillMode = .Half
            // Set the distance between stars
            rateBar.settings.starMargin = 5
            // Set the color of a filled star
            rateBar.settings.filledColor = UIColor(red: 240/255, green: 203/255, blue: 22/255, alpha: 1)
            // Set the border color of an empty star
            rateBar.settings.emptyBorderColor = UIColor(red: 240/255, green: 203/255, blue: 22/255, alpha: 1)
            // Set the border color of a filled star
            rateBar.settings.filledBorderColor = UIColor(red: 240/255, green: 203/255, blue: 22/255, alpha: 1)
            rateBar.didFinishTouchingCosmos = didTouchCosmos

            //Khoob.checkState = M13Checkbox.CheckState.Checked
            print("\(currentSelectedBiz)")
        }
        if let font = UIFont(name: "B Yekan", size: 12) {
            
            self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName :font , NSForegroundColorAttributeName: UIColor.whiteColor()]
        }
    }
    private func didTouchCosmos(rating: Double) {
    
        if rating == 0.0 {
            
            rateBar.rating = 0.5
            rateBar.text = "1"
        }
        print("rating")
        flag = true
        rateBar.text = "\(Int(2*rateBar.rating))/10"
    }
    
    //Mark : Send Comment To server
    @IBAction func sendClicked(sender: AnyObject) {
        
        if user.isLogin {
            
            let rate = 2*rateBar.rating
            
            if comment.textColor == UIColor.lightGrayColor(){
                
                comment.text = ""
            }
            
            HomeBizComment.postComment(comment.text!, rate: rate , biz_id: currentSelectedBiz , openion: openion , user_id: user.id , token: user.userToken)
            alert = SCLAlertView(appearance: appearance)
            alert.dismissViewControllerAnimated(true
                , completion: { 
                    
                    self.ok()
            })
            alert.dismissBlock = ({
                
                self.ok()
            })
            //self.alert.addButton("تایید", target: self, selector: "ok")
            self.alert.showSuccess("نظر شما تا لحظاتی دیگر ثبت خواهد شد!", subTitle: "" , closeButtonTitle: "بازگشت" , duration: 1 , colorStyle: 0x00EE00 , colorTextButton: 0x000000)
        }
        else
        {
            logRegRequest = true
            let tababarController = appDelegate.window!.rootViewController as! RAMAnimatedTabBarController
            tababarController.setSelectIndex(from: 2, to: 1)
        }
    }
    func ok()
    {
        /*let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("TabBar")
        self.presentViewController(vc, animated: true, completion: nil)*/
        //self.navigationController?.pushViewController(vc, animated: true)
        //performSegueWithIdentifier("backCommentDone" , sender: self)
        //tabBarController?.selectedIndex = 1
        
        commentOrSearchFirst = -1
        
        if commentPagingType == 3 || commentPagingType == 0 {
            
            navigationController?.popViewControllerAnimated(true)
            //self.navigationController?.popToRootViewControllerAnimated(true)
            tabBarController?.selectedIndex = 0
        }
        else if commentPagingType == 1
        {
            self.navigationController?.popToRootViewControllerAnimated(true)//back to previous
        }
        else if commentPagingType == 2
        {
            tabBarController?.selectedIndex = 0
        }
    }
    

    
    @IBAction func KhoobCh(sender: AnyObject) {
        
        print("didFinishTouchingCosmos")
        
        if Khoob.checkState == M13Checkbox.CheckState.Checked {
            
            openion = "0"
            //Khoob.setCheckState(M13Checkbox.CheckState.Unchecked, animated: true)
            Motevaset.checkState = M13Checkbox.CheckState.Unchecked
            Zaeef.checkState = M13Checkbox.CheckState.Unchecked
        }
        else
        {
            Khoob.setCheckState(M13Checkbox.CheckState.Checked, animated: true)
            Motevaset.checkState = M13Checkbox.CheckState.Unchecked
            Zaeef.checkState = M13Checkbox.CheckState.Unchecked
            openion = "3"
        }
    }
    
    @IBAction func MotCh(sender: AnyObject) {
        
        if Motevaset.checkState == M13Checkbox.CheckState.Checked {
            
            openion = "0"
            //Motevaset.setCheckState(M13Checkbox.CheckState.Unchecked, animated: true)
            Khoob.checkState = M13Checkbox.CheckState.Unchecked
            Zaeef.checkState = M13Checkbox.CheckState.Unchecked
        }
        else
        {
            Motevaset.setCheckState(M13Checkbox.CheckState.Checked, animated: true)
            Khoob.checkState = M13Checkbox.CheckState.Unchecked
            Zaeef.checkState = M13Checkbox.CheckState.Unchecked
            openion = "2"
        }
    }
    
    @IBAction func ZaeefChanged(sender: AnyObject) {
     
        if Zaeef.checkState == M13Checkbox.CheckState.Checked {
            
            openion = "0"
            //Zaeef.setCheckState(M13Checkbox.CheckState.Unchecked, animated: true)
            Khoob.checkState = M13Checkbox.CheckState.Unchecked
            Motevaset.checkState = M13Checkbox.CheckState.Unchecked
        }
        else
        {
            Zaeef.setCheckState(M13Checkbox.CheckState.Checked, animated: true)
            Khoob.checkState = M13Checkbox.CheckState.Unchecked
            Motevaset.checkState = M13Checkbox.CheckState.Unchecked
            openion = "1"
        }
    }
    
    @IBAction func KhoobCh1(sender: AnyObject) {
        
        
        print("didFinishTouchingCosmos")
        
        if Khoob.checkState == M13Checkbox.CheckState.Checked {
            
            openion = "0"
            //Khoob.setCheckState(M13Checkbox.CheckState.Unchecked, animated: true)
        }
        else
        {
            Khoob.setCheckState(M13Checkbox.CheckState.Checked, animated: true)
            Motevaset.checkState = M13Checkbox.CheckState.Unchecked
            Zaeef.checkState = M13Checkbox.CheckState.Unchecked
            openion = "3"
        }
    }
    
    @IBAction func MotCh1(sender: AnyObject) {
        
        if Motevaset.checkState == M13Checkbox.CheckState.Checked {
            
            openion = "0"
            //Motevaset.setCheckState(M13Checkbox.CheckState.Unchecked, animated: true)
        }
        else
        {
            Motevaset.setCheckState(M13Checkbox.CheckState.Checked, animated: true)
            Khoob.checkState = M13Checkbox.CheckState.Unchecked
            Zaeef.checkState = M13Checkbox.CheckState.Unchecked
            openion = "2"
        }
    }
    
    @IBAction func ZaeefChanged1(sender: AnyObject) {
        

        if Zaeef.checkState == M13Checkbox.CheckState.Checked {
            
            openion = "0"
            //Zaeef.setCheckState(M13Checkbox.CheckState.Unchecked, animated: true)
        }
        else
        {
            Zaeef.setCheckState(M13Checkbox.CheckState.Checked, animated: true)
            Khoob.checkState = M13Checkbox.CheckState.Unchecked
            Motevaset.checkState = M13Checkbox.CheckState.Unchecked
            openion = "1"
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        self.view.endEditing(true)
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool{
        
        // Combine the textView text and the replacement text to
        // create the updated text string
        let currentText:NSString = comment.text
        let updatedText = currentText.stringByReplacingCharactersInRange(range, withString:text)
        
        // If updated text view will be empty, add the placeholder
        // and set the cursor to the beginning of the text view
        if updatedText.isEmpty {
            
            comment.text = "نظر من برای \(selectedBiz.name)"
            comment.textColor = UIColor.lightGrayColor()
            
            comment.selectedTextRange = comment.textRangeFromPosition(comment.beginningOfDocument, toPosition: comment.beginningOfDocument)
            
            return false
        }
            
            // Else if the text view's placeholder is showing and the
            // length of the replacement string is greater than 0, clear
            // the text view and set its color to black to prepare for
            // the user's entry
        else if comment.textColor == UIColor.lightGrayColor() && !text.isEmpty {
            comment.text = nil
            comment.textColor = UIColor.blackColor()
        }
        
        return true
    }
}
