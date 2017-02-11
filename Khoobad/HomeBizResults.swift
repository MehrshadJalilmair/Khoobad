//
//  HomeBizResults.swift
//  Khoobad
//
//  Created by Mehrshad Jalilmasir on 6/8/16.
//  Copyright © 2016 Mehrshad Jalilmasir. All rights reserved.
//

import UIKit

class HomeBizResults: NSObject {

    var HomeBizesArr = [Int:HomeBiz]()
    var HomeBizesIDS = [Int]()
    var HomeBizesCount:Int!
    var HomeBizesDistance:Int!
    var HomeBizesStatus:String!
    
    init(HomeBizes : [Int:HomeBiz], HomeBizesIDS : [Int] , HomeBizesCount:Int , HomeBizesDistance:Int , HomeBizesStatus:String) {
        
        self.HomeBizesCount = HomeBizesCount
        self.HomeBizesStatus = HomeBizesStatus
        self.HomeBizesDistance = HomeBizesDistance
        self.HomeBizesArr = HomeBizes
        self.HomeBizesIDS = HomeBizesIDS
    }
}
