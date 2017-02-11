//
//  isMyBizViewController.swift
//  Khoobad
//
//  Created by Mehrshad Jalilmasir on 7/13/16.
//  Copyright © 2016 Mehrshad Jalilmasir. All rights reserved.
//

import UIKit

class isMyBizViewController: UIViewController {

    @IBOutlet var send: UIButton!
    @IBOutlet var phone: UITextField!
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
    
    
    @IBAction func confirm(sender: AnyObject) {
        
        if phone.text == "" {
            
            SCLAlertView(appearance: appearance).showError("ورودی بدون مقدار", subTitle: "موبایل را وارد کنید", closeButtonTitle: "متوجه شدم!", duration: 1, colorStyle: 0x0B93BF, colorTextButton: 0x000000, circleIconImage: nil , animationStyle: SCLAnimationStyle.NoAnimation)
        }
        if NSString(string:phone.text!).length < 11 {
            
            SCLAlertView(appearance: appearance).showError("ورودی اشتباه", subTitle: "موبایل را صحیح وارد کنید", closeButtonTitle: "متوجه شدم!", duration: 1, colorStyle: 0x0B93BF, colorTextButton: 0x000000, circleIconImage: nil , animationStyle: SCLAnimationStyle.NoAnimation)
        }
        else
        {
            Waiting = SCLAlertView(appearance: appearance)
            Waiting.showWait("لطفا صبور باشید...", subTitle: "", closeButtonTitle: "", duration: 1000, colorStyle: 0x0B93BF, colorTextButton: 0x000000, circleIconImage: nil, animationStyle: SCLAnimationStyle.NoAnimation)
            isMyBiz()
        }
    }
    
    
    func isMyBiz()
    {
        if reachabilityStatus != KNOTREACHABLE || !_NOP
        {
            let URL:NSURL = NSURL(string: URLS.claim)!
            let loginReq : NSMutableURLRequest = NSMutableURLRequest(URL: URL)
            
            var bodyData = String.localizedStringWithFormat("user_id=%@&biz_id=%@&phone=%@" , "\(user.id)" , "\(selectedBiz.id)" , "\(phone.text!)")
            bodyData = bodyData.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
            loginReq.HTTPMethod = "POST"
            loginReq.HTTPBody = bodyData.dataUsingEncoding(NSUTF8StringEncoding)
            
            print(bodyData)
            
            NSURLConnection.sendAsynchronousRequest(loginReq, queue: NSOperationQueue.mainQueue(), completionHandler: { (response , data , error) in
                
                self.Waiting.hideView()
                
                if data == nil{
                    
                    //send later
                    return
                }
                guard let httpResponse = response as? NSHTTPURLResponse
                    else
                {
                    //send later
                    return
                }
                if httpResponse.statusCode < 200 || httpResponse.statusCode >= 300 //|| httpResponse.MIMEType == "application/json"
                {
                    //send later
                    return
                }
                let isme = try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions())
                print(isme)
                
                let status = isme["status"] as? String
                
                if status == "1"
                {
                    SCLAlertView(appearance: self.appearance).showSuccess("درخواست ثبت شد", subTitle: "با شما تماس میگیریم", closeButtonTitle: "متوجه شدم!", duration: 2, colorStyle: 0x00EE00, colorTextButton: 0x000000, circleIconImage: nil , animationStyle: SCLAnimationStyle.NoAnimation)
                    self.navigationController?.popToRootViewControllerAnimated(true)//back to previous
                }
                else if status == "-2"
                {
                    SCLAlertView(appearance: self.appearance).showError("درخواست شما قبلا ثبت شده است", subTitle: "", closeButtonTitle: "متوجه شدم!", duration: 1, colorStyle: 0x0B93BF, colorTextButton: 0x000000, circleIconImage: nil , animationStyle: SCLAnimationStyle.NoAnimation)
                }
            })
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        self.view.endEditing(true)
    }
}
