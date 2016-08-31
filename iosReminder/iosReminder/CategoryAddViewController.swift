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

class CategoryAddViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet var categoryName: UITextField!
    @IBOutlet var categoryColor: UISegmentedControl!
    @IBOutlet weak var mapView: MKMapView!
    
    let locationManager = CLLocationManager()
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

}
