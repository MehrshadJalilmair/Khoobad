//
//  registerBiz.swift
//  Khoobad
//
//  Created by Mehrshad Jalilmasir on 7/18/16.
//  Copyright © 2016 Mehrshad Jalilmasir. All rights reserved.
//

import UIKit

var registerbiz:BizForRegister = BizForRegister()

class registerBiz: UIViewController , UITextFieldDelegate {

    let appearance = SCLAlertView.SCLAppearance(
        showCloseButton: false
    )
    var Waiting = SCLAlertView()
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let font = UIFont(name: "B Yekan", size: 15) {
            
            self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName :font , NSForegroundColorAttributeName: UIColor.whiteColor()]
        }
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(registerBiz.hideKeyboard))
        tapGesture.cancelsTouchesInView = true
        tableView.addGestureRecognizer(tapGesture)
        
        sharedVars.getCategories()
        navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.Plain, target:nil, action:nil)
    }
    
    func hideKeyboard() {
        tableView.endEditing(true)
    }
    
    override func viewWillAppear(animated: Bool) {
        
        tableView.reloadData()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        
        return 1
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("registerBizCell", forIndexPath: indexPath) as! registerBizCell
        
        cell.set = true
        
        cell.selectionStyle = .None
        
        return cell
    }
    
    @IBAction func confirm(sender: AnyObject) {
        
        if reachabilityStatus == KNOTREACHABLE || _NOP{
            
            SCLAlertView(appearance: appearance).showError("خطای اتصال", subTitle: "اینترنت خود را بررسی کنید", closeButtonTitle: "متوجه شدم!", duration: 1, colorStyle: 0x0B93BF, colorTextButton: 0x000000, circleIconImage: nil , animationStyle: SCLAnimationStyle.NoAnimation)
            return
        }
        
        if registerbiz.name == "" {
            
            SCLAlertView(appearance: appearance).showError("ورودی بدون مقدار", subTitle: "نام را وارد کنید", closeButtonTitle: "متوجه شدم!", duration: 1, colorStyle: 0x0B93BF, colorTextButton: 0x000000, circleIconImage: nil , animationStyle: SCLAnimationStyle.NoAnimation)
            return
        }
        else if registerbiz.phone == "" {
            
            SCLAlertView(appearance: appearance).showError("ورودی بدون مقدار", subTitle: "تلفن را وارد کنید", closeButtonTitle: "متوجه شدم!", duration: 1, colorStyle: 0x0B93BF, colorTextButton: 0x000000, circleIconImage: nil , animationStyle: SCLAnimationStyle.NoAnimation)
            return
        }
        else if registerbiz.address == "" {
            
            SCLAlertView(appearance: appearance).showError("ورودی بدون مقدار", subTitle: "آدرس را وارد کنید", closeButtonTitle: "متوجه شدم!", duration: 1, colorStyle: 0x0B93BF, colorTextButton: 0x000000, circleIconImage: nil , animationStyle: SCLAnimationStyle.NoAnimation)
            return
        }
        else if registerbiz.categories.count == 0
        {
            SCLAlertView(appearance: appearance).showError("ورودی اشتباه", subTitle: "دسته بندی انتحاب نشده", closeButtonTitle: "متوجه شدم!", duration: 1, colorStyle: 0x0B93BF, colorTextButton: 0x000000, circleIconImage: nil , animationStyle: SCLAnimationStyle.NoAnimation)
            return
        }
        else if registerbiz.lat == 0.0{
            
            SCLAlertView(appearance: appearance).showError("ورودی بدون مقدار", subTitle: "آدرس را روی نقشه انتخاب کنید کنید", closeButtonTitle: "متوجه شدم!", duration: 1, colorStyle: 0x0B93BF, colorTextButton: 0x000000, circleIconImage: nil , animationStyle: SCLAnimationStyle.NoAnimation)
            return
        }
        Confirm()
    }
    
    func Confirm()
    {
        let URL:NSURL = NSURL(string: URLS.add_biz)!
        let loginReq : NSMutableURLRequest = NSMutableURLRequest(URL: URL)
        
        print("\(user.id) \(user.userToken)  \(registerbiz.lat) \(registerbiz.long) \(registerbiz.name)  \(registerbiz.phone) \(registerbiz.off)")
        
        if registerbiz.desc == "" {
            
            registerbiz.desc = " "
        }
        if registerbiz.website == "" {
            
            registerbiz.website = " "
        }
        
        Waiting = SCLAlertView(appearance: appearance)
        Waiting.showWait("لطفا صبور باشید...", subTitle: "", closeButtonTitle: "", duration: 1000, colorStyle: 0x0B93BF, colorTextButton: 0x000000, circleIconImage: nil, animationStyle: SCLAnimationStyle.NoAnimation)
        
        var selectedCategories = ""
        
        for object in registerbiz.categories {
            
            selectedCategories = selectedCategories + object.1.category_id + ","
        }
        print(selectedCategories)
        
        var bodyData = String.localizedStringWithFormat("user_id=%@&token=%@&lat=%@&long=%@&name=%@&phone=%@&address=%@&off=%@&categories=%@&website=%@&description=%@&slogan=%@&uuid=%@", "\(user.id)" , user.userToken , String(registerbiz.lat) , String(registerbiz.long) , registerbiz.name , registerbiz.phone , registerbiz.address, registerbiz.off , selectedCategories , registerbiz.website , registerbiz.desc , "" , "")
        bodyData = bodyData.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
        
        loginReq.HTTPMethod = "POST"
        loginReq.HTTPBody = bodyData.dataUsingEncoding(NSUTF8StringEncoding)
        
        print(bodyData)
        
        NSURLConnection.sendAsynchronousRequest(loginReq, queue: NSOperationQueue.mainQueue(), completionHandler: { (response , data , error) in
            
            self.Waiting.hideView()
            
            if data == nil{
                
                return
            }
            guard let httpResponse = response as? NSHTTPURLResponse
                else
            {
                return
            }
            
            print(httpResponse.statusCode)
            
            if httpResponse.statusCode < 200 || httpResponse.statusCode >= 300 //|| httpResponse.MIMEType == "application/json"
            {
                return
            }
            
            let registerbiz_ = try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions())
            
            let status = registerbiz_["status"] as! String
            
            print(registerbiz_)
            if status == "-2"
            {
                SCLAlertView(appearance: self.appearance).showError("ثبت انجام نشد!", subTitle: "", closeButtonTitle: "متوجه شدم!", duration: 2, colorStyle: 0x0B93BF, colorTextButton: 0x000000, circleIconImage: nil , animationStyle: SCLAnimationStyle.NoAnimation)
            }
            else if status == "1"
            {
                SCLAlertView(appearance: self.appearance).showSuccess("کسب و کار ثبت شد", subTitle: "با شما تماس میگیریم", closeButtonTitle: "متوجه شدم!", duration: 3, colorStyle: 0x00EE00, colorTextButton: 0x000000, circleIconImage: nil , animationStyle: SCLAnimationStyle.NoAnimation)
            }
            registerbiz.name = ""
            registerbiz.address = ""
            registerbiz.phone = ""
            registerbiz.website = ""
            registerbiz.desc = ""
            registerbiz.categories = [String:cat]()
            registerbiz.off = ""
            registerbiz.lat = 0.0
            registerbiz.long = 0.0
            
            self.parentViewController?.dismissViewControllerAnimated(true) {
                print("dismissing view controller - done")
            }
        })
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        self.view.endEditing(true)
    }
}
