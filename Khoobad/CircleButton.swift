//
//  CircleButton.swift
//  Keylead
//
//  Created by Li W on 7/19/1394 AP.
//  Copyright © 1394 Mehrshad Jalilmasir. All rights reserved.
//

import UIKit

class CircleButtonSend: UIButton {

    required init(coder aDecoder: NSCoder) {
        super.init(coder :aDecoder)!
        
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupButtonStyle()
    }
    
    override func awakeFromNib() {
        
        setupButtonStyle()
    }
    
    func setupButtonStyle()
    {
        self.layer.backgroundColor = UIColor.whiteColor().CGColor
        self.layer.borderColor = UIColor.lightGrayColor().CGColor
        self.layer.borderWidth = 1.0
        //self.setTitleColor(UIColor.orangeColor(), forState: UIControlState.Normal)
        self.layer.cornerRadius = self.layer.bounds.size.width/2
        self.titleLabel!.font = UIFont(name: "B Yekan", size: 14)
    }
    
    override var highlighted: Bool {
        didSet {
            
            if (highlighted) {
                self.backgroundColor = UIColor.darkGrayColor()
            }
            else {
                self.backgroundColor = UIColor.clearColor()
            }
            
        }
    }
}

class CircleButtonInSearch: UIButton {
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder :aDecoder)!
        
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupButtonStyle()
    }
    
    override func awakeFromNib() {
        
        setupButtonStyle()
    }
    
    func setupButtonStyle()
    {
        self.layer.backgroundColor = UIColor.whiteColor().CGColor
        self.layer.borderColor = UIColor.lightGrayColor().colorWithAlphaComponent(0.5).CGColor
        self.layer.borderWidth = 1.5
        self.setTitleColor(UIColor.orangeColor(), forState: UIControlState.Normal)
        self.layer.cornerRadius = self.layer.bounds.size.width/2
        self.titleLabel!.font = UIFont(name: "Times New Roman", size: 12)
    }
    
    override var highlighted: Bool {
        didSet {
        
        if (highlighted) {
            //self.backgroundColor = UIColor.darkGrayColor()
        }
        else {
            //self.backgroundColor = UIColor.groupTableViewBackgroundColor().colorWithAlphaComponent(0.25)
        }
        
        }
    }
}
