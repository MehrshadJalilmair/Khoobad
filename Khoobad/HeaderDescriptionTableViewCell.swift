//
//  HeaderDescriptionTableViewCell.swift
//  Khoobad
//
//  Created by Mehrshad Jalilmasir on 6/27/16.
//  Copyright © 2016 Mehrshad Jalilmasir. All rights reserved.
//

import UIKit


class HeaderDescriptionTableViewCell: UITableViewCell {


    @IBOutlet weak var bizName: UILabel!
    @IBOutlet weak var bizDesc: UILabel!
    
    var Biz:HomeBiz!
    {
        didSet
    {
        updateUI()
        }
    }
    
    func updateUI()
    {
        print(Biz.Rate)
        //self.BizRateView.layer.borderColor = UIColor.redColor().CGColor
        //self.BizRateView.center = CGPointMake(50, 50)
        
        self.bizName.text = Biz.name
        self.bizDesc.text = Biz.desc
        if Biz.desc == "" {
            
            //self.BizDescView.text = "شعار ما : \(Biz.slogan)"
            bizDesc.text = "-"
        }
    }
}
