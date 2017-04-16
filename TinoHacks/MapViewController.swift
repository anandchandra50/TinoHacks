//
//  MapViewController.swift
//  TinoHacks
//
//  Created by Anand Chandra and Michael Wu on 4/15/17.
//  Copyright © 2017 AnandChandraMichaelWu. All rights reserved.
//
import UIKit
import CoreLocation
import MapKit

class MapViewController: UIViewController, CLLocationManagerDelegate{
    
    var longitude: Double?
    var latitude: Double?
    
    let manager = CLLocationManager()
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        
        // Do any additional setup after loading the view.
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
        
        let spanSize = sqrt(pow((location.coordinate.latitude - latitude!), 2) + pow((location.coordinate.longitude - longitude!), 2))
        let span = MKCoordinateSpanMake(spanSize, spanSize)
        let myLocation = CLLocationCoordinate2DMake((location.coordinate.latitude + latitude!) / 2, (location.coordinate.longitude + longitude!) / 2)
        
        let region = MKCoordinateRegionMake(myLocation, span)
        
        mapView.setRegion(region, animated: true)
        
        let myPin = MKPointAnnotation()
        myPin.coordinate = CLLocationCoordinate2DMake(latitude!, longitude!)
        myPin.title = "Restaurant"
        
        self.mapView.showsUserLocation = true
        mapView.addAnnotation(myPin)
        
        manager.stopUpdatingLocation()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
