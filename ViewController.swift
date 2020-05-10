//
//  ViewController.swift
//  Memorable Placefs
//
//  Created by Daniela Passos on 5/9/20.
//  Copyright © 2020 Daniela Passos. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation


class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet var mapa: MKMapView!
    
    var manager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let uilpgr = UILongPressGestureRecognizer(target: self, action: #selector(ViewController.longpress(gestureRecognizer:)))
        uilpgr.minimumPressDuration = 2
        mapa.addGestureRecognizer(uilpgr)
        
        
        
        if activePlace == -1 {
            manager.delegate = self
            manager.desiredAccuracy = kCLLocationAccuracyBest
            manager.requestWhenInUseAuthorization()
            manager.startUpdatingLocation()
            
        }
        else {
            if places.count > activePlace {
                if let name = places[activePlace]["name"]{
                    if let lat = places[activePlace]["lat"]{
                        if let lon = places[activePlace]["lon"]{
                            if let latitude = Double (lat){
                                if let longitude = Double (lon){
                                    let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                                    let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                                    let region = MKCoordinateRegion(center: coordinate, span: span)
                                    self.mapa.setRegion(region, animated: true)
                                    
                                    let annotation = MKPointAnnotation()
                                    
                                    annotation.coordinate = coordinate
                                    annotation.title = name
                                    self.mapa.addAnnotation(annotation)
                                    
                                }
                                
                            }
                                
                            }
                        }
                    }
                }
            }
        }
        
    @objc func longpress (gestureRecognizer:UIGestureRecognizer) {
        if gestureRecognizer.state == UIGestureRecognizer.State.began {
            let touchPoint = gestureRecognizer.location(in: self.mapa)
            let newCoordinate = self.mapa.convert(touchPoint, toCoordinateFrom: self.mapa)
                
            let location = CLLocation(latitude: newCoordinate.latitude, longitude: newCoordinate.longitude)
            
            var title = ""
            
            CLGeocoder().reverseGeocodeLocation(location) { (placemarks, error) in
                if  error != nil {
                    print(error!)
                } else {
                    if let placemark = placemarks? [0] {
                        if placemark.subThoroughfare != nil {
                            title += placemark.subThoroughfare! + " "
                        }
                        if placemark.thoroughfare != nil {
                            title += placemark.thoroughfare! + " "
                        }
                        }
                    }
                
                if title == " " {
                    title = "Added\(NSDate()) "
                }
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = newCoordinate
                    annotation.title = title
                    self.mapa.addAnnotation(annotation)
                
                    places.append(["name":title,"lat":String(newCoordinate.latitude), "lon":String(newCoordinate.longitude)])
                    
                    UserDefaults.standard.set(places, forKey: "places")
                
                    print (places)
                }
            }
                
            
        }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = CLLocationCoordinate2D(latitude: locations[0].coordinate.latitude, longitude: locations[0].coordinate.longitude)
        let span = MKCoordinateSpan (latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: location, span: span)
        self.mapa.setRegion(region, animated: true)
    }
}
        



