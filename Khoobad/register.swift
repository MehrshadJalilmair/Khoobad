//
//  register.swift
//  Khoobad
//
//  Created by Mehrshad Jalilmasir on 7/13/16.
//  Copyright © 2016 Mehrshad Jalilmasir. All rights reserved.
//

import UIKit

class register: UIViewController {

    @IBOutlet var name: UITextField!
    @IBOutlet var family: UITextField!
    @IBOutlet var email: UITextField!
    @IBOutlet var phone: UITextField!
    @IBOutlet var pass: UITextField!
    @IBOutlet var send: UIButton!
    
    let appearance = SCLAlertView.SCLAppearance(
        showCloseButton: false
    )
    var Waiting = SCLAlertView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        send.layer.cornerRadius = 3.5
        send.layer.masksToBounds = true
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.Plain, target:nil, action:nil)
        
        /*email.text = user.email
        name.text = user.name
        family.text = user.family
        pass.text = user.pass*/
        
        if let font = UIFont(name: "B Yekan", size: 15) {
            
            self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName :font , NSForegroundColorAttributeName: UIColor.whiteColor()]
        }
        //if user.registerProcessing {
            
            //performSegueWithIdentifier("activeAccount", sender: self)
        //}
    }
    
    @IBAction func sendReq(sender: AnyObject) {
        
        Waiting = SCLAlertView(appearance: appearance)
        
        if reachabilityStatus == KNOTREACHABLE || _NOP{
            
            SCLAlertView(appearance: appearance).showError("خطای اتصال", subTitle: "اینترنت خود را بررسی کنید", closeButtonTitle: "متوجه شدم!", duration: 1, colorStyle: 0x0B93BF, colorTextButton: 0x000000, circleIconImage: nil , animationStyle: SCLAnimationStyle.NoAnimation)
            return
        }
        
        if name.text == "" {
            
            SCLAlertView(appearance: appearance).showError("ورودی بدون مقدار", subTitle: "نام را وارد کنید", closeButtonTitle: "متوجه شدم!", duration: 1, colorStyle: 0x0B93BF, colorTextButton: 0x000000, circleIconImage: nil , animationStyle: SCLAnimationStyle.NoAnimation)
        }
        else if family.text == "" {
            
            SCLAlertView(appearance: appearance).showError("ورودی بدون مقدار", subTitle: "نام خانوادگی  را وارد کنید", closeButtonTitle: "متوجه شدم!", duration: 1, colorStyle: 0x0B93BF, colorTextButton: 0x000000, circleIconImage: nil , animationStyle: SCLAnimationStyle.NoAnimation)
        }
        else if email.text == "" {
            
            SCLAlertView(appearance: appearance).showError("ورودی بدون مقدار", subTitle: "ایمیل را وارد کنید", closeButtonTitle: "متوجه شدم!", duration: 1, colorStyle: 0x0B93BF, colorTextButton: 0x000000, circleIconImage: nil , animationStyle: SCLAnimationStyle.NoAnimation)
        }
        else if !validEmail(email.text!)
        {
            SCLAlertView(appearance: appearance).showError("ورودی اشتباه", subTitle: "ایمیل را به صورت صحیح وارد کنید", closeButtonTitle: "متوجه شدم!", duration: 1, colorStyle: 0x0B93BF, colorTextButton: 0x000000, circleIconImage: nil , animationStyle: SCLAnimationStyle.NoAnimation)
        }
        else if !validPhone(email.text!)
        {
            SCLAlertView(appearance: appearance).showError("ورودی اشتباه", subTitle: "شماره موبایل را به صورت صحیح وارد کنید", closeButtonTitle: "متوجه شدم!", duration: 1, colorStyle: 0x0B93BF, colorTextButton: 0x000000, circleIconImage: nil , animationStyle: SCLAnimationStyle.NoAnimation)
        }
        else if pass.text == "" {
            
            SCLAlertView(appearance: appearance).showError("ورودی بدون مقدار", subTitle: "رمز را وارد کنید", closeButtonTitle: "متوجه شدم!", duration: 1, colorStyle: 0x0B93BF, colorTextButton: 0x000000, circleIconImage: nil , animationStyle: SCLAnimationStyle.NoAnimation)
        }
        else
        {
            Waiting.showWait("لطفا صبور باشید...", subTitle: "", closeButtonTitle: "", duration: 1000, colorStyle: 0x0B93BF, colorTextButton: 0x000000, circleIconImage: nil, animationStyle: SCLAnimationStyle.NoAnimation)
            
            user.name = name.text!
            user.email = email.text!
            user.family = family.text!
            user.pass = pass.text!
            
            self.register()
        }
    }
    func validEmail(string:String)->Bool
    {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    
        return emailTest.evaluateWithObject(string)
    }
    func validPhone(string:String)->Bool
    {
        if !string.containsString("@"){
            
            if NSString(string: string).length < 11 {
                
                return false
            }
        }
        return true
    }
    func register()
    {
        let URL:NSURL = NSURL(string: URLS.register)!
        let loginReq : NSMutableURLRequest = NSMutableURLRequest(URL: URL)
        
        let bodyData = String.localizedStringWithFormat("email=%@&password=%@&name=%@&lastname=%@", user.email , user.pass , user.name , user.family)
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
            
            let _user = try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions())
            
            let status = _user["status"] as! String
            
            print(_user)
            if status == "-2"
            {
                SCLAlertView(appearance: self.appearance).showError("کاربر ثبت شده", subTitle: "این نام کاربری قبلا ثبت شده است", closeButtonTitle: "متوجه شدم!", duration: 2, colorStyle: 0x0B93BF, colorTextButton: 0x000000, circleIconImage: nil , animationStyle: SCLAnimationStyle.NoAnimation)
            }
            else if status == "1"
            {
                SCLAlertView(appearance: self.appearance).showSuccess("کاربر ثبت شد", subTitle: "کد فعالسازی برای شما ارسال شد", closeButtonTitle: "متوجه شدم!", duration: 3, colorStyle: 0x00EE00, colorTextButton: 0x000000, circleIconImage: nil , animationStyle: SCLAnimationStyle.NoAnimation)
                user.activationCode = (_user["activation_token"] as? Int)!
                self.performSegueWithIdentifier("activeAccount", sender: self)
            }
        })
    }
    
    @IBAction func iHaveCode(sender: AnyObject) {
        
        user.email = email.text!
        
        if user.email == ""
        {
           SCLAlertView(appearance: appearance).showError("ورودی بدون مقدار", subTitle: "فقط نام کاربری را وارد کنید", closeButtonTitle: "متوجه شدم!", duration: 2, colorStyle: 0x0B93BF, colorTextButton: 0x000000, circleIconImage: nil , animationStyle: SCLAnimationStyle.NoAnimation)
            return
        }
        
        self.performSegueWithIdentifier("justActive", sender: self)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        self.view.endEditing(true)
    }
}
