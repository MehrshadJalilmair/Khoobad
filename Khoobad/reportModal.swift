//
//  reportModal.swift
//  Khoobad
//
//  Created by Mehrshad Jalilmasir on 7/11/16.
//  Copyright © 2016 Mehrshad Jalilmasir. All rights reserved.
//

import UIKit

class reportModal: UIViewController , UITextViewDelegate{

    //Mark : Just Vars
    var comment_id:Int!
    var alert = SCLAlertView()
    let appearance = SCLAlertView.SCLAppearance(
        showCloseButton: false
    )
    
    @IBOutlet var send: UIButton!
    @IBOutlet var cancel: UIButton!

    @IBOutlet var reportDesc: UITextView!
    
    //Mark : Loading
    override func viewDidLoad() {
        super.viewDidLoad()

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
        
        reportDesc.text = "توضیحات"
        
        reportDesc.textAlignment = .Center
        reportDesc.delegate = self
        
        print("comment_id \(comment_id)")
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
            
            reportDesc.text = "توضیحات"
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
            
            print("without desc")
            Report("")
        }
        else
        {
            Report(reportDesc.text!)
        }
    }
    func ok()
    {
        parentViewController?.dismissViewControllerAnimated(true) {
            print("dismissing view controller - done")
        }
    }
    
    //Mark : Post Report
    func Report(reason:String)
    {
        if reachabilityStatus != KNOTREACHABLE && !_NOP
        {
            let configuration: NSURLSessionConfiguration = NSURLSessionConfiguration.defaultSessionConfiguration()
            let session : NSURLSession = NSURLSession(configuration: configuration)
            let request = NSMutableURLRequest(URL: NSURL(string: URLS.report)!)
            
            let bodyData = String.localizedStringWithFormat("comment_id=%@&reason=%@", "\(comment_id)" , reason)
            
            print(bodyData)
            request.HTTPMethod = "POST"
            request.HTTPBody = bodyData.dataUsingEncoding(NSUTF8StringEncoding)
            
            let dataTask = session.dataTaskWithRequest(request){(data , response , error) in
                
                if error == nil
                {
                    if let httpResponse = response as? NSHTTPURLResponse{
                        
                        switch(httpResponse.statusCode)
                        {
                            
                        case 200:
                            
                            if let data = data{
                                
                                
                                let result = try! NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions())
                                
                                let status = (result["status"] as? Int)
                                
                                print(result)
                                if status == 1
                                {
                                    
                                }
                                else
                                {
                                    //save to db and try again
                                    db.addFailedReport(reason, comment_id: self.comment_id)
                                }
                            }
                            
                        default:
                            print(httpResponse.statusCode)
                            //save to db and try again
                            db.addFailedReport(reason, comment_id: self.comment_id)
                        }
                    }
                }
            }
            dataTask.resume()
        }
        else if reachabilityStatus == KNOTREACHABLE || _NOP

        {
            //save to db and send later
            db.addFailedReport(reason, comment_id: self.comment_id)
        }
        
        alert = SCLAlertView(appearance: appearance)
        alert.dismissViewControllerAnimated(true
            , completion: {
                
                self.ok()
        })
        alert.dismissBlock = ({
            
            self.ok()
        })
        //self.alert.addButton("تایید", target: self, selector: "ok")
        self.alert.showSuccess("گزارش ارسال شد!", subTitle: "" , closeButtonTitle: "بازگشت" , duration: 1 , colorStyle: 0x00EE00 , colorTextButton: 0x000000)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        self.view.endEditing(true)
    }
}
