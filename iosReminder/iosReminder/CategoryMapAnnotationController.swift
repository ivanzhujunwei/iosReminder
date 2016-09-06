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
    var categoryList: [Category]?
    let locationManager = CLLocationManager()
    let geocoder = CLGeocoder()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
        // Do any additional setup after loading the view.
    }
    
    func fetchData(){
        let fetch = NSFetchRequest(entityName: "Category")
        do{
            let fetchResults = try managedObjectContext!.executeFetchRequest(fetch) as! [Category]
            categoryList = fetchResults
        }catch{
            fatalError("Failed to fetch category information: \(error)")
        }
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
        //        self.mapView.setRegion(region, animated: true)
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
