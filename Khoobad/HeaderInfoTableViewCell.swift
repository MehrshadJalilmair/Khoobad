//
//  HeaderInfoTableViewCell.swift
//  Khoobad
//
//  Created by Mehrshad Jalilmasir on 6/27/16.
//  Copyright © 2016 Mehrshad Jalilmasir. All rights reserved.
//

import UIKit


protocol Infoing
{
    func call(cell : HeaderInfoTableViewCell)
    func order(cell : HeaderInfoTableViewCell)
    func map(cell : HeaderInfoTableViewCell)
    func moreInfo(cell : HeaderInfoTableViewCell)
}
class HeaderInfoTableViewCell: UITableViewCell {
    
    @IBOutlet weak var phone: UIButton!
    @IBOutlet weak var address: UILabel!
    var delegate:Infoing!
    @IBOutlet weak var relatedBizes: UIButton!
    
    @IBOutlet weak var BizTellBackground: UIView!
    @IBOutlet var infoContentView: UIView!
    
    var Biz:HomeBiz!
    {
        didSet
        {
            updateUI()
        }
    }
    
    func updateUI()
    {
        self.phone.setTitle(Biz.phone, forState: UIControlState.Normal)
        self.address.text = Biz.address
        
        if Biz.phone == "" {
            
            self.phone.setTitle("-", forState: UIControlState.Normal)
        }
        
        self.BizTellBackground.layer.backgroundColor = UIColor.whiteColor().CGColor
        self.BizTellBackground.layer.cornerRadius = 5.0
        self.BizTellBackground.layer.masksToBounds = false
        self.BizTellBackground.layer.borderWidth = 1
        self.BizTellBackground.layer.borderColor = UIColor(red: 144/255, green: 220/255, blue: 90/255, alpha: 1).CGColor
        
        self.relatedBizes.layer.backgroundColor = UIColor.whiteColor().CGColor
        self.relatedBizes.layer.cornerRadius = 5.0
        self.relatedBizes.layer.masksToBounds = false
        self.relatedBizes.layer.borderWidth = 1.5
        self.relatedBizes.layer.borderColor = UIColor(red: 0/255, green: 162/255, blue: 232/255, alpha: 1).CGColor
        
        let topLine = UIView(frame: CGRect(x: 0, y: 0, width: infoContentView.bounds.width + 1, height: 2))
        topLine.backgroundColor = UIColor(red: 0/255, green: 162/255, blue: 232/255, alpha: 1)
        let bottomLine = UIView(frame: CGRect(x: 0, y: infoContentView.frame.height - 2 , width: infoContentView.bounds.width + 1, height: 2))
        bottomLine.backgroundColor = UIColor(red: 0/255, green: 162/255, blue: 232/255, alpha: 1)
        
        infoContentView.addSubview(topLine)
        infoContentView.addSubview(bottomLine)
    }
    @IBAction func specOrdersClicked(sender: AnyObject) {
        
        delegate.order(self)
    }
    @IBAction func MapingClicked(sender: AnyObject) {
        
        delegate.map(self)
    }
    
    @IBAction func moreInfo(sender: AnyObject) {
        
        delegate.moreInfo(self)
    }
    @IBAction func callClicked(sender: AnyObject) {
        
        delegate.call(self)
    }
    @IBAction func callClicked1(sender: AnyObject) {
        
        delegate.call(self)
    }
    
}
