//
//  User.swift
//  Khoobad
//
//  Created by Mehrshad Jalilmasir on 6/7/16.
//  Copyright © 2016 Mehrshad Jalilmasir. All rights reserved.
//

import UIKit
import CoreLocation

class User: NSObject , CLLocationManagerDelegate{
    
    //set location manager
    var locationManager : CLLocationManager!
    var location: CLLocation!{
        
        didSet{//when location is changed
        
        var wich = true;
        locationManager.stopUpdatingLocation()
        
        if (reachabilityStatus == KNOTREACHABLE){
            
            wich = false//local
        }
        else {
            
            wich = true//net
        }
        //32.6340867,51.6791475
        user.lat = 32.6340867//location.coordinate.latitude//32.318989//location.coordinate.latitude
        user.long = 51.6791475//ocation.coordinate.longitude//50.869474//location.coordinate.longitude
        user.havePos = true
        
        db.googleApi(0)
        db.googleApi(1)
        /*if !db.getLocalDBStatus()//get db
        {
            db.googleApi()
        }
        else
        {
            //update local db?
            let diffDateComponents = NSCalendar.currentCalendar().components([NSCalendarUnit.Year, NSCalendarUnit.Month, NSCalendarUnit.Day, NSCalendarUnit.Hour, NSCalendarUnit.Minute, NSCalendarUnit.Second] , fromDate: NSDate(), toDate: db.getLocalDBLastUpdate(), options: NSCalendarOptions.init(rawValue: 0))
            if diffDateComponents.day > 3 {
            
                db.googleApi()
            }
        }*/
        
        if reachabilityStatus == KNOTREACHABLE || _NOP {
            
            print("load local rates")
            if db.getOstanRatesRecord(user.lat, long: user.long).count > 0 {
                
                dbRatesLines = (db.getOstanRatesRecord(user.lat, long: user.long)[0].valueForKey("ratesText") as! String).componentsSeparatedByString("\n")
                
                for rate in dbRatesLines
                {
                    dbRates.append(rate.componentsSeparatedByString("\t"))
                }
            }
        }
        
        HomeBiz.getBizes(user.lat, long: user.long, NetOrLoc: wich)
        }
    }

    //user Info
    var activationCode = 0
    var registerProcessing = false
    var long :CLLocationDegrees!
    var lat :CLLocationDegrees!
    var name = ""
    var family = ""
    var phone = ""
    var id = 0
    var email:String = ""
    var pass = ""
    var imageAddress = ""
    var image = UIImage(named: "26.jpg")
    internal var havePos = false
    var isLogin:Bool = false
    var deviceID:String = ""
    var userToken:String = ""
    var usernametextField: UITextField!
    var passwordtextField: UITextField!
    var loginAlert = SCLAlertView()
    let appearance = SCLAlertView.SCLAppearance(
        showCloseButton: false
    )
    var Waiting = SCLAlertView()
    var Success = SCLAlertView()
    
    init(lat : CLLocationDegrees , long : CLLocationDegrees , deviceID:String , name:String , pass:String , email:String , imageAddress:String , id:Int , havePOS:Bool , isLogin:Bool , userToken:String , phone:String, family:String) {
        
        super.init()
        
        self.lat = lat
        self.long = long
        self.havePos = havePOS
        self.deviceID = deviceID
        self.id = id
        self.name = name
        self.email = email
        self.imageAddress = imageAddress
        self.isLogin = isLogin
        self.pass = pass
        self.userToken = userToken
        self.phone = phone
        self.family = family
        
        //if we get pos then getting from server or local started
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter=kCLDistanceFilterNone;
        chaeckLocationManagerPermission()
    }
    
    //MARK : Setting Up location managering
    func chaeckLocationManagerPermission()
    {
        if CLLocationManager.authorizationStatus() == .AuthorizedWhenInUse {
            
            locationManager.startUpdatingHeading()
        }
        else if CLLocationManager.authorizationStatus() == .NotDetermined
        {
            
            locationManager.requestAlwaysAuthorization()
        }
        else if CLLocationManager.authorizationStatus() == .Restricted
        {
            //you dont have location
            //alert view showing
            return
        }
        locationManager.startUpdatingLocation()
    }
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        location = locations.last
        
        print("1")
    }
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        
        print("Error while updating location " + error.localizedDescription)
    }
    
    //Mark : prepareLogin
    func login()
    {
        let appearance = SCLAlertView.SCLAppearance(
            kTitleFont: UIFont(name: "HelveticaNeue", size: 20)!,
            kTextFont: UIFont(name: "HelveticaNeue", size: 14)!,
            kButtonFont: UIFont(name: "HelveticaNeue-Bold", size: 14)!
        )
        
        // Initialize SCLAlertView using custom Appearance
        self.loginAlert = SCLAlertView(appearance: appearance)
        
        // Creat the subview
        let subview = UIView(frame: CGRectMake(0,0,216,70))
        let x = (subview.frame.width - 180) / 2
        
        // Add textfield 1
        usernametextField = UITextField(frame: CGRectMake(x,10,180,25))
        usernametextField.layer.borderColor = UIColor.lightGrayColor().CGColor
        usernametextField.layer.borderWidth = 1.5
        usernametextField.layer.cornerRadius = 5
        usernametextField.placeholder = "نام کاربری"
        usernametextField.autocorrectionType = UITextAutocorrectionType.No
        usernametextField.autocapitalizationType = UITextAutocapitalizationType.None
        usernametextField.font = UIFont(name: "HelveticaNeue-Bold", size: 14.0)
        usernametextField.textAlignment = NSTextAlignment.Center
        subview.addSubview(usernametextField)
        
        // Add textfield 2
        passwordtextField = UITextField(frame: CGRectMake(x,usernametextField.frame.maxY + 10,180,25))
        passwordtextField.secureTextEntry = true
        passwordtextField.layer.borderColor = UIColor.lightGrayColor().CGColor
        passwordtextField.layer.borderWidth = 1.5
        passwordtextField.layer.cornerRadius = 5
        passwordtextField.autocorrectionType = UITextAutocorrectionType.No
        passwordtextField.autocapitalizationType = UITextAutocapitalizationType.None
        passwordtextField.font = UIFont(name: "HelveticaNeue-Bold", size: 14.0)
        passwordtextField.placeholder = "رمز عبور"
        passwordtextField.textAlignment = NSTextAlignment.Center
        subview.addSubview(passwordtextField)
        
        // Add the subview to the alert's UI property
        self.loginAlert.customSubview = subview
        self.loginAlert.addButton("تایید", target: self, selector: #selector(User.doLogin))
        self.loginAlert.addButton("ثبت نام", target: self, selector: #selector(User.doRegister))
        self.loginAlert.addButton("فراموشی رمز عبور", target: self, selector: #selector(User.resetPass))
        // Add Button with Duration Status and custom Colors
        /*self.loginAlert.addButton("Duration Button", backgroundColor: UIColor.brownColor(), textColor: UIColor.yellowColor(), showDurationStatus: true) {
            print("Duration Button tapped")
        }*/
        
        self.loginAlert.showInfo("ورود", subTitle: "" , closeButtonTitle: "بازگشت" , duration: 222222 , colorStyle: 0x0B93BF , colorTextButton: 0x000000)
    }
    func doLogin()
    {
        self.email = usernametextField.text!
        self.pass = passwordtextField.text!
        
        let ErrorAlert = SCLAlertView(appearance: appearance)
        
        if self.email == ""
        {
            login()
            self.usernametextField.text = self.email
            ErrorAlert.showError("ورودی بدون مقدار", subTitle: "نام کاربری را وارد کنید", closeButtonTitle: "متوجه شدم!", duration: 1, colorStyle: 0x0B93BF, colorTextButton: 0x000000, circleIconImage: nil , animationStyle: SCLAnimationStyle.TopToBottom)
        }
        else if self.pass == ""
        {
            login()
            self.usernametextField.text = self.pass
            ErrorAlert.showError("ورودی بدون مقدار", subTitle: "رمز عبور را وارد کنید", closeButtonTitle: "متوجه شدم!", duration: 1, colorStyle: 0x0B93BF, colorTextButton: 0x000000, circleIconImage: nil , animationStyle: SCLAnimationStyle.TopToBottom)
        }
        else if !validEmail(usernametextField.text!)
        {
            login()
            SCLAlertView(appearance: appearance).showError("ورودی اشتباه", subTitle: "ایمیل را به صورت صحیح وارد کنید", closeButtonTitle: "متوجه شدم!", duration: 2, colorStyle: 0x0B93BF, colorTextButton: 0x000000, circleIconImage: nil , animationStyle: SCLAnimationStyle.TopToBottom)
        }
        else if !validPhone(usernametextField.text!)
        {
            login()
            SCLAlertView(appearance: appearance).showError("ورودی اشتباه", subTitle: "شماره موبایل را به صورت صحیح وارد کنید", closeButtonTitle: "متوجه شدم!", duration: 2, colorStyle: 0x0B93BF, colorTextButton: 0x000000, circleIconImage: nil , animationStyle: SCLAnimationStyle.TopToBottom)
        }
        else
        {
            print("\(user) \(pass)")
            //NSNotificationCenter.defaultCenter().postNotificationName("LoginLoadingIndicator", object: nil)
            Waiting = SCLAlertView(appearance: appearance)
            Waiting.showWait("لطفا صبور باشید...", subTitle: "", closeButtonTitle: "", duration: 1000, colorStyle: 0x0B93BF, colorTextButton: 0x000000, circleIconImage: nil, animationStyle: SCLAnimationStyle.NoAnimation)
            //
            
            let URL:NSURL = NSURL(string: URLS.login)!
            let loginReq : NSMutableURLRequest = NSMutableURLRequest(URL: URL)
            
            let bodyData = String.localizedStringWithFormat("email=%@&password=%@&imei=%@", self.email , self.self.pass , self.deviceID)
            loginReq.HTTPMethod = "POST"
            loginReq.HTTPBody = bodyData.dataUsingEncoding(NSUTF8StringEncoding)
            
            print(URL)
            
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
                let user = try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions())
                
                print(user)
                
                self.userToken = (user["token"] as! String)
                if self.userToken == ""
                {
                    self.login()
                    ErrorAlert.showError("خطا", subTitle: "نام کاربری یا رمزعبور نادرست", closeButtonTitle: "متوجه شدم!", duration: 1, colorStyle: 0xA429FF, colorTextButton: 0x000000, circleIconImage: nil , animationStyle: SCLAnimationStyle.TopToBottom)
                }
                else
                {
                    let userInfo = (user["user"] as? [String : AnyObject])
                    print(userInfo)
                    
                    let active = (userInfo!["active"] as! String)
                    
                    if active == "0"
                    {
                        ErrorAlert.showError("خطا", subTitle: "حساب شما تایید نشده است!", closeButtonTitle: "متوجه شدم!", duration: 2, colorStyle: 0xA429FF, colorTextButton: 0x000000, circleIconImage: nil , animationStyle: SCLAnimationStyle.TopToBottom)
                        return
                    }
                    
                    self.name = userInfo!["name"] as! String
                    self.family = (userInfo!["lastname"] as! String)
                    self.id = (userInfo!["id"] as! Int)
                    self.email = (userInfo!["email"] as! String)
                    
                    if (userInfo!["image_url"] is NSNull)
                    {
                        self.imageAddress = "default"
                    }
                    else
                    {
                        self.imageAddress = userInfo!["image_url"] as! String
                    }
                    
                    self.isLogin = true
                    self.profile()
                    
                    if (db.getUser().count > 0)
                    {
                        db.updateUser(self.name, lastname: self.family, email: self.email, token: self.userToken, pass: self.pass, id: self.id, ImageAdd: self.imageAddress, phone: self.phone, isLogin: true)
                        print("update user")
                    }
                    else
                    {
                        db.addUser(self.name, lastname: self.family, email: self.email, token: self.userToken, pass: self.pass, id: self.id, ImageAdd: self.imageAddress, phone: self.pass, isLogin: true)
                        print("add user")
                    }
                }
            })
        }
    }
    func profile()
    {
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let content = storyboard.instantiateViewControllerWithIdentifier("userProfile")
        let partialModal: EMPartialModalViewController = EMPartialModalViewController(rootViewController: content, contentHeight: 250)
        
        UIApplication.sharedApplication().keyWindow?.rootViewController?.presentViewController(partialModal, animated: true)
        {
            print("presenting view controller - done")
        }
    }
    func doRegister()
    {
        print("register")
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let content = storyboard.instantiateViewControllerWithIdentifier("register")
        var frame: CGRect = content.view.frame
        frame.size.height = UIScreen.mainScreen().bounds.height
        //content.view.frame = frame
        let partialModal: EMPartialModalViewController = EMPartialModalViewController(rootViewController: content , contentHeight: UIScreen.mainScreen().bounds.height - 200)
        
        UIApplication.sharedApplication().keyWindow?.rootViewController?.presentViewController(partialModal, animated: true)
        {
            print("presenting view controller - done")
        }
    }
    func resetPass()
    {
        if usernametextField.text! == "" {
            
            login()
            SCLAlertView(appearance: appearance).showError("ورودی بدون مقدار", subTitle: "نام کاربری را وارد کنید", closeButtonTitle: "متوجه شدم!", duration: 2, colorStyle: 0x0B93BF, colorTextButton: 0x000000, circleIconImage: nil , animationStyle: SCLAnimationStyle.TopToBottom)
        }
        else if !validEmail(usernametextField.text!)
        {
            login()
            SCLAlertView(appearance: appearance).showError("ورودی اشتباه", subTitle: "ایمیل را به صورت صحیح وارد کنید", closeButtonTitle: "متوجه شدم!", duration: 2, colorStyle: 0x0B93BF, colorTextButton: 0x000000, circleIconImage: nil , animationStyle: SCLAnimationStyle.TopToBottom)
        }
        else if !validPhone(usernametextField.text!)
        {
            login()
            SCLAlertView(appearance: appearance).showError("ورودی اشتباه", subTitle: "شماره موبایل را به صورت صحیح وارد کنید", closeButtonTitle: "متوجه شدم!", duration: 2, colorStyle: 0x0B93BF, colorTextButton: 0x000000, circleIconImage: nil , animationStyle: SCLAnimationStyle.TopToBottom)
        }
        else
        {
            self.email = usernametextField.text!
            Waiting = SCLAlertView(appearance: appearance)
            Waiting.showWait("لطفا صبور باشید...", subTitle: "", closeButtonTitle: "", duration: 1000, colorStyle: 0x0B93BF, colorTextButton: 0x000000, circleIconImage: nil, animationStyle: SCLAnimationStyle.NoAnimation)
            doReset()
        }
    }
    func doReset()
    {
        let URL:NSURL = NSURL(string: URLS.forgot_password)!
        let loginReq : NSMutableURLRequest = NSMutableURLRequest(URL: URL)
        
        let bodyData = String.localizedStringWithFormat("email=%@", user.email)
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
            if status == "0"
            {
                SCLAlertView(appearance: self.appearance).showError("نام کاربری وارد شده نادرست", subTitle: "", closeButtonTitle: "متوجه شدم!", duration: 2, colorStyle: 0x0B93BF, colorTextButton: 0x000000, circleIconImage: nil , animationStyle: SCLAnimationStyle.TopToBottom)
            }
            else if status == "1"
            {
                SCLAlertView(appearance: self.appearance).showSuccess("کاربر ثبت شد", subTitle: "رمز عبور جدید برای شما ارسال شد", closeButtonTitle: "متوجه شدم!", duration: 2, colorStyle: 0x00EE00, colorTextButton: 0x000000, circleIconImage: nil , animationStyle: SCLAnimationStyle.TopToBottom)
            }
        })
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
}
