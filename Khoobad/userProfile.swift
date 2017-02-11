//
//  userProfile.swift
//  Khoobad
//
//  Created by Mehrshad Jalilmasir on 7/13/16.
//  Copyright © 2016 Mehrshad Jalilmasir. All rights reserved.
//

import UIKit

class userProfile: UIViewController , UIImagePickerControllerDelegate , UINavigationControllerDelegate {

    var alert = SCLAlertView()
    var dataName:String = String()
    var data:NSData = NSData()
    var tempIMG:UIImage = UIImage()
    var popover:UIPopoverController?=nil
    @IBOutlet var imageBtn: UIButton!
    @IBOutlet var name: UILabel!
    @IBOutlet var email: UILabel!
    
    var newPasswordtextField: UITextField!
    var oldPasswordtextField: UITextField!
    var loginAlert = SCLAlertView()
    let appearance = SCLAlertView.SCLAppearance(
        showCloseButton: false
    )
    var Waiting = SCLAlertView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //updateUI()
    }
    func updateUI()
    {
        imageBtn.layer.borderColor = UIColor.lightGrayColor().colorWithAlphaComponent(0.5).CGColor
        imageBtn.layer.borderWidth = 1.0
        imageBtn.layer.cornerRadius = imageBtn.layer.bounds.size.width/2
        imageBtn.layer.masksToBounds = true
        
        print(user.name)
        name.text = "\(user.name) \(user.family)"
        email.text = user.email
        
        if user.imageAddress == "" || user.imageAddress == "default" {
            
            
        }
        else
        {
            let _url =  NSURL(string : String.localizedStringWithFormat(URLS.UserImage , user.imageAddress))
            print(_url)
            if let url = _url {
                
                let imageDownloader = dataDownloaderServiceTask(url: url)
                imageDownloader.Download({ (data) in
                    
                    let image = UIImage(data : data)
                    dispatch_async(dispatch_get_main_queue(), {
                        
                        self.imageBtn.setImage(image, forState: UIControlState.Normal)
                    })
                })
            }
        }
        if let font = UIFont(name: "B Yekan", size: 15) {
            
            self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName :font , NSForegroundColorAttributeName: UIColor.whiteColor()]
        }
    }
    override func viewWillAppear(animated: Bool) {
        
        updateUI()
    }
    @IBAction func logout(sender: AnyObject) {
        
        parentViewController?.dismissViewControllerAnimated(true) {
            print("dismissing view controller - done")
        }
        user.isLogin = false
        
        db.updateUser(user.name , lastname: user.family, email: user.email, token: user.userToken , pass: user.pass, id: user.id , ImageAdd: "default", phone: user.phone, isLogin: false)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        
        //goes = 1
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        //goes = 1
        tempIMG = image
        let date = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Hour, .Minute], fromDate: date)
        let hour = components.hour
        let minutes = components.minute
        let sec = components.second
        let name:String = "\(hour)_\(minutes)_\(sec).png"
        data = UIImagePNGRepresentation(image)!
        dataName = name
        UploadRequest(image , image_name: dataName)
        //imageBtn.setImage(image, forState: UIControlState.Normal)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    @IBAction func changeImage(sender: AnyObject) {
        
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        
        let selectAlert:UIAlertController=UIAlertController(title: "انتخاب تصویر...", message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        let cameraAction = UIAlertAction(title: "دوربین", style: UIAlertActionStyle.Default)
        {
            UIAlertAction in
            picker.sourceType = UIImagePickerControllerSourceType.Camera
            //self.ImageViewPicker.backgroundColor = UIColor.cyanColor()
            if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera))
            {
                self .presentViewController(picker, animated: true, completion: nil)
            }
            else
            {
                
            }
            
        }
        
        let galleryAction = UIAlertAction(title: "گالری", style: UIAlertActionStyle.Default)
        {
            UIAlertAction in
            picker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            //self.ImageViewPicker.backgroundColor = UIColor.cyanColor()
            if UIDevice.currentDevice().userInterfaceIdiom == .Phone
            {
                self.presentViewController(picker, animated: true, completion: nil)
            }
            else
            {
                self.popover=UIPopoverController(contentViewController: picker)
            }
            
        }
        
        let cancellAction = UIAlertAction(title: "لغو", style: UIAlertActionStyle.Cancel)
        {
            UIAlertAction in
        }
        
        selectAlert.addAction(cameraAction)
        selectAlert.addAction(galleryAction)
        selectAlert.addAction(cancellAction)
        
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone
        {
            self.presentViewController(selectAlert, animated: true, completion: nil)
        }
        else
        {
            popover=UIPopoverController(contentViewController: selectAlert)
        }
    }
    
    @IBAction func changePass(sender: AnyObject) {
        
        ch_pass()
    }
    func ch_pass()
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
        oldPasswordtextField = UITextField(frame: CGRectMake(x,10,180,25))
        oldPasswordtextField.layer.borderColor = UIColor.lightGrayColor().CGColor
        oldPasswordtextField.layer.borderWidth = 1.5
        oldPasswordtextField.layer.cornerRadius = 5
        oldPasswordtextField.placeholder = "رمز عبور قبلی"
        oldPasswordtextField.autocorrectionType = UITextAutocorrectionType.No
        oldPasswordtextField.autocapitalizationType = UITextAutocapitalizationType.None
        oldPasswordtextField.font = UIFont(name: "HelveticaNeue-Bold", size: 14.0)
        oldPasswordtextField.textAlignment = NSTextAlignment.Center
        subview.addSubview(oldPasswordtextField)
        
        // Add textfield 2
        newPasswordtextField = UITextField(frame: CGRectMake(x,oldPasswordtextField.frame.maxY + 10,180,25))
        newPasswordtextField.secureTextEntry = true
        newPasswordtextField.layer.borderColor = UIColor.lightGrayColor().CGColor
        newPasswordtextField.layer.borderWidth = 1.5
        newPasswordtextField.layer.cornerRadius = 5
        newPasswordtextField.autocorrectionType = UITextAutocorrectionType.No
        newPasswordtextField.autocapitalizationType = UITextAutocapitalizationType.None
        newPasswordtextField.font = UIFont(name: "HelveticaNeue-Bold", size: 14.0)
        newPasswordtextField.placeholder = "رمز عبور جدید"
        newPasswordtextField.textAlignment = NSTextAlignment.Center
        subview.addSubview(newPasswordtextField)
        
        // Add the subview to the alert's UI property
        self.loginAlert.customSubview = subview
        self.loginAlert.addButton("تایید", target: self, selector: #selector(userProfile.change))
        // Add Button with Duration Status and custom Colors
        /*self.loginAlert.addButton("Duration Button", backgroundColor: UIColor.brownColor(), textColor: UIColor.yellowColor(), showDurationStatus: true) {
         print("Duration Button tapped")
         }*/
        
        self.loginAlert.showInfo("ورود", subTitle: "" , closeButtonTitle: "بازگشت" , duration: 222222 , colorStyle: 0x0B93BF , colorTextButton: 0x000000)

    }
    func change()
    {
        if user.pass == oldPasswordtextField.text! {
            
            Waiting = SCLAlertView(appearance: appearance)
            Waiting.showWait("لطفا صبور باشید...", subTitle: "", closeButtonTitle: "", duration: 1000, colorStyle: 0x0B93BF, colorTextButton: 0x000000, circleIconImage: nil, animationStyle: SCLAnimationStyle.NoAnimation)
            
            let URL:NSURL = NSURL(string: URLS.change_password)!
            let loginReq : NSMutableURLRequest = NSMutableURLRequest(URL: URL)
            
            let bodyData = String.localizedStringWithFormat("user_id=%@&oldPassword=%@&newPassword=%@" , "\(user.id)" , user.pass , newPasswordtextField.text!)
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
                
                let status = _user["status"] as! Int
                
                print(_user)
                if status == 1
                {
                    SCLAlertView(appearance: self.appearance).showSuccess("تغییر رمز عبور", subTitle: "با موفقیت انجام شد", closeButtonTitle: "متوجه شدم!", duration: 3, colorStyle: 0x00EE00, colorTextButton: 0x000000, circleIconImage: nil , animationStyle: SCLAnimationStyle.NoAnimation)
                    
                    user.pass = self.newPasswordtextField.text!
                    db.updateUser(user.name, lastname: user.family, email: user.email, token: user.userToken, pass: user.pass, id: user.id, ImageAdd: user.imageAddress, phone: user.phone, isLogin: user.isLogin)
                }
                else
                {
                    SCLAlertView(appearance: self.appearance).showError("خطا", subTitle: "خطا از سرور", closeButtonTitle: "متوجه شدم!", duration: 2, colorStyle: 0x0B93BF, colorTextButton: 0x000000, circleIconImage: nil , animationStyle: SCLAnimationStyle.NoAnimation)
                }
            })
        }
        else
        {
            ch_pass()
            SCLAlertView(appearance:appearance).showError("خطا", subTitle: "رمزعبور قبلی نادرست", closeButtonTitle: "متوجه شدم!", duration: 2, colorStyle: 0xA429FF, colorTextButton: 0x000000, circleIconImage: nil , animationStyle: SCLAnimationStyle.NoAnimation)
        }
    }
    
    
    //Mark : Upload Image
    func UploadRequest(image:UIImage , image_name:String)
    {
        let url = NSURL(string: URLS.upload_user_image)
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "POST"
  
        print(image.size)
        let _image = image.resizeWithPercentage(0.1)!
        let image_data = UIImagePNGRepresentation(_image)
        print(_image.size)
        if(image_data == nil)
        {
            return
        }
        let boundary = "78876565564454554547676"
        request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        let body = NSMutableData()
        
        body.appendData("--\(boundary)\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        
        // Append your parameters
        
        body.appendData("Content-Disposition: form-data; name=\"user_id\"\r\n\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        body.appendData("\(user.id)\r\n".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)!)
        body.appendData("--\(boundary)\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        
        body.appendData("Content-Disposition: form-data; name=\"token\"\r\n\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        body.appendData("\(user.userToken)\r\n".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)!)
        body.appendData("--\(boundary)\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        
        body.appendData("--\(boundary)\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        body.appendData("Content-Disposition: form-data; name=\"image\"; filename=\"\(image_name)\"\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        body.appendData("Content-Type: image/jpeg\r\n\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        body.appendData(image_data!)
        body.appendData("\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        
        body.appendData("--\(boundary)--\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        
        request.HTTPBody = body
        
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) {
            (
            let data, let response, let error) in
            
            guard let _:NSData = data, let _:NSURLResponse = response  where error == nil else {
                print("error")
                dispatch_async(dispatch_get_main_queue(), {
                    
                    self.alert = SCLAlertView(appearance: self.appearance)
                    //self.alert.addButton("تایید", target: self, selector: "ok")
                    self.alert.showError("تصویر بارگزاری نشد!", subTitle: "" , closeButtonTitle: "بازگشت" , duration: 1 , colorStyle: 0x0B93BF , colorTextButton: 0x000000)
                })
                return
            }
            
            let result = try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions())
            
            let status = (result["status"] as? String)
            
            //
            print(result)
            if status == "1"
            {
                //let dataString = NSString(data: data!, encoding: NSUTF8StringEncoding)
                dispatch_async(dispatch_get_main_queue(), {
                    
                    self.imageBtn.setImage(image, forState: UIControlState.Normal)
                    let imageAdd = result["url"] as! String
                    user.imageAddress = imageAdd
                    db.updateUser(user.name, lastname: user.family, email: user.email, token: user.userToken, pass: user.pass, id: user.id, ImageAdd: imageAdd, phone: user.phone, isLogin: true)
                })
            }
        }
        task.resume()
    }
    func generateBoundaryString() -> String
    {
        return "Boundary-\(NSUUID().UUIDString)"
    }
}
extension UIImage {
    func resizeWithPercentage(percentage: CGFloat) -> UIImage? {
        let imageView = UIImageView(frame: CGRect(origin: .zero, size: CGSize(width: size.width * percentage, height: size.height * percentage)))
        imageView.contentMode = .ScaleAspectFit
        imageView.image = self
        UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, false, scale)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        imageView.layer.renderInContext(context)
        guard let result = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        UIGraphicsEndImageContext()
        return result
    }
    
    func resizeWithWidth(width: CGFloat) -> UIImage? {
        let imageView = UIImageView(frame: CGRect(origin: .zero, size: CGSize(width: width, height: CGFloat(ceil(width/size.width * size.height)))))
        imageView.contentMode = .ScaleAspectFit
        imageView.image = self
        UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, false, scale)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        imageView.layer.renderInContext(context)
        guard let result = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        UIGraphicsEndImageContext()
        return result
    }
}