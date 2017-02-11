//
//  BizForRegister.swift
//  Khoobad
//
//  Created by Mehrshad Jalilmasir on 7/18/16.
//  Copyright © 2016 Mehrshad Jalilmasir. All rights reserved.
//

import UIKit

struct cat {
    
    var category_id:String = ""
    var cat_name = ""
    
    init(id:String , name:String )
    {
        self.cat_name = name
        self.category_id = id
    }
}

class BizForRegister: NSObject {

    var name:String = ""
    var phone:String = ""
    var desc:String = ""
    var address:String = ""
    var lat:Double = 0.0
    var long:Double = 0.0
    var off:String = "0"
    var website = ""
    var categories:[String:cat] = [String:cat]()
}
