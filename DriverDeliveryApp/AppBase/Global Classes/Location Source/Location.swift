//
//  Location.swift
//  BidJones
//
//  Created by Rakesh Kumar on 5/22/18.
//  Copyright © 2018 Seasia. All rights reserved.
//

import Foundation
import CoreLocation
import MapKit

var homeScreenDel : SendLocDataToServerDelegate?

protocol mapProtocol
{
    func updateMarkerWithCurrentLocation()
}

class Location: NSObject, CLLocationManagerDelegate
{
    static let shared = Location()
    var locationManager = CLLocationManager()
    
    var lat = 30.710690719999985
    var lng = 76.70918554999997
    
    var old_lat = 30.710690719999985
    var old_lng = 76.70918554999997
    
    var isSaved = false
    var proto : mapProtocol?
    
    func intilize_protocol(prto:mapProtocol?)
    {
        proto = prto
    }
    
    private override init()
    {
        super.init()
        
    }
    
    func InitilizeGPS()
    {
        // self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled()
        {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
            // locationManager.distanceFilter = 10
            locationManager.allowsBackgroundLocationUpdates = true
            // locationManager.pausesLocationUpdatesAutomatically = true
            locationManager.startMonitoringSignificantLocationChanges()
            locationManager.startUpdatingLocation()
        }
        
    }
    
    func stop_location_updates()
    {
        locationManager.stopUpdatingLocation()
    }
    
    func start_location_updates()
    {
        locationManager.startUpdatingLocation()
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        let location = locations.last! as CLLocation
        
        lat = location.coordinate.latitude
        lng = location.coordinate.longitude
        
        AppDefaults.shared.app_LATITUDE = "\(lat)"
        AppDefaults.shared.app_LONGITUDE = "\(lng)"
        
      //  AppDefaults.shared.app_LATITUDE = "40.712775"
      //  AppDefaults.shared.app_LONGITUDE = "-74.005973"
        
        print(lat)
        print(lng)
        
        //MARK:-NAVAL
//        if boolTracking == true
//        {
            if homeScreenDel != nil
            {
                homeScreenDel!.updateSocketData()
            }
            
        //}
        
        
        
        //        if #available(iOS 13.0, *) {
        //            showAlertAppDelegate(title: "Fleet", message: "Update loc", buttonTitle: "", window: KappDelegate.window!)
        //        } else {
        //            // Fallback on earlier versions
        //            showAlertAppDelegate(title: "Fleet", message: "Update loc", buttonTitle: "", window: (UIApplication.shared.windows.first!))
        //        }
        
        
        //saving location in database when current job is active
        
        if (old_lat == lat && old_lng == lng)
        {
            //do nothing
            print("old loc no change")
        }
        else
        {
           old_lat = lat
           old_lng = lng
           save_current_location_in_DB()
           self.emitDriverLocation()
            
        }
        
        
    }
    
    
    func save_current_location_in_DB()
    {
        DispatchQueue.global(qos: .background).async
        {
            print("This is run on the background queue")
            if self.isSaved == false
            {
                if (AppDefaults.shared.currentJobActive == "1")
                {
                    self.isSaved = true
                    self.proto?.updateMarkerWithCurrentLocation()
                   //MARK:-NAVAL
//                    DatabaseActions.start_saving_job_details_with_locations_in_DB(lat: self.lat, long: self.lng, rslt:
//                    { data in
//                       self.isSaved = false
//                    })
                }
                else
                {
                   self.isSaved = false
                   self.stop_location_updates()//when we dont have any job active then stop location updates to prevent battery draining
                }
            }
        }
    }
    
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        lat = 30.710690719999985
        lng = 76.70918554999997
    }
    
    func GetCurrentLocation() -> CLLocationCoordinate2D
    {
        var locat = CLLocationCoordinate2D()
        
        locat.latitude = lat
        locat.longitude = lng
        return locat
    }
    
    func showAlertAppDelegate(title : String,message : String,buttonTitle : String,window: UIWindow)
    {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: buttonTitle, style: UIAlertAction.Style.default, handler: nil))
        if #available(iOS 13.0, *)
        {
            window.rootViewController?.present(alert, animated: true, completion: nil)
        }
        else
        {
            // Fallback on earlier versions
            window.rootViewController?.present(alert, animated: true, completion: nil)
        }
    }
    
    
    func emitDriverLocation()
    {
        SocketHelper.shared.connectSocket
        { (success) in
          print(success)
            
            
//            SocketHelper.Events.updateLocation.emit(params: ["methodName":"updateDriverLocation","latitude":"30.681252174494368","longitude":"76.70192921857249","empId":AppDefaults.shared.userID])
        
         SocketHelper.Events.updateLocation.emit(params: ["methodName":"updateDriverLocation","latitude":AppDefaults.shared.app_LATITUDE,"longitude":AppDefaults.shared.app_LONGITUDE,"empId":AppDefaults.shared.userID])
        }
    }
}

