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

//  This is a map category viewController, each annotation in map represents a category, users can click an annotation to view the category information.
class CategoryMapAnnotationController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet var mapView: MKMapView!
    
    var managedObjectContext: NSManagedObjectContext?
    
    // The categoryList from CategoryViewController stored in Core Data
    var categoryList: [Category]?
    
    let locationManager = CLLocationManager()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        // Add notificatioin for updating monitoring regions
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(updateMonitoredRegions), name: "updateMonitoredRegionsNotifyId", object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // MapsDemo
        // Setup delegation so we can respond to MapView and LocationManager events
        mapView.delegate = self
        // Ask user for permission to use location
        // Uses description from NSLocationAlwaysUsageDescription in Info.plist
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        self.mapView.showsUserLocation = true
    }
    
    // Update monitored regions
    // Here is the situations when monitored regions need to be updated
    // #1 Add/update/delete a category
    // #2 Add/update/delete a reminder
    func updateMonitoredRegions(){
        self.locationManager.startUpdatingLocation()
        clearMonitoredRegions()
        startMonitorCategoryRegions()
    }
    
    // Clear monitored regions
    func clearMonitoredRegions(){
        for region in locationManager.monitoredRegions {
            locationManager.stopMonitoringForRegion(region)
        }
    }
    
    // Start monitored regions for categories
    func startMonitorCategoryRegions(){
        for cate in categoryList!{
            // If the notification of this category is toggle on, then when user enter or exit region, a alert / notification will be sent
            if Bool(cate.toogle!) && (cate.getInCompleteReminderCount() > 0) {
                let coordinate = cate.getCoordinate()
                let geofence = CLCircularRegion(center: coordinate, radius: cate.getRadius(), identifier: cate.generateNotifyMessage())
                // Notify when arrive
                if cate.notifyByArriveOrLeave == 0 {
                    geofence.notifyOnEntry = true
                    geofence.notifyOnExit = false
                }
                // Notify when leave
                else{
                    geofence.notifyOnEntry = false
                    geofence.notifyOnExit = true
                }
                locationManager.startMonitoringForRegion(geofence)
            }
        }
    }
    
    // Add annotations on map
    func addAnnotations(){
        // Remove previous annotations before add annotations
        mapView.removeAnnotations(self.mapView.annotations)
        // Remove previous radius circles
        mapView.removeOverlays(self.mapView.overlays)
        
        for cate in categoryList!{
            // if the location information is not nil
            if (cate.latitude != nil && cate.longitude != nil){
                let coordinate = cate.getCoordinate()
                // add marker for each location
                let mapAnnotation = CategoryAnnotation()
                mapAnnotation.assembleCategoryInfo(cate)
                mapView.addAnnotation(mapAnnotation)
                // add circle for each annotation
                let circle = MKCircle(centerCoordinate: coordinate, radius: cate.getRadius())
                self.mapView.setRegion(MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)), animated: true)
                mapView.addOverlay(circle)
            }
        }
    }
    
    // MARK: CLLocationManagerDelegate
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        // Only show user location in MapView if user has authorized location tracking
        mapView.showsUserLocation = (status == .AuthorizedAlways)
    }
    
    func mapView(mapView: MKMapView, didUpdateUserLocation userLocation: MKUserLocation) {
        // Zoom to new user location when updated
        var mapRegion = MKCoordinateRegion()
        mapRegion.center = mapView.userLocation.coordinate
        mapRegion.span = mapView.region.span; // Use current 'zoom'
        mapView.setRegion(mapRegion, animated: true)
    }
    
    func locationManager(manager: CLLocationManager, didEnterRegion region: CLRegion) {
        // Notify the user when they have entered a region
        let title = "Arrived at Category Map"
        enterOrExitMessage(title, region: region)
    }
    
    func locationManager(manager: CLLocationManager, didExitRegion region: CLRegion) {
        // Notify the user when they have leaved a region
        let title = "Exited from Category Map"
        enterOrExitMessage(title, region: region)
        
    }
    
    // Generate an alert/notification message when arriving/leaving a region
    func enterOrExitMessage(title: String, region: CLRegion){
        if UIApplication.sharedApplication().applicationState == .Active {
            // App is active, show an alert
            let alertController = UIAlertController(title: title, message: region.identifier, preferredStyle: .Alert)
            let alertAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alertController.addAction(alertAction)
            self.presentViewController(alertController, animated: true, completion: nil)
        } else {
            // App is inactive, show a notification
            let notification = UILocalNotification()
            notification.alertTitle = title
            notification.alertBody = region.identifier
            UIApplication.sharedApplication().presentLocalNotificationNow(notification)
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
            // If YES, a standard callout bubble will be shown when the annotation is selected.
            // The annotation must have a title for the callout to be shown.
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
        // When the annotaion is tapped, then perform the segue
        if control == view.rightCalloutAccessoryView {
            performSegueWithIdentifier("showReminderListFromMapSegue", sender: self)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // When tap the annotation, ReminderListController will display
        if segue.identifier == "showReminderListFromMapSegue" {
            let reminderListController = segue.destinationViewController as! ReminderListController
            let ann = self.mapView.selectedAnnotations[0] as! CategoryAnnotation
            reminderListController.managedObjectContext = self.managedObjectContext
            reminderListController.categoryToView = ann.catgory
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
}
