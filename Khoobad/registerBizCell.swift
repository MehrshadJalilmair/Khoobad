//
//  registerBizCell.swift
//  Khoobad
//
//  Created by Mehrshad Jalilmasir on 7/18/16.
//  Copyright © 2016 Mehrshad Jalilmasir. All rights reserved.
//

import UIKit
import MapKit

class registerBizCell: UITableViewCell , UITextViewDelegate , MKMapViewDelegate{

    @IBOutlet var name: UITextField!
    
    @IBOutlet var phone: UITextField!
    
    @IBOutlet var website: UITextField!
    
    @IBOutlet var desc: UITextView!
    
    @IBOutlet var address: UITextField!
    
    @IBOutlet var mapView: MKMapView!
    
    @IBOutlet var off: UISwitch!
    
    var annotation = MKPointAnnotation()
    
    @IBOutlet var catName: UILabel!
    
    
    var set:Bool!
    {
        didSet
        {
            updateUI()
        }
    }
    
    func updateUI()
    {
        desc.layer.cornerRadius = 5.0
        desc.layer.masksToBounds = false
        desc.layer.shadowColor = UIColor.blackColor().colorWithAlphaComponent(0.5).CGColor
        desc.layer.shadowOffset = CGSize(width: 0, height: 0)
        desc.layer.shadowOpacity = 0.8
        desc.textColor = UIColor.lightGrayColor()
        
        //desc.becomeFirstResponder()
        desc.selectedTextRange = desc.textRangeFromPosition(desc.beginningOfDocument, toPosition: desc.beginningOfDocument)
        
        desc.text = "توضیحات"
        
        desc.textAlignment = .Center
        desc.delegate = self

        
        if registerbiz.name != "" {
            
            name.text = registerbiz.name
        }
        if registerbiz.desc != "" {
            
            desc.text = registerbiz.desc
        }
        if registerbiz.address != "" {
            
            address.text = registerbiz.address
        }
        if registerbiz.phone != "" {
            
            phone.text = registerbiz.phone
        }
        if registerbiz.website != "" {
            
            website.text = registerbiz.website
        }
        
        if registerbiz.off == "0" {
            
            
        }
        else
        {
            off.selected = true
            off.setOn(true, animated: true)
        }
        
        if registerbiz.lat != 0.0 || registerbiz.long != 0{
            
            setPin()
        }
        
        //catName.text = registerbiz.cat_name
        var selectedCategories = ""
        
        for object in registerbiz.categories {
            
            selectedCategories = selectedCategories + object.1.cat_name + ","
        }
        
        catName.text = selectedCategories
        if registerbiz.categories.count > 1 {
            
            catName.font = UIFont(name: "B Yekan", size: 10.0)
        }
        
        let uilgr = UILongPressGestureRecognizer(target: self, action: #selector(registerBizCell.addAnnotation(_:)))
        uilgr.minimumPressDuration = 2.0
        
        self.mapView.addGestureRecognizer(uilgr)
        regoin()
    }
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool{
        
        // Combine the textView text and the replacement text to
        // create the updated text string
        let currentText:NSString = desc.text
        let updatedText = currentText.stringByReplacingCharactersInRange(range, withString:text)
        
        // If updated text view will be empty, add the placeholder
        // and set the cursor to the beginning of the text view
        if updatedText.isEmpty {
            
            desc.text = "توضیحات"
            desc.textColor = UIColor.lightGrayColor()
            
            desc.selectedTextRange = desc.textRangeFromPosition(desc.beginningOfDocument, toPosition: desc.beginningOfDocument)
            desc.font = UIFont(name: "B Yekan", size: 10.0)
            return false
        }
            
            // Else if the text view's placeholder is showing and the
            // length of the replacement string is greater than 0, clear
            // the text view and set its color to black to prepare for
            // the user's entry
        else if desc.textColor == UIColor.lightGrayColor() && !text.isEmpty {
            desc.text = nil
            desc.textColor = UIColor.blackColor()
            desc.font = UIFont(name: "B Yekan", size: 14.0)
        }
        
        return true
    }

    func setPin()
    {
        let sourceLocation = CLLocationCoordinate2D(latitude: registerbiz.lat, longitude: registerbiz.long)
        let sourcePlacemark = MKPlacemark(coordinate: sourceLocation, addressDictionary: nil)
        
        let sourceAnnotation = CustomPointAnnotation()
        
        sourceAnnotation.title = "مکان کسب و کار"
        
        if let location = sourcePlacemark.location {
            sourceAnnotation.coordinate = location.coordinate
        }
        
        var annotationView:MKPinAnnotationView!
        annotationView = MKPinAnnotationView(annotation: sourceAnnotation, reuseIdentifier: "pin")
        self.mapView.addAnnotation(annotationView.annotation!)
        
        self.mapView.showAnnotations([sourceAnnotation] , animated: true)
        
        self.annotation = sourceAnnotation
    }
    func regoin()
    {
        let center = CLLocationCoordinate2D(latitude: user.lat, longitude: user.long)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
        self.mapView.setRegion(region, animated: true)
    }
    func addAnnotation(gestureRecognizer:UIGestureRecognizer){
        
        if gestureRecognizer.state == UIGestureRecognizerState.Began {
            
            self.mapView.removeAnnotation(annotation)
            
            let touchPoint = gestureRecognizer.locationInView(self.mapView)
            let newCoordinates = self.mapView.convertPoint(touchPoint, toCoordinateFromView: self.mapView)

            let sourceLocation = CLLocationCoordinate2D(latitude: newCoordinates.latitude, longitude: newCoordinates.longitude)
            let sourcePlacemark = MKPlacemark(coordinate: sourceLocation, addressDictionary: nil)
            
            let sourceAnnotation = CustomPointAnnotation()
            
            sourceAnnotation.title = "مکان کسب و کار"
            
            if let location = sourcePlacemark.location {
                sourceAnnotation.coordinate = location.coordinate
            }
            
            var annotationView:MKPinAnnotationView!
            annotationView = MKPinAnnotationView(annotation: sourceAnnotation, reuseIdentifier: "pin")
            self.mapView.addAnnotation(annotationView.annotation!)
            
            self.mapView.showAnnotations([sourceAnnotation] , animated: true)
            
            self.annotation = sourceAnnotation
            
            registerbiz.lat = sourceLocation.latitude
            registerbiz.long = sourceLocation.longitude
        }
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
        
        v!.image = UIImage(named: "main_placeholder.png")
        return v
    }
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.redColor()
        renderer.lineWidth = 4.0
        
        return renderer
    }
    
    @IBAction func selectCategoty(sender: AnyObject) {
        
        print("ok")
    }
    
    @IBAction func nameChangeed(sender: UITextField) {
        
        print("ok")
        registerbiz.name = sender.text!
    }
    @IBAction func phoneChangeed(sender: UITextField) {
        print("ok")
        registerbiz.phone = sender.text!
    }
    @IBAction func websiteChangeed(sender: UITextField) {
        print("ok")
        registerbiz.website = sender.text!
    }
    @IBAction func descChangeed(sender: UITextField) {
        print("ok")
        registerbiz.desc = sender.text!
    }
    @IBAction func addressChangeed(sender: UITextField) {
        print("ok")
        registerbiz.address = sender.text!
    }
    @IBAction func offChanged(sender: AnyObject) {
        print("ok")
        if off.on {
            
            registerbiz.off = "1"
        }
        else
        {
            registerbiz.off = "0"
        }
        
        print(off.on)
    }
}
