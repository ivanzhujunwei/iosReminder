//
//  CategoryAddViewController.swift
//  iosReminder
//
//  Created by zjw on 30/08/2016.
//  Copyright © 2016 FIT5140. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import CoreData

class CategoryAddViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet var categoryName: UITextField!
    @IBOutlet var categoryColor: UISegmentedControl!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet var locationText: UITextField!
    
    var managedObjectContext : NSManagedObjectContext?
    var categoryToAdd : Category?
    
    let locationManager = CLLocationManager()
    let geocoder = CLGeocoder()
    
    @IBAction func addCategory(sender: AnyObject) {
//        let newCategory = NSEntityDescription.insertNewObjectForEntityForName("Category", inManagedObjectContext: managedObjectContext!) as! Category
//        newCategory.title = categoryName.text
        // more later
        // ...
        self.navigationController?.popViewControllerAnimated(true)
        
    }
    
    @IBAction func searchLocation(sender: AnyObject) {
        if let location = locationText.text where !location.isEmpty{
            geocoder.geocodeAddressString(location, completionHandler: { (placemarks, error) in
                if error != nil {
                    // Handle potential errors
                    if (error?.code == 8) {
                        // No result found with geocode request
                        // Show alert to user
                        self.showAlertWithDismiss("No result found", message: "Unable to provide a location for your search request.")
                    } else {
                        // Other error, print to console
                        print(error?.localizedDescription)
                    }
                }
                // Get the first location result and add to map
                if let placemark = placemarks?.first {
                    // Remove existing annotations (if any) from map view
                    self.mapView.removeAnnotations(self.mapView.annotations)
                    // Place new annotation and center camera on location
                    self.mapView.addAnnotation(MKPlacemark(placemark: placemark))
                    self.mapView.centerCoordinate = (placemark.location?.coordinate)!
                }
            })

        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Setup delegation so we can respond to MapView and LocationManager events
        mapView.delegate = self
        // The delegate object to receive update events
        self.locationManager.delegate   = self
        // There are several accuracy:
        // kCLLocationAccuracyBestForNavigation
        // kCLLocationAccuracyBest
        // kCLLocationAccuracyNearestTenMeters
        // kCLLocationAccuracyHundredMeters
        // kCLLocationAccuracyKilometer
        // kCLLocationAccuracyThreeKilometers
        self.locationManager.desiredAccuracy =  kCLLocationAccuracyBest
        // Ask user for permission to use location
        // Uses description from NSLocationAlwaysUsageDescription in Info.plist
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.startUpdatingLocation()
        self.mapView.showsUserLocation = true
        // the added category
        categoryToAdd = NSEntityDescription.insertNewObjectForEntityForName("Category", inManagedObjectContext: managedObjectContext!) as? Category
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
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
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // Helper function to produce an alert for the user
    func showAlertWithDismiss(title:String, message:String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let alertDismissAction = UIAlertAction(title: "Dismiss", style: .Default, handler: nil)
        alertController.addAction(alertDismissAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
}
