//
//  subCategoriesViewController.swift
//  Khoobad
//
//  Created by Mehrshad Jalilmasir on 7/3/16.
//  Copyright © 2016 Mehrshad Jalilmasir. All rights reserved.
//

import UIKit

class subCategoriesViewController: UIViewController {

    @IBOutlet weak var subCategoryCollView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(subCategoriesViewController.popToRoot), name: "popToRoot", object: nil)
        navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.Plain, target:nil, action:nil)
        self.title = "\(selectedCategoryName)"
        //self.navigationController!.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "CaviarDreams", size: 14)!]
        if let font = UIFont(name: "B Yekan", size: 15) {
            
            self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName :font , NSForegroundColorAttributeName: UIColor.whiteColor()]
        }
        
        subCategoryCollView.showsVerticalScrollIndicator = false
        subCategoryCollView.showsHorizontalScrollIndicator = false
    }
    func popToRoot()
    {
        self.navigationController?.popToRootViewControllerAnimated(true)//back to previous
    }
    //MARK : Coll View Impls
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return SelectedSubCategories.count
    }
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int
    {
        return 1
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("subCategoryCell", forIndexPath: indexPath) as! subCategoryCollectionViewCell
        
        cell.subCategory = SelectedSubCategories[indexPath.row]
        return cell
    }    
}
