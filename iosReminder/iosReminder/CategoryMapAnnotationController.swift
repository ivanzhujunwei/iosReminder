//
//  CategoryMapAnnotationController.swift
//  iosReminder
//
//  Created by zjw on 6/09/2016.
//  Copyright © 2016 FIT5140. All rights reserved.
//

import UIKit
import CoreData
import MapKit

class CategoryMapAnnotationController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet var mapView: MKMapView!
    
    var managedObjectContext: NSManagedObjectContext?
    // get values from first tab controller
    var categoryList: [Category]?
    var geoFenceCollection: NSMutableArray?
    
    let locationManager = CLLocationManager()
    let geocoder = CLGeocoder()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // MapsDemo
        // Setup delegation so we can respond to MapView and LocationManager events
        mapView.delegate = self
        locationManager.delegate = self
        // Ask user for permission to use location
        // Uses description from NSLocationAlwaysUsageDescription in Info.plist
        locationManager.requestAlwaysAuthorization()
        // when I put the code here, the categoryViewController is nil
//        let categoryViewController = self.tabBarController!.viewControllers![0] as? CategoryViewController
//        self.categoryList = categoryViewController!.categoryList
//        addAnnotations()
    }
    
    func addAnnotations(){
        // remove previous annotations before add annotations
        mapView.removeAnnotations(self.mapView.annotations)
        for cate in categoryList!{
            // if the location information is not null
            if (cate.latitude != nil && cate.longitude != nil){
                let latitude = Double(cate.latitude!)
                let longitutde = Double(cate.longitude!)
                let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitutde)
                // MapsDemo
                // Add marker for each location
                let mapAnnotation = CategoryAnnotation()
                mapAnnotation.setCoordinate(coordinate)
//                mapAnnotation.coordinate = coordinate
                mapAnnotation.title = cate.getAnnotationPopupTitle()
                mapAnnotation.catgory = cate
//                mapAnnotation.
                mapView.addAnnotation(mapAnnotation)
                // add circle for each annotation
                let circle = MKCircle(centerCoordinate: coordinate, radius: Double(cate.radius!))
                self.mapView.setRegion(MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)), animated: true)
                mapView.addOverlay(circle)
            }
        }
    }
    
    // reference: stackoverflow.com/questions/33053832/swift-perform-segue-from-map-annotation
    // Called when the annotation was added
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView?.animatesDrop = true
            pinView?.canShowCallout = true
            let rightButton: AnyObject! = UIButton(type: UIButtonType.DetailDisclosure)
            pinView?.rightCalloutAccessoryView = rightButton as? UIView
        }
        else {
            pinView?.annotation = annotation
        }
        
        return pinView
    }
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
//            let categoryAnnotation = view.annotation as! CategoryAnnotation
            performSegueWithIdentifier("showCategoryFromMapSegue", sender: self)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showCategoryFromMapSegue" {
            let detailCategory = segue.destinationViewController as! CategoryAddTableController
            let ann = self.mapView.selectedAnnotations[0] as! CategoryAnnotation
//            theDestination.getName = (sender as! MKAnnotationView).annotation!.title!
            detailCategory.managedObjectContext = self.managedObjectContext
//            let ann = (sender as! MKAnnotationView).annotation as! CategoryAnnotation
            detailCategory.category = ann.catgory
        }
    }
    
    // reference: sweettutos.com/2015/12/06/swift-mapkit-tutorial-series-how-to-make-a-map-based-overlays/
    // Each time an overlay is added to the map, the delegate will create a renderer object to use when drawing the specified overlay.
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        let circleRenderer = MKCircleRenderer(overlay: overlay)
        // Constructing a circle overlay filled with a blue color
        circleRenderer.fillColor = UIColor.blueColor().colorWithAlphaComponent(0.1)
        circleRenderer.strokeColor = UIColor.blueColor()
        circleRenderer.lineWidth = 1
        // return the overlay renderer of the MKCircle object defined earlier.
        return circleRenderer
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        addAnnotations()
    }
   /*
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // reference: www.youtube.com/watch?v=qrdIL44T6FQ
        let location = locations.last
        // CLLocationCoordinate2D: A structure that contains a geographical coordinate
        let center = CLLocationCoordinate2D(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
        // MKCoordinateRegion: A structure that defines which portion of the map to display
        // MKCoordinateSpan: A structure that defines the area spanned by a map region
        // Q: why when the latitudeDelta becomes bigger, the zoom level becomes low?
        // Q: can't look for current location for simulator?
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta:0.2,longitudeDelta:0.2))
        self.mapView.setRegion(region, animated: true)
        self.locationManager.stopUpdatingLocation()
    }*/
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
