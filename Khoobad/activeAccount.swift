//
//  activeAccount.swift
//  Khoobad
//
//  Created by Mehrshad Jalilmasir on 7/13/16.
//  Copyright © 2016 Mehrshad Jalilmasir. All rights reserved.
//

import UIKit

class activeAccount: UIViewController {

    @IBOutlet var activeCode: UITextField!
    @IBOutlet var send: UIButton!
    
    let appearance = SCLAlertView.SCLAppearance(
        showCloseButton: false
    )
    var Waiting = SCLAlertView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        send.layer.cornerRadius = 3.5
        send.layer.masksToBounds = true
        
        if let font = UIFont(name: "B Yekan", size: 15) {
            
            self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName :font , NSForegroundColorAttributeName: UIColor.whiteColor()]
        }
        navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.Plain, target:nil, action:nil)
    }
    
    override func viewWillDisappear(animated: Bool) {
        
        user.registerProcessing = false
    }
    
    @IBAction func active(sender: AnyObject) {
        
        if user.activationCode == Int(activeCode!.text!) {
            
            print("register")
        
            Waiting = SCLAlertView(appearance: appearance)
            Waiting.showWait("لطفا صبور باشید...", subTitle: "", closeButtonTitle: "", duration: 1000, colorStyle: 0x0B93BF, colorTextButton: 0x000000, circleIconImage: nil, animationStyle: SCLAnimationStyle.NoAnimation)
            user.registerProcessing = false
            self.activeMe()
        }
        else
        {
            let appearance = SCLAlertView.SCLAppearance(
                showCloseButton: false
            )
            SCLAlertView(appearance: appearance).showError("خطا", subTitle: "کد وارد شده صحیح نیست!", closeButtonTitle: "متوجه شدم!", duration: 1, colorStyle: 0xA429FF, colorTextButton: 0x000000, circleIconImage: nil , animationStyle: SCLAnimationStyle.NoAnimation)
        }
    }
    
    func activeMe()
    {
        let URL:NSURL = NSURL(string: "\(URLS.active_me)?\(String.localizedStringWithFormat("email=%@&token=%@", user.email , "\(user.activationCode)"))")!
        let loginReq : NSMutableURLRequest = NSMutableURLRequest(URL: URL)
        
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
            
            let _user = try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions())
            
            let status = _user["status"] as! String
            
            print(_user)
            if status == "-2"
            {
                SCLAlertView(appearance: self.appearance).showError("کد موجود نیست", subTitle: "", closeButtonTitle: "متوجه شدم!", duration: 2, colorStyle: 0x0B93BF, colorTextButton: 0x000000, circleIconImage: nil , animationStyle: SCLAnimationStyle.NoAnimation)
            }
            else if status == "1"
            {
                SCLAlertView(appearance:self.appearance).showSuccess("تایید انجام شد", subTitle: "" , closeButtonTitle: "بازگشت" , duration: 2 , colorStyle: 0x00EE00 , colorTextButton: 0x000000)
                self.parentViewController?.dismissViewControllerAnimated(true) {
                    print("dismissing view controller - done")
                }
            }
        })
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        self.view.endEditing(true)
    }
}
