//
//  category.swift
//  Khoobad
//
//  Created by Mehrshad Jalilmasir on 7/2/16.
//  Copyright © 2016 Mehrshad Jalilmasir. All rights reserved.
//

import UIKit

class category: NSObject {

    var id = -1
    var name = ""
    var desc:AnyObject!
    var parent_id:AnyObject!
    
    init(id:Int , name:String , desc:AnyObject , parent_id:AnyObject) {
        
        self.id = id
        self.name = name
        self.desc = desc
        self.parent_id = parent_id
    }
}
