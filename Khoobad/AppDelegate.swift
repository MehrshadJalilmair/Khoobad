import UIKit
import CoreData

//global variables for all pages
var HomeBizes:HomeBizResults!
var HomeBizesCopy:HomeBizResults!
var sharedVars = SharedVariables()
var indicator: Indicator!
var user : User!
var db:DBManager = DBManager()
var favorites:[Int] = [Int]()
var dbLines:[String] = [String]()
var dbBizes:[[String]] = [[String]]()
var dbRatesLines:[String] = [String]()
var dbRates:[[String]] = [[String]]()

var KREACHABLEWITHWIFI = "ReachableWithWIFI"
var KNOTREACHABLE = "NotReachable"
var KREACHABLEWITHWWAN = "ReachableWithWWAN"

var reachability:Reachability?
var reachabilityStatus = KREACHABLEWITHWIFI

var _NOP = false

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var internetReach:Reachability?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        //UIApplication.sharedApplication().statusBarStyle = .LightContent
        
        self.INIT()
        
        start_filter()
        
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor()]
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(AppDelegate.reachabilityChanged(_:)), name: kReachabilityChangedNotification, object: nil)
        
        internetReach = Reachability.reachabilityForInternetConnection()
        internetReach?.startNotifier()
        
        if internetReach != nil {
            
            self.statusChangedWithReachability(internetReach!)
        }
        
        let tababarController = self.window!.rootViewController as! RAMAnimatedTabBarController
        //tababarController.selectedIndex = 1
        tababarController.setSelectIndex(from: 0, to: 1)
    
        return true
    }
    
    func INIT()
    {
        print("1")
        let db = DBManager()
        
        if db.getLocalDBPath() != "" {
            
            dbLines = db.getLocalDBPath().componentsSeparatedByString("\n")
        }
        
        if db.getUser().count > 0
        {
            let name = db.getUser()[0].valueForKey("name") as! String
            let lasetname = db.getUser()[0].valueForKey("lastname") as! String
            let phone = db.getUser()[0].valueForKey("phone") as! String
            let email = db.getUser()[0].valueForKey("email") as! String
            let pass = db.getUser()[0].valueForKey("pass") as! String
            let token = db.getUser()[0].valueForKey("token") as! String
            let id = db.getUser()[0].valueForKey("id") as! Int
            let imageAdd = db.getUser()[0].valueForKey("imageAdd") as! String
            let isLogin = db.getUser()[0].valueForKey("isLogin") as! Bool
            
            user = User(lat: 0.0, long: 0.0, deviceID: UIDevice.currentDevice().identifierForVendor!.UUIDString, name: name, pass: pass, email: email, imageAddress: imageAdd, id: id , havePOS: false, isLogin: isLogin, userToken: token , phone: phone , family: lasetname)
        }
        else
        {
            user = User(lat: 0.0, long: 0.0, deviceID: UIDevice.currentDevice().identifierForVendor!.UUIDString, name: "", pass: "", email: "", imageAddress: "", id: -1 , havePOS: false, isLogin: false, userToken: "VJtPjaJyYSuRycfpzlFqCHWD9aVc8aR4UkTdvDMuwhl4tBt3W9tzQpc0z8dIi4McoGqTjdnPuJUYkn1hwuQnU3ntbBcuFZH4F7YZlmPP6JOq7PIEkz1eCpIO0UiGTZLz7Kzs6oic86DfWmUgVVvxldmm7E21EOALy9dFywSHDwXzSRQNMll7zIuGmxI0ljMUtZA1wsJ9ZGJRxzFjV1ruJVb6sT6OcTIGSjIpLryK7hCERhYMjqg2ms8PlfEy8ne1GWrrnZcvhOa968VpzcsWFBL0QpzZMN1sKsU8s6DKVNT2WPrw2TsHudHlDglq4mTOONWhUA1QnUSkJjQMditIwb4aspAwLtlAhiRbSS1gMUAwdrirKMagXerpD1WovhZMAQXsJZIvTj27Llzv7JM5XduAfrZKJYwjPuLyuu4nO7vzs55AOSFM5anlBm5llCEa6qIAUNYJUujmzoXohDamNxHpUNKfppqvP86JW5tQzMd9baxsNHPBfx19kLoKaOgZXmJTrdK10Xab8HEWpuxE2zOmkc7v1nvZJfTbtDdtBnFK5jGvOeaQNYd8bkEcHacrp5DSIQmke14jlKP9ZZ0MYdV9xzmfJyH9Ek2nboHpqLJLwyUvyUiw8dGGN2WxBDHfXJC98kyy6hjCQe8p9rVhFCYsEU0gxHwvq9Eztd7zurclFlKPMG7ri5UXZUexBK32THBnUJXpa9LQuvFhcMIuRDsRyGoaqrck9OH4yEuIOfyjLdAY0jtRWVJuB8E2ARnJG4OeJiWyyvRkJrjJKMBHHkcjsRm2IJMpOADyTA6s6XNPo6z9SaQAv3UYUg0D0N2PoGnihtLnqydPFMZxWQ8sT2qNjrqjet8D9wVrZGOqf1gUNfrK5AcZCDNV4dfiHoVRURiTx7kM8AHWQ9HWJUVmxIiBWxUEWQvQIOKgV434FK1wTIsCCnYa6gM3OHHKycBg0lwWqz06j1CdK4QnsPxy6kBU1jFzvgQwCmt2Wt9gvLtfPjCi8aQeus9wLP5h5WOI" , phone: "" , family: "")
        }
        
        HomeBizes =  HomeBizResults(HomeBizes: [:] , HomeBizesIDS: [] , HomeBizesCount: 0, HomeBizesDistance: 0, HomeBizesStatus: "0")
        
        if db.getFavorites().count > 0 {
            
            for fav in db.getFavorites()
            {
                let id = fav.valueForKey("biz_id") as! Int
                favorites.append(id)
                print("fav \(id)")
            }
        }
        else
        {
            //do nothing
        }
        print("2")
    }
    
    func start_filter()
    {
        print("3")
        let url = NSURL(string: URLS.start_filter)
        let request = NSMutableURLRequest(URL: url!)
        
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) {
            (
            let data, let response, let error) in
            
            if data == nil{
                
                //self.waitingIndicator.stopAnimating()
                return
            }
            
            guard let httpResponse = response as? NSHTTPURLResponse
                else
            {
                //self.waitingIndicator.stopAnimating()
                return
            }
            
            if httpResponse.statusCode < 200 || httpResponse.statusCode >= 300 //|| httpResponse.MIMEType == "application/json"
            {
                //self.waitingIndicator.stopAnimating()
                return
            }
            
            let _start_filter = try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions()) as! [AnyObject]
            //print(ActualBiz)
            var Update_Force = 0
            
            for obj in _start_filter
            {
                print(obj)
                let tag1 = obj["name"] as! String
                let tag2 = Int(obj["value"] as! String)!
                
                switch tag1
                {
                case "maintainance":
                    
                    if tag2 > 0
                    {
                        dispatch_async(dispatch_get_main_queue(), {
                            
                            let appearance = SCLAlertView.SCLAppearance(
                                showCloseButton: false
                            )
                            let alert = SCLAlertView(appearance:appearance)
                            alert.showError("سرور در حال تعمیر", subTitle: "مدت زمان تقریبی : \(tag2) دقیقه" , closeButtonTitle: "بازگشت" , duration: 4 , colorStyle: 0x0B93BF , colorTextButton: 0x000000)
                            
                            alert.dismissBlock = ({
                                
                                self.maintainance_closeing()
                            })
                            _NOP = true
                            return
                        })
                    }
                    break
                    
                case "update_force":

                    Update_Force = tag2
                    break
                    
                case "version_ios":
                    dispatch_async(dispatch_get_main_queue(), {
                        
                        var update = false
                        
                        var version_app = ""
                        if let version = NSBundle.mainBundle().infoDictionary?["CFBundleShortVersionString"] as? String {
                            
                            version_app = version
                        }
                        if db.getVersion().count == 0
                        {
                            db.addVersion("1" , vAppStore: version_app)
                            update = false
                        }
                        
                        if Double(db.getVersion()[0].valueForKey("vAppStore") as! String) < Double(version_app)
                        {
                            db.updateVersion(String(Int(db.getVersion()[0].valueForKey("vServer") as! String)! + 1), vAppStore: version_app)
                        }//app updated
                        
                        if Update_Force > 0
                        {
                            if Int(db.getVersion()[0].valueForKey("vServer") as! String) < Int(tag2)
                            {
                                dispatch_async(dispatch_get_main_queue(), {
                                    
                                    let appearance = SCLAlertView.SCLAppearance(
                                        showCloseButton: false
                                    )
                                    let alert = SCLAlertView(appearance:appearance)
                                    alert.showError("در حال استفاده از نسخه قدیمی برنامه", subTitle: "به نسخه جدید ارتقا دهید" , closeButtonTitle: "بازگشت" , duration: 4 , colorStyle: 0x0B93BF , colorTextButton: 0x000000)
                                    
                                    alert.dismissBlock = ({
                                        
                                        self.update_force_closeing()
                                    })
                                    _NOP = true
                                    return
                                })
                            }
                            else if Int(db.getVersion()[0].valueForKey("vServer") as! String) < Int(tag2) &&
                                Double(db.getVersion()[0].valueForKey("vAppStore") as! String) < Double(version_app)
                            {
                                update = true
                            }
                        }
                        else if Int(db.getVersion()[0].valueForKey("vServer") as! String) < Int(tag2) &&
                            Double(db.getVersion()[0].valueForKey("vAppStore") as! String) < Double(version_app)
                        {
                            update = true
                        }
                        
                        _NOP = false
                        if update == true
                        {
                            dispatch_async(dispatch_get_main_queue(), {
                                
                                let appearance = SCLAlertView.SCLAppearance(
                                    showCloseButton: false
                                )
                                let alert = SCLAlertView(appearance:appearance)
                                alert.showError("در حال استفاده از نسخه قدیمی برنامه", subTitle: "به نسخه جدید ارتقا دهید" , closeButtonTitle: "بازگشت" , duration: 4 , colorStyle: 0x0B93BF , colorTextButton: 0x000000)
                                
                                alert.dismissBlock = ({
                                    
                                    self.update_closeing()
                                })
                            })
                        }
                    })
                    break
                    
                default:
                    
                    break
                }
            }
            print("4")
        }
        task.resume()
    }
    func maintainance_closeing()
    {
        
    }
    func update_force_closeing()
    {
        
    }
    func update_closeing()
    {
        
    }
    
    //Mark : send cashes
    func sendFailedComments()
    {
        print("5")
        if reachabilityStatus != KNOTREACHABLE && !_NOP{
            
            dispatch_async(dispatch_get_main_queue(), {
                
                let tmp = db.getFailedComment()
                if tmp.count > 0 {
                    
                    for comment in tmp {
                        
                        self.postFaildComment(comment.valueForKey("comment") as! String, rate: comment.valueForKey("rate")  as! Double, biz_id: comment.valueForKey("bizid") as! Int, openion: comment.valueForKey("openion") as! String, user_id: comment.valueForKey("user_id") as! Int, token: comment.valueForKey("token")  as! String, id:comment.valueForKey("id")  as! String)
                    }
                }
            })
        }
        print("6")
    }
    func sendFailedReports()
    {
        print("7")
        if reachabilityStatus != KNOTREACHABLE && !_NOP{
            
            dispatch_async(dispatch_get_main_queue(), {
                
                let tmp = db.getFailedReport()
                if tmp.count > 0 {
                    
                    for report in tmp {
                        
                        self.postFialedReport(report.valueForKey("reason") as! String, comment_id: report.valueForKey("comment_id") as! Int, id: report.valueForKey("id") as! String)
                    }
                }
            })
        }
        print("8")
    }
    func postFaildComment(comment: String , rate : Double , biz_id : Int , openion:String , user_id:Int , token:String , id:String)
    {
        let configuration: NSURLSessionConfiguration = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session : NSURLSession = NSURLSession(configuration: configuration)
        let request = NSMutableURLRequest(URL: NSURL(string: URLS.comment)!)
        
        var bodyData = String.localizedStringWithFormat("rate=%@&comment=%@&bizid=%@&user_id=%@&token=%@&opinion=%@", "\(Int(rate))" , comment , "\(biz_id)" , "\(user_id)" , token , openion)
        bodyData = bodyData.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
        
        request.HTTPMethod = "POST"
        request.HTTPBody = bodyData.dataUsingEncoding(NSUTF8StringEncoding)
        
        print(bodyData)
        
        let dataTask = session.dataTaskWithRequest(request){(data , response , error) in
            
            if error == nil
            {
                if let httpResponse = response as? NSHTTPURLResponse{
                    
                    switch(httpResponse.statusCode)
                    {
                        
                    case 200:
                        
                        if let data = data{
                            
                            
                            let _comment = try! NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions())
                            let status = (_comment["status"] as? Int)
                            
                            print(_comment)
                            if status == 1
                            {
                                //ok
                                //NSNotificationCenter.defaultCenter().postNotificationName("reloadComments", object: nil)
                                let _id = (_comment["id"] as? Int)
                                print(_id)
                                //print(db.getFailedComment().count)
                                db.removeFailedComment(id)
                                //print(db.getFailedComment().count)
                            }
                        }
                        
                    default:
                        
                        break
                    }
                }
            }
        }
        dataTask.resume()
    }
    func postFialedReport(reason: String , comment_id: Int , id: String)
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
                                //print(db.getFailedReport().count)
                                db.removeFailedReport(id)
                                //print(db.getFailedReport().count)
                            }
                        }
                        
                    default:
                        break
                    }
                }
            }
        }
        dataTask.resume()
    }

    //notify net status
    func reachabilityChanged(notification : NSNotification)
    {
        reachability = notification.object as? Reachability
        statusChangedWithReachability(reachability!)
        
        
        
        if categories.count == 0 {
            
            sharedVars.getCategories()
        }
        
        if reachabilityStatus == KNOTREACHABLE
        {
            dispatch_async(dispatch_get_main_queue(), {
                
                let appearance = SCLAlertView.SCLAppearance(
                    showCloseButton: false,
                    kTitleFont: UIFont(name: "HelveticaNeue", size: 14)!,
                    kTextFont: UIFont(name: "HelveticaNeue", size: 12)!,
                    kButtonFont: UIFont(name: "HelveticaNeue-Bold", size: 12)!
                )
                var Waiting = SCLAlertView()
                Waiting = SCLAlertView(appearance: appearance)
                Waiting.showWait("تغییر به وضعیت بدون اینترنت", subTitle: "لطفا صبور باشید...", closeButtonTitle: "", duration: 3, colorStyle: 0x0B93BF, colorTextButton: 0x000000, circleIconImage: nil, animationStyle: SCLAnimationStyle.NoAnimation)
            })
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), {
              
                let appearance = SCLAlertView.SCLAppearance(
                    showCloseButton: false,
                    kTitleFont: UIFont(name: "HelveticaNeue", size: 14)!,
                    kTextFont: UIFont(name: "HelveticaNeue", size: 12)!,
                    kButtonFont: UIFont(name: "HelveticaNeue-Bold", size: 12)!
                )
                var Waiting = SCLAlertView()
                Waiting = SCLAlertView(appearance: appearance)
                Waiting.showWait("تغییر به وضعیت اتصال اینترنت", subTitle: "لطفا صبور باشید...", closeButtonTitle: "", duration: 3, colorStyle: 0x0B93BF, colorTextButton: 0x000000, circleIconImage: nil, animationStyle: SCLAnimationStyle.NoAnimation)
            })
        }
    }
    
    //show net status
    func statusChangedWithReachability(currentReachabilityState : Reachability)
    {
    
        let networkStatus : NetworkStatus = currentReachabilityState.currentReachabilityStatus()
        
        if networkStatus.rawValue == NotReachable.rawValue{
            
            reachabilityStatus = KNOTREACHABLE
            
            
            
        } else if networkStatus.rawValue == ReachableViaWiFi.rawValue{
            
            reachabilityStatus = KREACHABLEWITHWIFI
            //send cashes
            sendFailedComments()
            sendFailedReports()
            
        }else if networkStatus.rawValue == ReachableViaWWAN.rawValue{
            
            reachabilityStatus = KREACHABLEWITHWWAN
            //send cashes
            sendFailedComments()
            sendFailedReports()
        }
        
        NSNotificationCenter.defaultCenter().postNotificationName("ReachStatusChanged" , object:nil)
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name: kReachabilityChangedNotification, object: nil)
    }

    // MARK: - Core Data stack

    lazy var applicationDocumentsDirectory: NSURL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "mehrshad.jm.Khoobad" in the application's documents Application Support directory.
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1]
    }()

    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = NSBundle.mainBundle().URLForResource("Khoobad", withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
    }()

    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("SingleViewCoreData.sqlite")
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil)
        } catch {
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason

            dict[NSUnderlyingErrorKey] = error as! NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        
        return coordinator
    }()

    lazy var managedObjectContext: NSManagedObjectContext = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
        }
    }

}

