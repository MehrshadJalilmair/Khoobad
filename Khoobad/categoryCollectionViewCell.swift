//
//  categoryCollectionViewCell.swift
//  Khoobad
//
//  Created by Mehrshad Jalilmasir on 7/3/16.
//  Copyright © 2016 Mehrshad Jalilmasir. All rights reserved.
//

import UIKit

protocol showSubs
{
    func categorySelected(cell:categoryCollectionViewCell)
}

class categoryCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var categoryBtn: CircleButtonInSearch!
    
    @IBOutlet weak var categoryName: UILabel!
    
    var delegate:showSubs!
    
    var Category:category!
    {
        didSet{
        
            updateUI()
        }
    }
    
    func updateUI()
    {
        let image : UIImage = self.resizeImageWithAspect(UIImage(named: "\(self.Category.id).png")!,scaledToMaxWidth: 24.0, maxHeight: 24.0)
        
        categoryBtn.setImage(image , forState: UIControlState.Normal)
        //categoryBtn.setImage(UIImage(named: "\(self.Category.id).png"), forState: UIControlState.Normal)
        categoryName.text = self.Category.name
    }
    
    private func _resizeWithAspect_doResize(image: UIImage,size: CGSize)->UIImage{
        if UIScreen.mainScreen().respondsToSelector(#selector(NSDecimalNumberBehaviors.scale)){
            UIGraphicsBeginImageContextWithOptions(size,false,UIScreen.mainScreen().scale);
        }
        else
        {
            UIGraphicsBeginImageContext(size);
        }
        
        image.drawInRect(CGRectMake(0, 0, size.width, size.height));
        let newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        return newImage;
    }
    
    func resizeImageWithAspect(image: UIImage,scaledToMaxWidth width:CGFloat,maxHeight height :CGFloat)->UIImage
    {
        let oldWidth = image.size.width;
        let oldHeight = image.size.height;
        
        let scaleFactor = (oldWidth > oldHeight) ? width / oldWidth : height / oldHeight;
        
        let newHeight = oldHeight * scaleFactor;
        let newWidth = oldWidth * scaleFactor;
        let newSize = CGSizeMake(newWidth, newHeight);
        
        return self._resizeWithAspect_doResize(image, size: newSize);
    }
    
    @IBAction func categorySelected(sender: AnyObject) {
        
        delegate.categorySelected(self)
        print("gotoSubs")
        selectedCategoryName = self.Category.name
    }
}
