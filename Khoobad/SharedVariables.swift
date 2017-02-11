//
//  SharedVariables.swift
//  Khoobad
//
//  Created by Mehrshad Jalilmasir on 6/7/16.
//  Copyright © 2016 Mehrshad Jalilmasir. All rights reserved.
//

import UIKit

class SharedVariables: NSObject {
    
    var homeBisunessCount:Int = 0
    
    internal static var defaultImage1 = UIImage(named:"default_image.jpg")
    internal static var defaultImage2 = UIImage(named:"default_image.jpg")
    internal static var defaultImage3 = UIImage(named:"default_image.jpg")
    
    func fromLocal()
    {
        categories = [category]()
        subCategories = [category]()
        
        categories.append(category(id: 1, name: "خرید", desc: NSNull() , parent_id: NSNull()))
        categories.append(category(id: 2, name: "خوراکی", desc: NSNull() , parent_id: NSNull()))
        categories.append(category(id: 3, name: "گردشگری و تفریحی", desc: NSNull() , parent_id: NSNull()))
        categories.append(category(id: 4, name: "پوشاک", desc: NSNull() , parent_id: NSNull()))
        categories.append(category(id: 5, name: "ادارات و شرکت ها", desc: NSNull() , parent_id: NSNull()))
        categories.append(category(id: 6, name: "پزشکی و درمانی", desc: NSNull() , parent_id: NSNull()))
        categories.append(category(id: 7, name: "بهداشتی", desc: NSNull() , parent_id: NSNull()))
        categories.append(category(id: 8, name: "مدرسه و آموزشگاه", desc: NSNull() , parent_id: NSNull()))
        categories.append(category(id: 9, name: "لوازم خانه", desc: NSNull() , parent_id: NSNull()))
        categories.append(category(id: 10, name: "خدماتی", desc: NSNull() , parent_id: NSNull()))
        categories.append(category(id: 11, name: "ورزش و سرگرمی", desc: NSNull() , parent_id: NSNull()))
        categories.append(category(id: 12, name: "نقلیه", desc: NSNull() , parent_id: NSNull()))
        categories.append(category(id: 13, name: "خدمات خودرو", desc: NSNull() , parent_id: NSNull()))
        categories.append(category(id: 14, name: "مادر و کودک", desc: NSNull() , parent_id: NSNull()))
        categories.append(category(id: 15, name: "فرهنگی", desc: NSNull() , parent_id: NSNull()))
        
        subCategories.append(category(id: 17, name: "مرکز خرید و فروشگاه", desc: NSNull() , parent_id: "1"))
        subCategories.append(category(id: 18, name: "سوپرمارکت", desc: NSNull() , parent_id:"1"))
        subCategories.append(category(id: 19, name: "نانوایی", desc: NSNull() , parent_id: "1"))
        subCategories.append(category(id: 20, name: "شیرینی و خشکبار", desc: NSNull() , parent_id: "1"))
        subCategories.append(category(id: 21, name: "میوه و تره بار", desc: NSNull() , parent_id: "1"))
        subCategories.append(category(id: 22, name: "پروتئینی و لبنی", desc: NSNull() , parent_id: "1"))
        
        subCategories.append(category(id: 23, name: "رستوران", desc: NSNull() , parent_id: "2"))
        subCategories.append(category(id: 24, name: "فست فود", desc: NSNull() , parent_id: "2"))
        subCategories.append(category(id: 25, name: "تهیه غذا", desc: NSNull() , parent_id: "2"))
        subCategories.append(category(id: 26, name: "کافه", desc: NSNull() , parent_id: "2"))
        
        subCategories.append(category(id: 27, name: "موزه ها", desc: NSNull() , parent_id: "3"))
        subCategories.append(category(id: 28, name: "آثار باستانی", desc: NSNull() , parent_id: "3"))
        subCategories.append(category(id: 29, name: "هتل", desc: NSNull() , parent_id: "3"))
        subCategories.append(category(id: 30, name: "آژانس مسافرتی", desc: NSNull() , parent_id:"3"))
        subCategories.append(category(id: 31, name: "اماکن تفریحی", desc: NSNull() , parent_id: "3"))
        
        subCategories.append(category(id: 32, name: "مزون لباس", desc: NSNull() , parent_id: "4"))
        subCategories.append(category(id: 33, name: "فروشگاه", desc: NSNull() , parent_id: "4"))
        subCategories.append(category(id: 34, name: "لباس کودک", desc: NSNull() , parent_id: "4"))
        
        subCategories.append(category(id: 35, name: "ادارات دولتی", desc: NSNull() , parent_id: "5"))
        subCategories.append(category(id: 36, name: "کسب و کار های اینترنتی", desc: NSNull() , parent_id: "5"))
        subCategories.append(category(id: 37, name: "شرکت ها و موسسات", desc: NSNull() , parent_id: "5"))
        
        subCategories.append(category(id: 38, name: "پزشک", desc: NSNull() , parent_id: "6"))
        subCategories.append(category(id: 39, name: "زیبایی", desc: NSNull() , parent_id: "6"))
        subCategories.append(category(id: 40, name: "تجهیزات پزشکی", desc: NSNull() , parent_id: "6"))
        subCategories.append(category(id: 41, name: "داروخانه و عطاری", desc: NSNull() , parent_id: "6"))
        subCategories.append(category(id: 42, name: "بیمارستان ها و درمانگاه ها", desc: NSNull() , parent_id: "6"))
        subCategories.append(category(id: 43, name: "کلینیک", desc: NSNull() , parent_id: "6"))
        
        subCategories.append(category(id: 44, name: "آرایشی", desc: NSNull() , parent_id: "7"))
        subCategories.append(category(id: 45, name: "بهداشتی", desc: NSNull() , parent_id: "7"))
        subCategories.append(category(id: 46, name: "لوازم شخصی", desc: NSNull() , parent_id: "7"))
        subCategories.append(category(id: 47, name: "برقی", desc: NSNull() , parent_id: "7"))
        
        subCategories.append(category(id: 48, name: "مدرسه و مهدکودک", desc: NSNull() , parent_id: "8"))
        subCategories.append(category(id: 49, name: "آموزشگاه ها", desc: NSNull() , parent_id: "8"))
        subCategories.append(category(id: 50, name: "تجهیزات آموزشی", desc: NSNull() , parent_id: "8"))
        
        subCategories.append(category(id: 51, name: "دکوراسیون", desc: NSNull() , parent_id:"9"))
        subCategories.append(category(id: 52, name: "وسایل برقی", desc: NSNull() , parent_id:"9"))
        subCategories.append(category(id: 53, name: "آشپزخانه", desc: NSNull() , parent_id: "9"))
        subCategories.append(category(id: 54, name: "سرو پذیرایی", desc: NSNull() , parent_id: "9"))
        subCategories.append(category(id: 55, name: "فرش", desc: NSNull() , parent_id: "9"))
        subCategories.append(category(id: 56, name: "خواب و حمام", desc: NSNull() , parent_id: "9"))
        subCategories.append(category(id: 57, name: "شست و شو و نظافت", desc: NSNull() , parent_id: "9"))
        subCategories.append(category(id: 58, name: "ابزار", desc: NSNull() , parent_id: "9"))
        subCategories.append(category(id: 59, name: "نور و روشنایی", desc: NSNull() , parent_id: "9"))
        
        subCategories.append(category(id: 60, name: "آرایشگاه", desc: NSNull() , parent_id: "10"))
        subCategories.append(category(id: 61, name: "آژانس مسافرتی", desc: NSNull() , parent_id: "10"))
        subCategories.append(category(id: 62, name: "مشاور املاک", desc: NSNull() , parent_id: "10"))
        subCategories.append(category(id: 63, name: "تجهیزات ساختمان", desc: NSNull() , parent_id: "10"))
        subCategories.append(category(id: 64, name: "تشریفات", desc: NSNull() , parent_id: "10"))
        subCategories.append(category(id: 65, name: "پیشخوان دولت", desc: NSNull() , parent_id: "10"))
        subCategories.append(category(id: 66, name: "بیمه", desc: NSNull() , parent_id: "10"))
        subCategories.append(category(id: 67, name: "پلیس", desc: NSNull() , parent_id: "10"))
        subCategories.append(category(id: 68, name: "صرافی", desc: NSNull() , parent_id: "10"))
        subCategories.append(category(id: 69, name: "بانک و موسسات مالی", desc: NSNull() , parent_id: "10"))
        subCategories.append(category(id: 70, name: "خدمات اداری و حقوقی", desc: NSNull() , parent_id: "10"))
        subCategories.append(category(id: 71, name: "منزل", desc: NSNull() , parent_id: "10"))
        subCategories.append(category(id: 72, name: "کامپیوتر و موبایل", desc: NSNull() , parent_id: "10"))
        subCategories.append(category(id: 73, name: "تبلیغات و بازاریابی", desc: NSNull() , parent_id: "10"))
        subCategories.append(category(id: 74, name: "حیوانات خانگی", desc: NSNull() , parent_id: "10"))
        subCategories.append(category(id: 75, name: "آموزشی", desc: NSNull() , parent_id: "10"))
        subCategories.append(category(id: 76, name: "نظافتی", desc: NSNull() , parent_id: "10"))
        
        subCategories.append(category(id: 77, name: "پوشاک ورزشی", desc: NSNull() , parent_id: "11"))
        subCategories.append(category(id: 78, name: "لوازم ورزشی", desc: NSNull() , parent_id: "11"))
        subCategories.append(category(id: 79, name: "مراکز تفریحی", desc: NSNull() , parent_id: "11"))
        subCategories.append(category(id: 80, name: "مراکز ورزشی", desc: NSNull() , parent_id: "11"))
        subCategories.append(category(id: 81, name: "اسباب بازی", desc: NSNull() , parent_id: "11"))
        subCategories.append(category(id: 82, name: "مراکز آموزشی", desc: NSNull() , parent_id: "11"))
        subCategories.append(category(id: 83, name: "کافی نت و گیم نت", desc: NSNull() , parent_id: "11"))
        
        subCategories.append(category(id: 84, name: "تاکسی تلفنی", desc: NSNull() , parent_id: "12"))
        subCategories.append(category(id: 85, name: "پیک موتوری", desc: NSNull() , parent_id: "12"))
        subCategories.append(category(id: 86, name: "پارکینگ", desc: NSNull() , parent_id: "12"))
        subCategories.append(category(id: 87, name: "پمپ بنزین و گاز", desc: NSNull() , parent_id: "12"))
        subCategories.append(category(id: 88, name: "باربری", desc: NSNull() , parent_id: "12"))
        subCategories.append(category(id: 89, name: "نقلیه عمومی", desc: NSNull() , parent_id: "12"))
        
        subCategories.append(category(id: 90, name: "نمایندگی خودرو و فروش", desc: NSNull() , parent_id: "13"))
        subCategories.append(category(id: 91, name: "لوازم خودرو", desc: NSNull() , parent_id: "13"))
        subCategories.append(category(id: 92, name: "تعمیرات و خدمات", desc: NSNull() , parent_id: "13"))
        
        subCategories.append(category(id: 93, name: "خیریه و امور اجتماعی", desc: NSNull() , parent_id: "10"))
        
        subCategories.append(category(id: 96, name: "اسباب بازی", desc: NSNull() , parent_id: "14"))
        subCategories.append(category(id: 97, name: "لباس کودک", desc: NSNull() , parent_id: "14"))
        subCategories.append(category(id: 98, name: "اتاق کودک", desc: NSNull() , parent_id: "14"))
        subCategories.append(category(id: 99, name: "سلامت کودک", desc: NSNull() , parent_id: "14"))
        subCategories.append(category(id: 100, name: "لوازم مادر", desc: NSNull() , parent_id: "14"))
        
        subCategories.append(category(id: 101, name: "سینما", desc: NSNull() , parent_id: "15"))
        subCategories.append(category(id: 102, name: "فرهنگسرا", desc: NSNull() , parent_id: "15"))
        subCategories.append(category(id: 103, name: "کتابخانه و کتاب فروشی", desc: NSNull() , parent_id: "15"))
        subCategories.append(category(id: 104, name: "آموزشگاه های هنری", desc: NSNull() , parent_id: "15"))
        subCategories.append(category(id: 105, name: "لوازم موسیقی", desc: NSNull() , parent_id: "15"))
        
        NSNotificationCenter.defaultCenter().postNotificationName("reloadCategoryList", object: nil)
    }
    func getCategories()//just local getting --> remove netting
    {
        //get categories
        if categories.count == 0 {
            
            if reachabilityStatus == KNOTREACHABLE || _NOP
            {
                //from local
                //categorySearchBtn.enabled = true
                //nearSearchBtn.enabled = true
                fromLocal()
            }
            else if reachabilityStatus != KNOTREACHABLE && !_NOP
            {
                let _url =  NSURL(string : URLS.category)
                if let url = _url {
                    
                    let categoryDownloader = dataDownloaderServiceTask(url: url)
                    categoryDownloader.Download({ (data) in
                        
                        let _Categories = try! NSJSONSerialization.JSONObjectWithData(data , options: NSJSONReadingOptions()) as! NSArray
                        
                        categories = [category]()
                        subCategories = [category]()
                        
                        print(_Categories)
                        for object in _Categories
                        {
                            //print(object)
                            guard let ActualObject = object as? [String : AnyObject] else
                            {
                                continue
                            }
                            let id:Int = ActualObject["id"] as! Int
                            let name:String = ActualObject["name"] as! String
                            let desc:AnyObject = ActualObject["desc"]!
                            let parent_id:AnyObject = ActualObject["parent_id"]!
                            
                            let newObj = category(id: id, name: name, desc: desc, parent_id: parent_id)
                            
                            if newObj.parent_id is NSNull
                            {
                                categories.append(newObj)
                                //print("category \(id) \(name) \(desc) \(parent_id)")
                            }
                            else
                            {
                                subCategories.append(newObj)
                                //print("subCategory \(id) \(name) \(desc) \(parent_id)")
                            }
                            
                            //save to db
                        }
                        NSNotificationCenter.defaultCenter().postNotificationName("reloadCategoryList", object: nil)
                        
                        if _Categories.count > 0
                        {
                            
                        }
                        else
                        {
                            self.fromLocal()
                        }
                        dispatch_async(dispatch_get_main_queue(), {
                            
                            
                            //print(categories.count)
                            //print(subCategories.count)
                            //self.categorySearchBtn.enabled = true
                            //self.nearSearchBtn.enabled = true
                        })
                    })
                }
            }
        }
    }
    
    func screen()->CGRect
    {
        let bounds = UIScreen.mainScreen().bounds
        return bounds
    }
}
