//
//  GeoFenceAreaVC.swift
//  DriverDeliveryApp
//
//  Created by Navaldeep Kaur on 01/07/21.
//  Copyright © 2021 Navaldeep Kaur. All rights reserved.
//

import UIKit
import GoogleMaps
import MapKit

class GeoFenceAreaVC: UIViewController {

    //MARK:- Outlet and variables
    @IBOutlet weak var ViewMap: MKMapView!
    var locationManager = CLLocationManager()
    var geofenceRegion : CLCircularRegion!
    var polygonCoordinate = [CLLocationCoordinate2D]()
    var cordinateObj = [CoordinatesObject]()
    var polygon: MKPolygon?
    
    var viewModel : PolygonRegionViewModel?
    
    //MARK:- LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setView()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.ViewMap.removeOverlays(self.ViewMap.overlays)
        self.ViewMap.removeAnnotations(self.ViewMap.annotations)
        let arrList = [["lat":30.7046,"log":76.7179],["lat":30.73336,"log":76.7794],["lat":30.6942,"log":76.8606], ["lat":30.6425,"log":76.8173]]
//        for data in arrList{
//            self.cordinateObj.append(CoordinatesObject.init(latitude: data["lat"] ?? 0.0, longitude: data["log"] ?? 0.0))
//        }
//        if  self.cordinateObj.count > 0{
//            self.drawOverlays(coordinatesObject: self.cordinateObj)
//            self.createGeofancingRegion()
//        }
        getPolygonRegionApi()
    }
    
    //MARK:- Other Functions
    func setView()
    {
        //Your map initiation code
        ViewMap.delegate = self
        ViewMap.showsUserLocation = true
        //Location Manager code to fetch current location
        self.locationManager.delegate = self
        self.locationManager.startUpdatingLocation()
        self.set_statusBar_color(view: self.view)
        viewModel = PolygonRegionViewModel.init(view: self)

    }

    //MARK:- GetPolygonRegion
    
    func getPolygonRegionApi(){
        viewModel?.getPolygonRegionApi(completion: { (data) in
            if let body = data.body{
                if let polygon = body.polygon{
                    if polygon.count > 0{
                    
                        
                    for data in polygon{
                        self.cordinateObj.removeAll()
                        for coridates in data{
                        self.cordinateObj.append(CoordinatesObject.init(latitude: coridates.lat ?? 0.0, longitude: coridates.long ?? 0.0))
                        }
                        
                        if  self.cordinateObj.count > 0{
                            self.drawOverlays(coordinatesObject: self.cordinateObj)
                            self.createGeofancingRegion()
                        }
                    }
                   
                }
                }
            }
        })
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.moveBACK(controller: self)
    }
    //MARK:- GeoFencingRegion
    func createGeofancingRegion() {
        // coordinates
        let geofenceRegionCenter = CLLocationCoordinate2DMake(polygon?.coordinate.latitude ?? 0, polygon?.coordinate.longitude ?? 0)
        
        /* Create a region centered on desired location,
         choose a radius for the region (in meters)
         choose a unique identifier for that region */
        geofenceRegion = CLCircularRegion(center: geofenceRegionCenter,
                                              radius: 1500,
                                              identifier: "UniqueIdentifier")
        geofenceRegion.notifyOnEntry = true
        geofenceRegion.notifyOnExit = true
        locationManager.startMonitoring(for: geofenceRegion)
    }
 
    
    func drawOverlays(coordinatesObject:[CoordinatesObject]) {
        
            if coordinatesObject.count > 0 {
                
               // self.map.removeOverlays(self.map.overlays)
                
               // self.map.removeAnnotations(self.map.annotations)
                
                let location = CLLocationCoordinate2D(latitude: coordinatesObject[0].latitude ?? 0.0, longitude: coordinatesObject[0].longitude ?? 0.0)
                
                let region = MKCoordinateRegion(center: location, latitudinalMeters:1000, longitudinalMeters: 1000)
                
                ViewMap.setRegion(region, animated: true)
                
                if let first = self.ViewMap.overlays.first {
                    let rect = self.ViewMap.overlays.reduce(first.boundingMapRect, {$0.union($1.boundingMapRect)})
                        self.ViewMap.setVisibleMapRect(rect, edgePadding: UIEdgeInsets(top: 100.0, left: 100.0, bottom: 100.0, right: 100.0), animated: true)
                    }
//
                // add annotation
                
                let annotation = MKPointAnnotation()
                annotation.coordinate = location
               annotation.title = "Deliverable Areas"
                ViewMap.addAnnotation(annotation)
                
                // show overlay
                
                var polygonCoordinate = [CLLocationCoordinate2D]()
                
                coordinatesObject.forEach({
                    
                    polygonCoordinate.append(CLLocationCoordinate2D(latitude: $0.latitude ?? 0.0, longitude: $0.longitude ?? 0.0))
                    
                })
                
                self.polygonCoordinate = polygonCoordinate
                
                polygon = MKPolygon(coordinates: polygonCoordinate, count: polygonCoordinate.count)
                ViewMap.addOverlay(polygon ?? MKPolygon())
                
                    
            
        }
    }

}

//MARK:- mapDelegate
extension GeoFenceAreaVC:MKMapViewDelegate,CLLocationManagerDelegate{
    
    func mapView(_ mapView: MKMapView,
                 rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
//
//        if let circleOverlay = overlay as? MKCircle {
//            let circleRenderer = MKCircleRenderer(overlay: circleOverlay)
//            circleRenderer.fillColor = .red
//            circleRenderer.alpha = 0.5
//
//            return circleRenderer
//        }
        if let polygonOverlay = overlay as? MKPolygon {
            let polygonRenderer = MKPolygonRenderer(overlay: polygonOverlay)
            polygonRenderer.fillColor = .red
            polygonRenderer.alpha = 0.5
            
           // polygonRenderer.strokeColor = .blue
            
            
            return polygonRenderer
        }

        return MKOverlayRenderer(overlay: overlay)
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {

           if let touch = touches.first {
               if touch.tapCount == 1 {
                   let touchLocation = touch.location(in: ViewMap)
                   let locationCoordinate = ViewMap.convert(touchLocation, toCoordinateFrom: ViewMap)
                   var polygons: [MKPolygon] = []
                   for polygon in ViewMap.overlays as! [MKPolygon] {
                       let renderer = MKPolygonRenderer(polygon: polygon)
                    let mapPoint = MKMapPoint(locationCoordinate)
                       let viewPoint = renderer.point(for: mapPoint)
                       if renderer.path.contains(viewPoint) {
                           polygons.append(polygon)
                       }
                       if polygons.count > 0 {
                           //Do stuff here like use a delegate:
                           //self.mapViewTouchDelegate?.polygonsTapped(polygons: polygons)
                        
                        let location = CLLocationCoordinate2D(latitude: polygons[0].coordinate.latitude , longitude: polygons[0].coordinate.longitude)
                        
                        let region = MKCoordinateRegion(center: location, latitudinalMeters:1000, longitudinalMeters: 1000)
                        
                        ViewMap.setRegion(region, animated: true)
                       }
                   }
               }
           }

        super.touchesEnded(touches, with: event)
    }
    // called when user Exits a monitored region
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        if region is CLCircularRegion {
            // Do what you want if this information
            print("exit")

           
        }
    }
    

    
    // called when user Enters a monitored region
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        if region is CLCircularRegion {
            print("enter")
            // Do what you want if this information
           
        }
    }
    
    private func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()
            ViewMap.showsUserLocation = true
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last
//        let center = CLLocationCoordinate2D(latitude: location?.coordinate.latitude, longitude: location?.coordinate.longitude)
//              var region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
//              region.center = mapView.userLocation.coordinate
//              mapView.setRegion(region, animated: true)

      
        //Finally stop updating location otherwise it will come again and again in this delegate
        self.locationManager.stopUpdatingLocation()
    }
    
}
