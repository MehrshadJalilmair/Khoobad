//
//  MapViewController.swift
//  Khoobad
//
//  Created by Mehrshad Jalilmasir on 6/24/16.
//  Copyright © 2016 Mehrshad Jalilmasir. All rights reserved.
//

import UIKit
import MapKit


class MapViewController: UIViewController {

    //Mark : Just Vars    
    var Biz:HomeBiz!
    
    @IBOutlet weak var MapView: MKMapView!
    //Mark : loading
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MapViewController.popToRoot), name: "popToRoot", object: nil)
        pinOnMap()
    }
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.redColor()
        renderer.lineWidth = 4.0
        
        return renderer
    }
    func pinOnMap()
    {
        //var annotationView:MKPinAnnotationView!
        var annotationView1:MKPinAnnotationView!
        
        let sourceLocation = CLLocationCoordinate2D(latitude: user.lat, longitude: user.long)
        let destinationLocation = CLLocationCoordinate2D(latitude: Double(self.Biz.lat)!, longitude: Double(self.Biz.long)!)
        
        let sourcePlacemark = MKPlacemark(coordinate: sourceLocation, addressDictionary: nil)
        let destinationPlacemark = MKPlacemark(coordinate: destinationLocation, addressDictionary: nil)
        
        let sourceAnnotation = MKPointAnnotation()
        sourceAnnotation.title = "مکان من"
        
        if let location = sourcePlacemark.location {
            sourceAnnotation.coordinate = location.coordinate
        }
        
        let destinationAnnotation = MKPointAnnotation()
        destinationAnnotation.title = "موقعیت کسب و کار"
        
        if let location = destinationPlacemark.location {
            destinationAnnotation.coordinate = location.coordinate
        }
        
        self.MapView.removeAnnotation(destinationAnnotation)
        
        //annotationView = MKPinAnnotationView(annotation: sourceAnnotation, reuseIdentifier: "pin")
        annotationView1 = MKPinAnnotationView(annotation: destinationAnnotation, reuseIdentifier: "pin")
        
        //MapView.addAnnotation(annotationView.annotation!)
        MapView.addAnnotation(annotationView1.annotation!)
        
        self.MapView.showAnnotations([destinationAnnotation], animated: true )
        
        /*var points: [CLLocationCoordinate2D]
        points = [sourceLocation , destinationLocation]
        
        let geodesic = MKGeodesicPolyline(coordinates: &points[0], count: 2)
        self.MapView.addOverlay(geodesic)
        
        UIView.animateWithDuration(1.5, animations: { () -> Void in
            let span = MKCoordinateSpanMake(0.01, 0.01)
            let region1 = MKCoordinateRegion(center: sourceLocation, span: span)
            self.MapView.setRegion(region1, animated: true)
        })*/
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
