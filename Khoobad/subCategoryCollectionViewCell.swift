//
//  subCategoryCollectionViewCell.swift
//  Khoobad
//
//  Created by Mehrshad Jalilmasir on 7/3/16.
//  Copyright © 2016 Mehrshad Jalilmasir. All rights reserved.
//

import UIKit


class subCategoryCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var subCategoryBtn: CircleButtonInSearch!
    
    @IBOutlet weak var subCategoryName: UILabel!
    
    var subCategory:category!
        {
        didSet{
        
        updateUI()
        }
    }
    
    func updateUI()
    {
        let image : UIImage = self.resizeImageWithAspect(UIImage(named: "\(self.subCategory.id).png")!,scaledToMaxWidth: 24.0, maxHeight: 24.0)
        subCategoryBtn.setImage(image , forState: UIControlState.Normal)

        subCategoryName.text = self.subCategory.name
    }
    
    @IBAction func subCategorySelected(sender: AnyObject) {
        
        print("goto?")
        selectedSubCategoryName = self.subCategory.name
        selectedCategoryID = self.subCategory.id
        print("\(selectedCategoryID)")
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

}
