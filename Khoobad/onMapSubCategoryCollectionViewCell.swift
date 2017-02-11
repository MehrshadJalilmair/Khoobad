//
//  onMapSubCategoryCollectionViewCell.swift
//  Khoobad
//
//  Created by Mehrshad Jalilmasir on 7/3/16.
//  Copyright © 2016 Mehrshad Jalilmasir. All rights reserved.
//

import UIKit

protocol onMapShowBizes
{
    func subCategorySelected(cell:onMapSubCategoryCollectionViewCell)
}

class onMapSubCategoryCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var subCategoryBtn: CircleButtonInSearch!
    
    @IBOutlet weak var subCategoryName: UILabel!
    
    var delegate:onMapShowBizes!
    
    var subCategory:category!
        {
        didSet{
        
        updateUI()
        }
    }
    
    func updateUI()
    {
        subCategoryBtn.setImage(UIImage(named: "\(self.subCategory.id).png"), forState: UIControlState.Normal)
        subCategoryName.text = self.subCategory.name
    }
    
    @IBAction func subCategorySelected(sender: AnyObject) {
        
        delegate.subCategorySelected(self)
    }

}
