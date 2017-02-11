//
//  moreInfoViewController.swift
//  Khoobad
//
//  Created by Mehrshad Jalilmasir on 7/13/16.
//  Copyright © 2016 Mehrshad Jalilmasir. All rights reserved.
//

import UIKit
import MapKit

var bizForfix_reportID:HomeBiz!

class moreInfoViewController: UIViewController {

    var Biz:HomeBiz!
    @IBOutlet var mapView: MKMapView!
    
    @IBOutlet var phone: UIButton!
    @IBOutlet var phoneText: UIButton!
    
    @IBOutlet var address: UILabel!
    
    @IBOutlet var isMyBizBtn: UIButton!
    @IBOutlet var editBiz: UIButton!
    
    @IBOutlet var desc: UILabel!
    
    @IBOutlet var sLogan: UILabel!
    
    @IBOutlet var tellBackground: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        editBiz.layer.cornerRadius = 3.5
        isMyBizBtn.layer.cornerRadius = 3.5
        editBiz.layer.masksToBounds = true
        isMyBizBtn.layer.masksToBounds = true
        editBiz.titleLabel?.font = UIFont(name: "B Yekan" , size: 12.0)
        isMyBizBtn.titleLabel?.font = UIFont(name: "B Yekan" , size: 10.0)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(moreInfoViewController.popToRoot), name: "popToRoot", object: nil)
        
        Biz = selectedBiz
        self.address.text = Biz.address
        self.phoneText.setTitle(selectedBiz.phone, forState: UIControlState.Normal)
        self.desc.text = Biz.desc
        self.sLogan.text = Biz.slogan
        
        title = Biz.name
        
        if Biz.desc == "" {
            
            desc.text = "-"
        }
        
        if Biz.slogan == "" {
            
            sLogan.text = "-"
        }
        
        if Biz.phone == "" {
            
            self.phone.setTitle("-", forState: UIControlState.Normal)
        }
        
        self.tellBackground.layer.backgroundColor = UIColor.whiteColor().CGColor
        self.tellBackground.layer.cornerRadius = 5.0
        self.tellBackground.layer.masksToBounds = false
        self.tellBackground.layer.borderWidth = 1
        self.tellBackground.layer.borderColor = UIColor(red: 144/255, green: 220/255, blue: 90/255, alpha: 1).CGColor
        
        if let font = UIFont(name: "B Yekan", size: 15) {
            
            self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName :font , NSForegroundColorAttributeName: UIColor.whiteColor()]
        }
        navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.Plain, target:nil, action:nil)
        pinOnMap()
    }

    /*@IBAction func back(sender: AnyObject) {
        
        print("here")
        parentViewController?.dismissViewControllerAnimated(true, completion: {})
    }*/
    @IBAction func call(sender: AnyObject) {
        
        if Biz.phone != "" {
            
            if let url = NSURL(string: "tel://\(self.Biz.phone)") {
                
                print("call")
                UIApplication.sharedApplication().openURL(url)
            }
        }
    }
    @IBAction func call1(sender: AnyObject) {
        
        if Biz.phone != "" {
            
            if let url = NSURL(string: "tel://\(self.Biz.phone)") {
                
                print("call")
                UIApplication.sharedApplication().openURL(url)
            }
        }
    }
    
    @IBAction func special(sender: AnyObject) {//edit biz request
        
        /*let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let content = storyboard.instantiateViewControllerWithIdentifier("fix_report")
        
        let partialModal: EMPartialModalViewController = EMPartialModalViewController(rootViewController: content ,contentHeight: UIScreen.mainScreen().bounds.height - 200)
        bizForfix_reportID = self.Biz
        self.presentViewController(partialModal, animated: true)
        {
            print("presenting view controller - done")
        }*/
        bizForfix_reportID = self.Biz
        performSegueWithIdentifier("editInfo", sender: self)
    }
    
    @IBAction func isMyBiz(sender: AnyObject) {
        
        if !user.isLogin {
            
            dispatch_async(dispatch_get_main_queue(), {
                
                user.login()
            })
        }
        else
        {
            performSegueWithIdentifier("showOwn", sender: self)
        }
    }
    
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.redColor()
        renderer.lineWidth = 4.0
        
        return renderer
    }
    func pinOnMap()
    {
        var annotationView:MKPinAnnotationView!
        
        let destinationLocation = CLLocationCoordinate2D(latitude: Double(self.Biz.lat)!, longitude: Double(self.Biz.long)!)
        let destinationPlacemark = MKPlacemark(coordinate: destinationLocation, addressDictionary: nil)
        
        
        let destinationAnnotation = MKPointAnnotation()
        destinationAnnotation.title = "موقعیت کسب و کار"
        
        if let location = destinationPlacemark.location {
            destinationAnnotation.coordinate = location.coordinate
        }
        
        self.mapView.removeAnnotation(destinationAnnotation)
        self.mapView.showAnnotations([destinationAnnotation], animated: true )
        
        annotationView = MKPinAnnotationView(annotation: destinationAnnotation, reuseIdentifier: "pin")
        
        mapView.addAnnotation(annotationView.annotation!)
    }
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView?{
        
        if (annotation is MKUserLocation) {
            
            return nil
        }
        
        var v = mapView.dequeueReusableAnnotationViewWithIdentifier("pin")
        if v == nil {
            v = MKAnnotationView(annotation: annotation, reuseIdentifier: "pin")
            v!.canShowCallout = true
        }
        else {
            v!.annotation = annotation
        }
        
        v!.image = UIImage(named: "main_placeholder")
        return v
    }
    @IBAction func directMeToBiz(sender: AnyObject) {
        
        if (UIApplication.sharedApplication().canOpenURL(NSURL(string:"comgooglemaps://")!)) {
            
            UIApplication.sharedApplication().openURL(NSURL(string:
                "comgooglemaps://?saddr=\(user.lat),\(user.long)&daddr=\(Biz.lat),\(Biz.long)&directionsmode=driving")!)
            
        } else {
            NSLog("Can't use comgooglemaps://")
            UIApplication.sharedApplication().openURL(NSURL(string:
                "http://maps.google.com/maps?f=d&saddr=\(user.lat),\(user.long)&daddr=\(Biz.lat),\(Biz.long)&sspn=0.2,0.1&nav=1")!)
        }
    }
    func popToRoot()
    {
        parentViewController?.dismissViewControllerAnimated(true, completion: {})//back to previous
    }
}
