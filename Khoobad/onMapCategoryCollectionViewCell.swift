//
//  onMapCategoryCollectionViewCell.swift
//  Khoobad
//
//  Created by Mehrshad Jalilmasir on 7/3/16.
//  Copyright © 2016 Mehrshad Jalilmasir. All rights reserved.
//

import UIKit

protocol onMapShowSubs
{
    func categorySelected(cell:onMapCategoryCollectionViewCell)
}

class onMapCategoryCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var categoryBtn: CircleButtonInSearch!
    
    @IBOutlet weak var categoryName: UILabel!
    
    var delegate:onMapShowSubs!
    
    var Category:category!
        {
        didSet{
        
        updateUI()
        }
    }
    
    func updateUI()
    {
        categoryBtn.setImage(UIImage(named: "\(self.Category.id).png"), forState: UIControlState.Normal)
        categoryName.text = self.Category.name
    }
    
    @IBAction func categorySelected(sender: AnyObject) {
        
        delegate.categorySelected(self)
    }
}
