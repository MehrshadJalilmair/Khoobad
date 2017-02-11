//
//  fix_report.swift
//  Khoobad
//
//  Created by Mehrshad Jalilmasir on 7/30/16.
//  Copyright © 2016 Mehrshad Jalilmasir. All rights reserved.
//

import UIKit

class fix_report: UIViewController , UITextViewDelegate , UITextFieldDelegate{

    var Biz:HomeBiz!
    
    var alert = SCLAlertView()
    let appearance = SCLAlertView.SCLAppearance(
        showCloseButton: false
    )
    var Waiting = SCLAlertView()
    
    @IBOutlet var send: UIButton!
    @IBOutlet var cancel: UIButton!
    
    @IBOutlet var reportDesc: UITextView!
    
    //Mark : Loading
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.Biz = bizForfix_reportID
        
        send.layer.cornerRadius = 3.5
        cancel.layer.cornerRadius = 3.5
        send.layer.masksToBounds = true
        cancel.layer.masksToBounds = true
        
        reportDesc.layer.cornerRadius = 5.0
        reportDesc.layer.masksToBounds = false
        reportDesc.layer.shadowColor = UIColor.blackColor().colorWithAlphaComponent(0.5).CGColor
        reportDesc.layer.shadowOffset = CGSize(width: 0, height: 0)
        reportDesc.layer.shadowOpacity = 0.8
        reportDesc.textColor = UIColor.lightGrayColor()
        
        //desc.becomeFirstResponder()
        reportDesc.selectedTextRange = reportDesc.textRangeFromPosition(reportDesc.beginningOfDocument, toPosition: reportDesc.beginningOfDocument)
        
        reportDesc.text = "موارد برای ویرایش..."
        
        reportDesc.textAlignment = .Center
        reportDesc.delegate = self
        
        //print("comment_id \(comment_id)")
        //reportDesc.contentVerticalAlignment = UIControlContentVerticalAlignment.Top
        if let font = UIFont(name: "B Yekan", size: 15) {
            
            self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName :font , NSForegroundColorAttributeName: UIColor.whiteColor()]
        }
    }
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool{
        
        // Combine the textView text and the replacement text to
        // create the updated text string
        let currentText:NSString = reportDesc.text!
        let updatedText = currentText.stringByReplacingCharactersInRange(range, withString:text)
        
        // If updated text view will be empty, add the placeholder
        // and set the cursor to the beginning of the text view
        if updatedText.isEmpty {
            
            reportDesc.text = "موارد برای ویرایش..."
            reportDesc.textColor = UIColor.lightGrayColor()
            
            reportDesc.selectedTextRange = reportDesc.textRangeFromPosition(reportDesc.beginningOfDocument, toPosition: reportDesc.beginningOfDocument)
            reportDesc.font = UIFont(name: "B Yekan", size: 10.0)
            return false
        }
            
            // Else if the text view's placeholder is showing and the
            // length of the replacement string is greater than 0, clear
            // the text view and set its color to black to prepare for
            // the user's entry
        else if reportDesc.textColor == UIColor.lightGrayColor() && !text.isEmpty {
            reportDesc.text = nil
            reportDesc.textColor = UIColor.blackColor()
            reportDesc.font = UIFont(name: "B Yekan", size: 14.0)
        }
        
        return true
    }
    
    //Mark : Btn Funcs
    @IBAction func cancell(sender: AnyObject) {
        
        parentViewController?.dismissViewControllerAnimated(true) {
            print("dismissing view controller - done")
        }
    }
    @IBAction func sendReport(sender: AnyObject) {
        
        if reportDesc.textColor == UIColor.lightGrayColor(){
            
            //SCLAlertView(appearance: appearance).showError("ورودی بدون مقدار", subTitle: "موارد مدنظر را وارد کنید", closeButtonTitle: "متوجه شدم!", duration: 1, colorStyle: 0x0B93BF, colorTextButton: 0x000000, circleIconImage: nil , animationStyle: SCLAnimationStyle.TopToBottom)
        }
        else
        {
            self.Report(self.reportDesc.text!)
            
        }
    }
    func ok()
    {
        navigationController?.popToRootViewControllerAnimated(true)
    }
    
    //Mark : Post Report
    func Report(reason:String)
    {
        Waiting = SCLAlertView(appearance: appearance)
        
        if reachabilityStatus != KNOTREACHABLE && !_NOP
        {
            Waiting.showWait("لطفا صبور باشید...", subTitle: "", closeButtonTitle: "", duration: 1000, colorStyle: 0x0B93BF, colorTextButton: 0x000000, circleIconImage: nil, animationStyle: SCLAnimationStyle.NoAnimation)
            
            let configuration: NSURLSessionConfiguration = NSURLSessionConfiguration.defaultSessionConfiguration()
            let session : NSURLSession = NSURLSession(configuration: configuration)
            let request = NSMutableURLRequest(URL: NSURL(string: URLS.fix_report)!)
            
            let bodyData = String.localizedStringWithFormat("user_id=%@&biz_id=%@&report=%@&token=%@", "\(user.id)" , "\(Biz.id)" , reason , user.userToken)
            print(bodyData)
            request.HTTPMethod = "POST"
            request.HTTPBody = bodyData.dataUsingEncoding(NSUTF8StringEncoding)
            
            let dataTask = session.dataTaskWithRequest(request){(data , response , error) in
                
                dispatch_async(dispatch_get_main_queue(), {
                    
                    self.Waiting.hideView()
                })
                if error == nil
                {
                    if let httpResponse = response as? NSHTTPURLResponse{
                        
                        switch(httpResponse.statusCode)
                        {
                            
                        case 200:
                            
                            if let data = data{
                                
                                let result = try! NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions())
                                
                                let status = (result["status"] as? String)
                                
                                //
                                print(result)
                                if status == "1"
                                {
                                    dispatch_async(dispatch_get_main_queue(), {
                                        
                                     self.alert = SCLAlertView(appearance: self.appearance)
                                        self.alert.dismissViewControllerAnimated(true
                                            , completion: {
                                                
                                                self.ok()
                                        })
                                        self.alert.dismissBlock = ({
                                            
                                            self.ok()
                                        })
                                        //self.alert.addButton("تایید", target: self, selector: "ok")
                                        self.alert.showSuccess("گزارش ارسال شد!", subTitle: "" , closeButtonTitle: "بازگشت" , duration: 1 , colorStyle: 0x00EE00 , colorTextButton: 0x000000)
                                    })

                                }
                                else
                                {
                                    //save to db and try again
                                    dispatch_async(dispatch_get_main_queue(), {
                                    
                                     self.alert = SCLAlertView(appearance: self.appearance)
                                        self.alert.dismissViewControllerAnimated(true
                                            , completion: {
                                                
                                                self.ok()
                                        })
                                        self.alert.dismissBlock = ({
                                            
                                            self.ok()
                                        })
                                        //self.alert.addButton("تایید", target: self, selector: "ok")
                                        self.alert.showError("گزارش ارسال نشد!", subTitle: "" , closeButtonTitle: "بازگشت" , duration: 1 , colorStyle: 0x0B93BF , colorTextButton: 0x000000)
                                    })
                                }
                            }
                            
                        default:
                            
                            print(httpResponse.statusCode)
                            //save to db and try again
                        }
                    }
                }
            }
            dataTask.resume()
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        self.view.endEditing(true)
    }
}
