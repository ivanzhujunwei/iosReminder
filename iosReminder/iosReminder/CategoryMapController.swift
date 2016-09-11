//
//  CategoryMapController.swift
//  iosReminder
//
//  Created by zjw on 3/09/2016.
//  Copyright © 2016 FIT5140. All rights reserved.
//

import UIKit
import MapKit

// Search a location delegate
protocol SetLocationDelegate{
    func setLocation(locationName:String,longitude:Double,latitude:Double)
}

//  This viewController displays a map and searchBar for user to search a location for a category
class CategoryMapController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet var searchBar: UISearchBar!
    
    // Record the location which is edied or added
    var location :CLLocationCoordinate2D?
    let locationManager = CLLocationManager()
    let geocoder = CLGeocoder()
    var setLocationDelegate: SetLocationDelegate?
    
    // When user searches a location
    func searchBarSearchButtonClicked(searchBar: UISearchBar){
        searchBar.resignFirstResponder()
        if let location = searchBar.text where !location.isEmpty{
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
                    let coord = placemark.location?.coordinate
                    self.mapView.centerCoordinate = (coord)!
                    // set location information to previous controller
                    self.setLocationDelegate?.setLocation(searchBar.text!, longitude: (coord?.longitude)!, latitude: (coord?.latitude)!)
                }
            })
        }
    }
    
    
    @IBOutlet var mapView: MKMapView!
    
    @IBAction func addLocation(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mapView.delegate = self
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
        // start update location, without the statement, the map won't zoom in
        self.locationManager.startUpdatingLocation()
        self.mapView.showsUserLocation = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        var center = CLLocationCoordinate2D()
        // If the location is nil which means user is adding a new location for the category
        if (location == nil){
            // reference: www.youtube.com/watch?v=qrdIL44T6FQ
            let location = locations.last
            // CLLocationCoordinate2D: A structure that contains a geographical coordinate
            center = CLLocationCoordinate2D(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
        }else{
            // If the location is not nil, then add an annotation for the category's location
            center = self.location!
            // Add marker for each location
            let mapAnnotation = CategoryAnnotation()
            mapAnnotation.setCoordinate(center)
            mapView.addAnnotation(mapAnnotation)
        }
        // MKCoordinateRegion: A structure that defines which portion of the map to display
        // MKCoordinateSpan: A structure that defines the area spanned by a map region
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta:0.2,longitudeDelta:0.2))
        self.mapView.setRegion(region, animated: true)
        self.locationManager.stopUpdatingLocation()
    }

    // Helper function to produce an alert for the user
    func showAlertWithDismiss(title:String, message:String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let alertDismissAction = UIAlertAction(title: "Dismiss", style: .Default, handler: nil)
        alertController.addAction(alertDismissAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }


}
