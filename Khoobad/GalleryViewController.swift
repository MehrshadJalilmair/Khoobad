//
//  GalleryViewController.swift
//  Khoobad
//
//  Created by Mehrshad Jalilmasir on 6/26/16.
//  Copyright © 2016 Mehrshad Jalilmasir. All rights reserved.
//

import UIKit

class GalleryViewController: UIViewController {

    var Biz:HomeBiz!
    
    let detailTransitioningDelegate: PresentationManager = PresentationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(GalleryViewController.popToRoot), name: "popToRoot", object: nil)
    }
    
    //MARK : Table View Impls
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return Biz.imageURLS.count
    }
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int
    {
        return 1
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("ImageCell", forIndexPath: indexPath) as! ImageCollectionViewCell
        
        let _url1 =  NSURL(string : String.localizedStringWithFormat(URLS.Imagess , Biz.imageURLS[indexPath.row]))
        
        
        cell.url = _url1
        
        return cell
    }
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath)
    {
        print(indexPath.row)
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("fullImage") as! fullImageViewController
        vc._image = NSURL(string : String.localizedStringWithFormat(URLS.Imagess , Biz.imageURLS[indexPath.row]))!
        vc.transitioningDelegate = detailTransitioningDelegate
        vc.modalPresentationStyle = .Custom
        presentViewController(vc, animated: true, completion:nil)
    }
    func popToRoot()
    {
        parentViewController?.dismissViewControllerAnimated(true, completion: {})//back to previous
    }
}
