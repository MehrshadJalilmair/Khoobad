//
//  categorySearchViewController.swift
//  Khoobad
//
//  Created by Mehrshad Jalilmasir on 7/2/16.
//  Copyright © 2016 Mehrshad Jalilmasir. All rights reserved.
//

import UIKit

class categorySearchViewController: UIViewController , showSubs{
    
    //MARK : Just Vars
    @IBOutlet weak var categoryCollView: UICollectionView!
    
    //MARK : Loading
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(categorySearchViewController.reloadCategoryList), name: "reloadCategoryList", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(categorySearchViewController.popToRoot), name: "popToRoot", object: nil)
        navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.Plain, target:nil, action:nil)
        if let font = UIFont(name: "B Yekan", size: 15) {
            
            self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName :font , NSForegroundColorAttributeName: UIColor.whiteColor()]
        }
        
        categoryCollView.showsVerticalScrollIndicator = false
        categoryCollView.showsHorizontalScrollIndicator = false
    }
    func popToRoot()
    {
        self.navigationController?.popToRootViewControllerAnimated(true)//back to previous
    }
    
    //MARK : Coll View Impls
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return categories.count
    }
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int
    {
        return 1
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("categoryCell", forIndexPath: indexPath) as! categoryCollectionViewCell
        
        cell.Category = categories[indexPath.row]
        cell.delegate = self
        return cell
    }
    
    func categorySelected(cell: categoryCollectionViewCell) {
        
        SelectedSubCategories = [category]()
        for sub in subCategories {
            
            if (Int((sub.parent_id as? String)!)! == (cell.Category.id)) {
                
                SelectedSubCategories.append(sub)
            }
        }
        let allCase = category(id: cell.Category.id, name: "همه موارد" , desc: "", parent_id: -1)
        SelectedSubCategories.append(allCase)
        print("gotoSubs")
        //performSegueWithIdentifier("showSubs", sender: self)
    }
    
    func reloadCategoryList()
    {
        categoryCollView.reloadData()
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        self.view.endEditing(true)
    }
}
