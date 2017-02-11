//
//  DBManager.swift
//  Khoobad
//
//  Created by Mehrshad Jalilmasir on 7/16/16.
//  Copyright © 2016 Mehrshad Jalilmasir. All rights reserved.
//

import UIKit
import CoreData

class DBManager: NSObject , SSZipArchiveDelegate {

    var delegate:AppDelegate!
    var context:NSManagedObjectContext!
    
    override init() {
        
        delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        context = delegate.managedObjectContext
    }
    
    internal func addUser(name:String , lastname:String , email:String , token:String , pass:String , id:Int , ImageAdd:String , phone:String , isLogin:Bool)
    {
        let entity = NSEntityDescription.entityForName("User", inManagedObjectContext: context)
        let User = NSManagedObject(entity: entity!, insertIntoManagedObjectContext:context)
        User.setValue(name, forKey: "name")
        User.setValue(lastname, forKey: "lastname")
        User.setValue(email, forKey: "email")
        User.setValue(token, forKey: "token")
        User.setValue(pass, forKey: "pass")
        User.setValue(id, forKey: "id")
        User.setValue(ImageAdd, forKey: "imageAdd")
        User.setValue(phone, forKey: "phone")
        User.setValue(isLogin, forKey: "isLogin")
        
        do
        {
            try context.save()
        }
        catch _
        {
            
        }
    }
    
    internal func getUser()->[NSManagedObject]
    {        
        let req = NSFetchRequest(entityName: "User")
        
        do
        {
            let user :[NSManagedObject]? = try context.executeFetchRequest(req) as? [NSManagedObject]
            
            if let users = user
            {
                if users.count > 0 {
                    
                    return users
                }
                else
                {
                    return []
                }
            }
        }
        catch _
        {
            
        }
        return []
    }
    
    internal func updateUser(name:String , lastname:String , email:String , token:String , pass:String , id:Int , ImageAdd:String , phone:String , isLogin:Bool)
    {
        print(name)

        let req = NSFetchRequest(entityName: "User")
        
        do
        {
            let user :[NSManagedObject]? = try context.executeFetchRequest(req) as? [NSManagedObject]
            
            if let users = user
            {
                if users.count > 0 {
                    
                    users[0].setValue(name, forKey: "name")
                    users[0].setValue(lastname, forKey: "lastname")
                    users[0].setValue(email, forKey: "email")
                    users[0].setValue(token, forKey: "token")
                    users[0].setValue(pass, forKey: "pass")
                    users[0].setValue(id, forKey: "id")
                    users[0].setValue(ImageAdd, forKey: "imageAdd")
                    users[0].setValue(phone, forKey: "phone")
                    users[0].setValue(isLogin, forKey: "isLogin")
                    
                    do
                    {
                        try context.save()
                    }
                    catch
                    {
                        let saveError = error as NSError
                        print(saveError)
                    }
                }
            }
        }
        catch
        {
            let saveError = error as NSError
            print(saveError)
        }
    }
    
    internal func getFavorites()->[NSManagedObject]
    {
        let req = NSFetchRequest(entityName: "Favorites")
        
        do
        {
            let fav :[NSManagedObject]? = try context.executeFetchRequest(req) as? [NSManagedObject]
            
            if let favs = fav
            {
                if favs.count > 0 {
                    
                    return favs
                }
                else
                {
                    return []
                }
            }
        }
        catch _
        {
            
        }
        return []
    }
    internal func addFavorite(id:Int)
    {
        let entity = NSEntityDescription.entityForName("Favorites", inManagedObjectContext: context)
        let fav = NSManagedObject(entity: entity!, insertIntoManagedObjectContext:context)
        fav.setValue(id, forKey: "biz_id")
        
        do
        {
            try context.save()
        }
        catch _
        {
            
        }
    }
    internal func removeFavorite(id:Int)
    {
        let req = NSFetchRequest(entityName: "Favorites")
        
        do
        {
            var fav :[NSManagedObject]? = try context.executeFetchRequest(req) as? [NSManagedObject]
            
            if var favs = fav
            {
                if favs.count > 0 {
                    
                    var index:Int = 0
                    
                    for  object in favs {
                        
                        if (object.valueForKey("biz_id") as! Int == id) {
                            
                            fav?.removeAtIndex(index)
                            favs.removeAtIndex(index)
                            context.deleteObject(object)
                            break
                        }
                        index = index + 1
                    }
                    do
                    {
                        try context.save()
                    }
                    catch
                    {
                        let saveError = error as NSError
                        print(saveError)
                    }
                }
            }
        }
        catch
        {
            let saveError = error as NSError
            print(saveError)
        }
    }
    
    
    internal func addLocalDBStatus(status:Bool , path:String , count:Int , timestamp:String , address:String , Date:NSDate , OstanID:String)
    {
        let entity = NSEntityDescription.entityForName("LocalDB", inManagedObjectContext: context)
        let User = NSManagedObject(entity: entity!, insertIntoManagedObjectContext:context)
        User.setValue(status, forKey: "downloaded")
        User.setValue(path, forKey: "path")
        User.setValue(count, forKey: "count")
        User.setValue(timestamp, forKey: "timestamp")
        User.setValue(address, forKey: "address")
        User.setValue(OstanID, forKey: "ostan_id")
        User.setValue(Date, forKey: "lastUpdate")
        do
        {
            try context.save()
        }
        catch _
        {
            
        }
    }
    internal func updateLocalDB(status:Bool , path:String , count:Int , timestamp:String, address:String , Date:NSDate , OstanID:String , type:Bool)//tyep == append or change
    {
        let req = NSFetchRequest(entityName: "LocalDB")
        
        do
        {
            let user :[NSManagedObject]? = try context.executeFetchRequest(req) as? [NSManagedObject]
            
            if let users = user
            {
                if users.count > 0 {
                    
                    if type {
                        
                        //print(users[0].valueForKey("path") as! String + "\n" + path)
                        //print(users[0].valueForKey("count") as! Int + count)
                        
                        users[0].setValue(status, forKey: "downloaded")
                        users[0].setValue("\(users[0].valueForKey("path") as! String)\n\(path)", forKey: "path")
                        users[0].setValue(users[0].valueForKey("count") as! Int + count, forKey: "count")
                        users[0].setValue(timestamp, forKey: "timestamp")
                        users[0].setValue(address, forKey: "address")
                        users[0].setValue(Date, forKey: "lastUpdate")
                        users[0].setValue(OstanID, forKey: "ostan_id")
                    }
                    else
                    {
                        let _dbRows_New = path
                        let lines_New = _dbRows_New.componentsSeparatedByString("\n")
                        var rows_New:[[String]] = [[String]]()
                        for line in lines_New {
                            
                            rows_New.append(line.componentsSeparatedByString("\t"))
                        }
                        
                        let _dbRows_Old = users[0].valueForKey("path") as! String
                        let lines_Old = _dbRows_Old.componentsSeparatedByString("\n")
                        var rows_Old:[[String]] = [[String]]()
                        for line in lines_Old {
                            
                            rows_Old.append(line.componentsSeparatedByString("\t"))
                        }
                        
                        var indexes:[Int] = [Int]()
                        var i = 0
                        var j = 0
                        
                        for o1 in rows_Old
                        {
                            for o2 in rows_New
                            {
                                if o1[0] == o2[0] {
                                    
                                    indexes.append(j)
                                }
                                j = j + 1
                            }
                            
                            i = i + 1
                        }
                        
                        for index in indexes {
                            
                            if index < rows_Old.count {
                                
                                rows_Old.removeAtIndex(index)
                            }
                        }
                        
                        for o in rows_New {
                            
                            rows_Old.append(o)
                        }
                        
                        var finalRows:[String] = [String]()
                        for o in rows_Old {
                            
                            finalRows.append(o.joinWithSeparator("\t"))
                        }
                        
                        let finalPath = finalRows.joinWithSeparator("\n")
                        
                        users[0].setValue(status, forKey: "downloaded")
                        users[0].setValue(finalPath, forKey: "path")
                        users[0].setValue(finalRows.count, forKey: "count")
                        users[0].setValue(timestamp, forKey: "timestamp")
                        users[0].setValue(address, forKey: "address")
                        users[0].setValue(Date, forKey: "lastUpdate")
                        users[0].setValue(OstanID, forKey: "ostan_id")
                    }
                    
                    do
                    {
                        try context.save()
                    }
                    catch
                    {
                        let saveError = error as NSError
                        print(saveError)
                    }
                }
            }
        }
        catch
        {
            let saveError = error as NSError
            print(saveError)
        }
    }
    
    internal func getLocalDBStatus()->Bool
    {
        let req = NSFetchRequest(entityName: "LocalDB")
        
        do
        {
            let user :[NSManagedObject]? = try context.executeFetchRequest(req) as? [NSManagedObject]
            
            if let users = user
            {
                if users.count > 0 {
                    
                    return (users[0].valueForKey("downloaded") as? Bool)!
                }
                else
                {
                    return false
                }
            }
        }
        catch _
        {
            
        }
        return false
    }
    internal func getLocalDBPath()->String
    {
        let req = NSFetchRequest(entityName: "LocalDB")
        
        do
        {
            let user :[NSManagedObject]? = try context.executeFetchRequest(req) as? [NSManagedObject]
            
            if let users = user
            {
                if users.count > 0 {
                    
                    return (users[0].valueForKey("path") as? String)!
                }
                else
                {
                    return ""
                }
            }
        }
        catch _
        {
            
        }
        return ""
    }
    internal func getLocalDBOstanID()->String
    {
        let req = NSFetchRequest(entityName: "LocalDB")
        
        do
        {
            let user :[NSManagedObject]? = try context.executeFetchRequest(req) as? [NSManagedObject]
            
            if let users = user
            {
                if users.count > 0 {
                    
                    return (users[0].valueForKey("ostan_id") as? String)!
                }
                else
                {
                    return ""
                }
            }
        }
        catch _
        {
            
        }
        return ""
    }
    internal func getLocalDBCount()->Int
    {
        let req = NSFetchRequest(entityName: "LocalDB")
        
        do
        {
            let user :[NSManagedObject]? = try context.executeFetchRequest(req) as? [NSManagedObject]
            
            if let users = user
            {
                if users.count > 0 {
                    
                    return (users[0].valueForKey("count") as? Int)!
                }
                else
                {
                    return 0
                }
            }
        }
        catch _
        {
            
        }
        return 0
    }
    internal func getLocalDBTimestamp()->String
    {
        let req = NSFetchRequest(entityName: "LocalDB")
        
        do
        {
            let user :[NSManagedObject]? = try context.executeFetchRequest(req) as? [NSManagedObject]
            
            if let users = user
            {
                if users.count > 0 {
                    
                    return (users[0].valueForKey("timestamp") as? String)!
                }
                else
                {
                    return ""
                }
            }
        }
        catch _
        {
            
        }
        return ""
    }
    internal func getLocalDBAddress()->String
    {
        let req = NSFetchRequest(entityName: "LocalDB")
        
        do
        {
            let user :[NSManagedObject]? = try context.executeFetchRequest(req) as? [NSManagedObject]
            
            if let users = user
            {
                if users.count > 0 {
                    
                    return (users[0].valueForKey("address") as? String)!
                }
                else
                {
                    return ""
                }
            }
        }
        catch _
        {
            
        }
        return ""
    }
    internal func getLocalDBLastUpdate()->NSDate
    {
        let req = NSFetchRequest(entityName: "LocalDB")
        
        do
        {
            let user :[NSManagedObject]? = try context.executeFetchRequest(req) as? [NSManagedObject]
            
            if let users = user
            {
                if users.count > 0 {
                    
                    return (users[0].valueForKey("lastUpdate") as? NSDate)!
                }
                else
                {
                    print(NSDate())
                    return NSDate()
                }
            }
        }
        catch _
        {
            
        }
        print(NSDate())
        return NSDate()
    }
    internal func updateLocalDBStatus(status:Bool)
    {
        
        let req = NSFetchRequest(entityName: "LocalDB")
        
        do
        {
            let user :[NSManagedObject]? = try context.executeFetchRequest(req) as? [NSManagedObject]
            
            if let users = user
            {
                if users.count > 0 {
                    
                    users[0].setValue(status, forKey: "downloaded")

                    do
                    {
                        try context.save()
                    }
                    catch
                    {
                        let saveError = error as NSError
                        print(saveError)
                    }
                }
            }
        }
        catch
        {
            let saveError = error as NSError
            print(saveError)
        }
    }
    
    internal func googleApi(type:Int)//type = 0 local biz , 1 = local rate
    {
        //download user image
        let _url =  NSURL(string : String.localizedStringWithFormat("http://maps.googleapis.com/maps/api/geocode/json?language=fa&address=%.1f,%.1f" , user.lat , user.long))
        if let url = _url {
            
            let ostanIDDownloader = dataDownloaderServiceTask(url: url)
            ostanIDDownloader.Download({ (data) in
                
                let _data = try! NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions())
                let status = _data["status"] as! String
                
                if status == "OK"
                {
                    let tmp = _data["results"] as! [AnyObject]
                    for obj in tmp
                    {
                        
                        let tmp1 = obj["types"] as! [String]
                        for obj1 in tmp1
                        {
                            if obj1 == "administrative_area_level_1"
                            {
                                let tmp2 = obj["place_id"] as! String
                                print(tmp2)
                                switch type
                                {
                                case 0 :
                                    
                                    dispatch_async(dispatch_get_main_queue(), {
                                        
                                        db.GetLocalDB_saveLocalDB(tmp2)
                                    })
                                    
                                    break
                                case 1:
                                    dispatch_async(dispatch_get_main_queue(), {
                                        
                                        db.GetLocalRateDB_saveLocalDB(tmp2)
                                        })
                                    
                                    break
                                    
                                default:
                                    break
                                }
                                return
                            }
                        }
                    }
                }
            })
        }
    }
    internal func GetLocalRateDB_saveLocalDB(ostan_id:String)
    {
        var download = false
        
        if db.getOstanRatesRecord(ostan_id).count > 0 {//we download db rate before
            
            let diffDateComponents = NSCalendar.currentCalendar().components([NSCalendarUnit.Year, NSCalendarUnit.Month, NSCalendarUnit.Day, NSCalendarUnit.Hour, NSCalendarUnit.Minute, NSCalendarUnit.Second] , fromDate: db.getOstanRatesRecord(ostan_id)[0].valueForKey("date") as! NSDate, toDate: NSDate(), options: NSCalendarOptions.init(rawValue: 0))
        
            print("\(NSDate())   \(db.getOstanRatesRecord(ostan_id)[0].valueForKey("date") as! NSDate)")
            print("\(diffDateComponents.day)   \(diffDateComponents.minute)")
            if diffDateComponents.day > 2 {
                
                download = true//update
            }
            else
            {
                download = false
            }
        }
        else
        {
            download = true//download for once
        }
        
        if download {
            
            let URL:NSString =  String.localizedStringWithFormat(URLS.get_local_rating, ostan_id)
            print(URL)
            let urlStr : NSString = URL.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
            
            let _url0 =  NSURL(string : urlStr as String)
            
            if let url0 = _url0 {
                
                let imageDownloader = dataDownloaderServiceTask(url: url0)
                imageDownloader.Download({ (data) in
                    
                    let result = NSString(data: data, encoding: NSUTF8StringEncoding)!
                    print(result)
                    if (result.containsString("status") && result.containsString("-1")) || result == ""
                    {
                        return
                    }
                    self.downloadRateDB(result , OstanID: ostan_id)
                })
            }
        }
    }
    internal func downloadRateDB(url:NSString , OstanID:String)
    {
        print("download database rate local")
        let URL:NSString = url
        print(URL)
        let urlStr : NSString = URL.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
        
        let _url0 =  NSURL(string : urlStr as String)
        
        if let url0 = _url0 {
            
            let imageDownloader = dataDownloaderServiceTask(url: url0)
            imageDownloader.Download({ (data) in
                
                let qualityOfServiceClass = QOS_CLASS_BACKGROUND
                let backgroundQueue = dispatch_get_global_queue(qualityOfServiceClass, 0)
                dispatch_async(backgroundQueue, {
                    
                    let dataFromURL = data
                    
                    let res1 = dataFromURL.writeToURL(self.tempZipPath().URLByAppendingPathComponent((_url0?.lastPathComponent!)!) , atomically: true)
                    //print(self.tempZipPath().URLByAppendingPathComponent((_url0?.lastPathComponent!)!))
                    
                    let success1 = SSZipArchive.unzipFileAtPath(self.tempZipPath().URLByAppendingPathComponent((_url0?.lastPathComponent!)!).path!, toDestination: self.tempZipPath().path!)
                    
                    if res1 && success1
                    {
                        print("rates download completed")
                        let name = NSString(string:((_url0?.lastPathComponent!)!))
                        let path = NSURL(fileURLWithPath: self.tempZipPath().path!).URLByAppendingPathComponent("\(name.substringWithRange(NSRange(location: 0 , length: name.length - 4))).txt")
                        print(path)
                        
                        let date = NSDate()
                
                        //reading
                        do {
                            let text = try NSString(contentsOfURL: path, encoding: NSUTF8StringEncoding)
                            
                            if db.getOstanRatesRecord(OstanID).count > 0
                            {
                                db.updateOstanRates(OstanID, rates: text as String, date: date, lat: user.lat, long: user.long)
                            }
                            else
                            {
                                db.addOstanRates(OstanID, rates: text as String, date: date, lat: user.lat, long: user.long)
                            }
                        }
                        catch {/* error handling here */}
                    }
                })
            })
        }
    }
    
    internal func GetLocalDB_saveLocalDB(ostan_id:String)
    {
        var timestamp = ""
        
        if db.getLocalDBTimestamp() == "" {//for first time that local db will created - should download ostan with user location
            
            timestamp = "-1"
        }
        else
        {
            if db.getOstan(ostan_id).count > 0 {//we have this ostan - should update
                
                let diffDateComponents = NSCalendar.currentCalendar().components([NSCalendarUnit.Year, NSCalendarUnit.Month, NSCalendarUnit.Day, NSCalendarUnit.Hour, NSCalendarUnit.Minute, NSCalendarUnit.Second] , fromDate: (db.getOstan(ostan_id)[0].valueForKey("date") as! NSDate), toDate: NSDate(), options: NSCalendarOptions.init(rawValue: 0))
                
                print("\(NSDate())   \(db.getOstanRatesRecord(ostan_id)[0].valueForKey("date") as! NSDate)")
                print("\(diffDateComponents.day)   \(diffDateComponents.minute)")
                
                if (diffDateComponents.day > 2) {
                    
                    timestamp = db.getOstan(ostan_id)[0].valueForKey("timestamp") as! String
                }
                else{
                    return
                }
            }
            else//we havent this ostan - should dwonload
            {
                timestamp = "-1"
            }
        }
        print(timestamp)
        
        let URL:NSString =  String.localizedStringWithFormat(URLS.get_local, ostan_id , timestamp)
        print(URL)
        let urlStr : NSString = URL.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
        
        let _url0 =  NSURL(string : urlStr as String)
        
        if let url0 = _url0 {
            
            let imageDownloader = dataDownloaderServiceTask(url: url0)
            imageDownloader.Download({ (data) in
                
                var result = NSString(data: data, encoding: NSUTF8StringEncoding)!
                print(result)
                if (result.containsString("status") && result.containsString("-1")) || result == ""
                {
                    return
                }
                if timestamp != "-1"
                {
                    result = NSString(string : (_url0?.absoluteString)!)
                }
                self.downloadDB(result , OstanID: ostan_id , _timestamp: timestamp)
            })
        }
    }

    internal func downloadDB(url:NSString , OstanID:String , _timestamp:String)
    {
        print("download database local")
        let URL:NSString = url
        print(URL)
        let urlStr : NSString = URL.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
        
        let _url0 =  NSURL(string : urlStr as String)
        
        if let url0 = _url0 {
            
            let imageDownloader = dataDownloaderServiceTask(url: url0)
            imageDownloader.Download({ (data) in
                
                let qualityOfServiceClass = QOS_CLASS_BACKGROUND
                let backgroundQueue = dispatch_get_global_queue(qualityOfServiceClass, 0)
                dispatch_async(backgroundQueue, {
                    
                    let dataFromURL = data
                    
                    var res1 = false
                    var success1 = false
                    
                    if _timestamp == "-1"
                    {
                        res1 = dataFromURL.writeToURL(self.tempZipPath().URLByAppendingPathComponent((_url0?.lastPathComponent!)!) , atomically: true)
                        //print(self.tempZipPath().URLByAppendingPathComponent((_url0?.lastPathComponent!)!))
                        
                        success1 = SSZipArchive.unzipFileAtPath(self.tempZipPath().URLByAppendingPathComponent((_url0?.lastPathComponent!)!).path!, toDestination: self.tempZipPath().path!)
                        
                        if db.getLocalDBAddress() == url
                        {
                            success1 = true
                        }
                    }
                    else
                    {
                        res1 = true
                        success1 = true
                    }
                    
                    if res1 && success1
                    {
                        var name = NSString()
                        var path = NSURL()
                        
                        print("download completed")
                        if _timestamp == "-1"
                        {
                            name = NSString(string:((_url0?.lastPathComponent!)!)) as String
                            path = NSURL(fileURLWithPath: self.tempZipPath().path!).URLByAppendingPathComponent("\(name.substringWithRange(NSRange(location: 0 , length: name.length - 4))).txt")
                        }
            
                        //print(path)
                        let date = NSDate()
                        let calendar = NSCalendar.currentCalendar()
                        let components = calendar.componentsInTimeZone(NSTimeZone(abbreviation: "GMT+4:30")!, fromDate: date)
                        let day = components.day > 10 ? String(components.day) : "0\(components.day)"
                        let month = components.month > 10 ? String(components.month) : "0\(components.month)"
                        let hour = components.hour > 10 ? String(components.hour) : "0\(components.hour)"
                        let min = components.minute > 10 ? String(components.minute) : "0\(components.minute)"
                        let second = components.second > 10 ? String(components.second) : "0\(components.second)"
                        let timestamp = String(components.year) + month + day + hour + min + second
                        
        
                        //reading
                        do {
                            var text = NSString()
                            
                            if _timestamp == "-1"
                            {
                                text = try NSString(contentsOfURL: path, encoding: NSUTF8StringEncoding)
                            }
                            else
                            {
                                text = NSString(data: dataFromURL, encoding: NSUTF8StringEncoding)!
                            }
                            
                            let lines:[String] = text.componentsSeparatedByString("\n")
                            
                            if db.getLocalDBOstanID() == "" //for first time that local db will created
                            {
                                db.addLocalDBStatus(true , path: text as String , count: lines.count , timestamp:timestamp , address: url as String , Date: date , OstanID:OstanID)
                                db.addOstans(OstanID, timestamp: timestamp , date: date)
                            }
                            else if db.getLocalDBOstanID() == OstanID
                            {
                                db.updateLocalDB(true, path: text as String, count: lines.count, timestamp: timestamp, address: url as String , Date: date , OstanID:OstanID , type: false)
                                db.updateOstans(OstanID, timestamp: timestamp , date: date)
                            }
                            else if db.getLocalDBOstanID() != OstanID
                            {
                                db.updateLocalDB(true, path: text as String, count: lines.count, timestamp: timestamp, address: url as String , Date: date , OstanID:OstanID , type: true)
                                db.addOstans(OstanID, timestamp: timestamp , date: date)
                            }
                            
                            //db.getLocalDBPath().componentsSeparatedByString("\n")
                        }
                        catch {/* error handling here */}
                    }
                })
            })
        }
    }
    
    internal func tempZipPath() -> NSURL {
        
        let documentsUrl =  NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first
        return documentsUrl!
        
    }
    
    internal func addLocalDBRecord(name:String , phone:String , id:Int , lat:Double , long:Double)
    {
        let entity = NSEntityDescription.entityForName("Bizs", inManagedObjectContext: context)
        let biz = NSManagedObject(entity: entity!, insertIntoManagedObjectContext:context)
        biz.setValue(id, forKey: "id")
        biz.setValue(lat, forKey: "lat")
        biz.setValue(long, forKey: "long")
        biz.setValue(phone, forKey: "phone")
        biz.setValue(name, forKey: "name")
        
        do
        {
            try context.save()
        }
        catch _
        {
            
        }
    }
    
    internal func getBizs()->[NSManagedObject]
    {
        let req = NSFetchRequest(entityName: "Bizs")
        
        do
        {
            let biz :[NSManagedObject]? = try context.executeFetchRequest(req) as? [NSManagedObject]
            
            if let bizs = biz
            {
                if bizs.count > 0 {
                    
                    return bizs
                }
                else
                {
                    return []
                }
            }
        }
        catch _
        {
            
        }
        return []
    }
    
    internal func addFailedComment(_comment: String , rate : Double , biz_id : Int , openion:String , user_id:Int , token:String)
    {
        print(String(Int(CACurrentMediaTime())))
        let entity = NSEntityDescription.entityForName("FailedComments", inManagedObjectContext: context)
        let comment = NSManagedObject(entity: entity!, insertIntoManagedObjectContext:context)
        comment.setValue(biz_id, forKey: "bizid")
        comment.setValue(rate, forKey: "rate")
        comment.setValue(_comment, forKey: "comment")
        comment.setValue(openion, forKey: "openion")
        comment.setValue(user_id, forKey: "user_id")
        comment.setValue(token, forKey: "token")
        comment.setValue(String(Int(CACurrentMediaTime())), forKey: "id")
        
        do
        {
            try context.save()
        }
        catch _
        {
            
        }
    }
    internal func removeFailedComment(id:String)
    {
        let req = NSFetchRequest(entityName: "FailedComments")
        
        do
        {
            let comment :[NSManagedObject]? = try context.executeFetchRequest(req) as? [NSManagedObject]
            
            if let comments = comment
            {
                if comments.count > 0 {
                    
                    var index:Int = 0
                    
                    for  object in comments {
                        
                        if (object.valueForKey("id") as! String == id) {
                            
                            context.deleteObject(object)
                            break
                        }
                        index = index + 1
                    }
                    do
                    {
                        try context.save()
                    }
                    catch
                    {
                        let saveError = error as NSError
                        print(saveError)
                    }
                }
            }
        }
        catch
        {
            let saveError = error as NSError
            print(saveError)
        }
    }
    internal func getFailedComment()->[NSManagedObject]
    {
        let req = NSFetchRequest(entityName: "FailedComments")
        
        do
        {
            let comment :[NSManagedObject]? = try context.executeFetchRequest(req) as? [NSManagedObject]
            
            if let comments = comment
            {
                if comments.count > 0 {
                    
                    return comments
                }
                else
                {
                    return []
                }
            }
        }
        catch _
        {
            
        }
        return []
    }
    
    internal func addFailedReport(reason: String , comment_id : Int)
    {
        print(String(Int(CACurrentMediaTime())))
        let entity = NSEntityDescription.entityForName("FailedReports", inManagedObjectContext: context)
        let comment = NSManagedObject(entity: entity!, insertIntoManagedObjectContext:context)
        comment.setValue(comment_id, forKey: "comment_id")
        comment.setValue(reason, forKey: "reason")
        comment.setValue(String(Int(CACurrentMediaTime())), forKey: "id")
        
        do
        {
            try context.save()
        }
        catch _
        {
            
        }
    }
    internal func removeFailedReport(id:String)
    {
        let req = NSFetchRequest(entityName: "FailedReports")
        
        do
        {
            let Report :[NSManagedObject]? = try context.executeFetchRequest(req) as? [NSManagedObject]
            
            if let Reports = Report
            {
                if Reports.count > 0 {
                    
                    var index:Int = 0
                    
                    for  object in Reports {
                        
                        if (object.valueForKey("id") as! String == id) {
                            
                            context.deleteObject(object)
                            break
                        }
                        index = index + 1
                    }
                    do
                    {
                        try context.save()
                    }
                    catch
                    {
                        let saveError = error as NSError
                        print(saveError)
                    }
                }
            }
        }
        catch
        {
            let saveError = error as NSError
            print(saveError)
        }
    }
    internal func getFailedReport()->[NSManagedObject]
    {
        let req = NSFetchRequest(entityName: "FailedReports")
        
        do
        {
            let Report :[NSManagedObject]? = try context.executeFetchRequest(req) as? [NSManagedObject]
            
            if let Reports = Report
            {
                if Reports.count > 0 {
                    
                    return Reports
                }
                else
                {
                    return []
                }
            }
        }
        catch _
        {
            
        }
        return []
    }
    
    internal func getVersion()->[NSManagedObject]
    {
        let req = NSFetchRequest(entityName: "AppVersion")
        
        do
        {
            let fav :[NSManagedObject]? = try context.executeFetchRequest(req) as? [NSManagedObject]
            
            if let favs = fav
            {
                if favs.count > 0 {
                    
                    return favs
                }
                else
                {
                    return []
                }
            }
        }
        catch _
        {
            
        }
        return []
    }
    internal func addVersion(vServer:String , vAppStore:String)
    {
        let entity = NSEntityDescription.entityForName("AppVersion", inManagedObjectContext: context)
        let fav = NSManagedObject(entity: entity!, insertIntoManagedObjectContext:context)
        fav.setValue(vServer, forKey: "vServer")
        fav.setValue(vAppStore, forKey: "vAppStore")
        
        do
        {
            try context.save()
        }
        catch _
        {
            
        }
    }
    internal func updateVersion(vServer:String , vAppStore:String)
    {
        
        let req = NSFetchRequest(entityName: "AppVersion")
        
        do
        {
            let user :[NSManagedObject]? = try context.executeFetchRequest(req) as? [NSManagedObject]
            
            if let users = user
            {
                if users.count > 0 {
                    
                    users[0].setValue(vServer, forKey: "vServer")
                    users[0].setValue(vAppStore, forKey: "vAppStore")
                    
                    do
                    {
                        try context.save()
                    }
                    catch
                    {
                        let saveError = error as NSError
                        print(saveError)
                    }
                }
            }
        }
        catch
        {
            let saveError = error as NSError
            print(saveError)
        }
    }
    internal func getOstan(id:String)->[NSManagedObject]
    {
        let req = NSFetchRequest(entityName: "Ostans")
        
        do
        {
            let fav :[NSManagedObject]? = try context.executeFetchRequest(req) as? [NSManagedObject]
            
            if let favs = fav
            {
                if favs.count > 0 {
                    
                    for obj in favs {
                        
                        if obj.valueForKey("id") as! String == id {
                            
                            return [obj]
                        }
                    }
                }
                else
                {
                    return []
                }
            }
        }
        catch _
        {
            
        }
        return []
    }
    internal func addOstans(id:String , timestamp:String , date:NSDate)
    {
        let entity = NSEntityDescription.entityForName("Ostans", inManagedObjectContext: context)
        let fav = NSManagedObject(entity: entity!, insertIntoManagedObjectContext:context)
        fav.setValue(id, forKey: "id")
        fav.setValue(timestamp, forKey: "timestamp")
        fav.setValue(date, forKey: "date")
        do
        {
            try context.save()
        }
        catch _
        {
            
        }
    }
    internal func updateOstans(id:String , timestamp:String  , date:NSDate)
    {
        let req = NSFetchRequest(entityName: "Ostans")
        
        do
        {
            let user :[NSManagedObject]? = try context.executeFetchRequest(req) as? [NSManagedObject]
            
            if let users = user
            {
                if users.count > 0 {
                    
                    for obj in users {
                        
                        if obj.valueForKey("id") as! String == id {
                            
                            obj.setValue(id, forKey: "id")
                            obj.setValue(timestamp, forKey: "timestamp")
                            obj.setValue(date, forKey: "date")
                            
                            do
                            {
                                try context.save()
                                break
                            }
                            catch
                            {
                                let saveError = error as NSError
                                print(saveError)
                                break
                            }
                        }
                    }
                }
            }
        }
        catch
        {
            let saveError = error as NSError
            print(saveError)
        }
    }
    internal func addOstanRates(id:String , rates:String , date:NSDate , lat:Double , long:Double)
    {
        let entity = NSEntityDescription.entityForName("LocalRateDB", inManagedObjectContext: context)
        let fav = NSManagedObject(entity: entity!, insertIntoManagedObjectContext:context)
        fav.setValue(id, forKey: "ostan_id")
        fav.setValue(rates, forKey: "ratesText")
        fav.setValue(date, forKey: "date")
        fav.setValue(lat, forKey: "long")
        fav.setValue(long, forKey: "lat")
        do
        {
            try context.save()
        }
        catch _
        {
            
        }
    }
    internal func updateOstanRates(id:String , rates:String , date:NSDate , lat:Double , long:Double)
    {
        let req = NSFetchRequest(entityName: "LocalRateDB")
        
        do
        {
            let user :[NSManagedObject]? = try context.executeFetchRequest(req) as? [NSManagedObject]
            
            if let users = user
            {
                if users.count > 0 {
                    
                    for obj in users {
                        
                        if obj.valueForKey("ostan_id") as! String == id {
                            
                            obj.setValue(id, forKey: "ostan_id")
                            obj.setValue(rates, forKey: "ratesText")
                            obj.setValue(date, forKey: "date")
                            obj.setValue(lat, forKey: "long")
                            obj.setValue(long, forKey: "lat")
                            
                            do
                            {
                                try context.save()
                                break
                            }
                            catch
                            {
                                let saveError = error as NSError
                                print(saveError)
                                break
                            }
                        }
                    }
                }
            }
        }
        catch
        {
            let saveError = error as NSError
            print(saveError)
        }
    }
    internal func getOstanRatesRecord(lat:Double , long:Double)->[NSManagedObject]
    {
        let req = NSFetchRequest(entityName: "LocalRateDB")
        
        do
        {
            let fav :[NSManagedObject]? = try context.executeFetchRequest(req) as? [NSManagedObject]
        
            if let favs = fav
            {
                if favs.count > 0 {
                    
                    for obj in favs {
                        
                        if obj.valueForKey("lat") as! Double == lat && obj.valueForKey("long") as! Double == long {
                            
                            return [obj]
                        }
                    }
                }
                else
                {
                    return []
                }
            }
        }
        catch _
        {
            
        }
        return []
    }
    internal func getOstanRatesRecord(ostan_id:String)->[NSManagedObject]
    {
        let req = NSFetchRequest(entityName: "LocalRateDB")
        
        do
        {
            let fav :[NSManagedObject]? = try context.executeFetchRequest(req) as? [NSManagedObject]
            
            if let favs = fav
            {
                if favs.count > 0 {
                    
                    for obj in favs {
                        
                        if obj.valueForKey("ostan_id") as! String == ostan_id{
                            
                            return [obj]
                        }
                    }
                }
                else
                {
                    return []
                }
            }
        }
        catch _
        {
            
        }
        return []
    }
}
