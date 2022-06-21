//
//  MapVC.swift
//  DriverDeliveryApp
//
//  Created by Navaldeep Kaur on 02/05/20.
//  Copyright © 2020 Navaldeep Kaur. All rights reserved.
//

import UIKit
import GoogleMaps
import Alamofire
import GooglePlaces
import SwiftyJSON

class MapVC: UIViewController {
    
    //MARK:- outlet and Variables
    @IBOutlet weak var viewMap: GMSMapView!
    @IBOutlet weak var btnMoveToMap: CustomButton!
  
    var polyline = GMSPolyline()
    var source_marker = GMSMarker()
    var destination_marker = GMSMarker()
    var order_marker = GMSMarker()
    var locationManager = CLLocationManager()
    var destinationlat:Double?
    var destinationlong:Double?
    var sourcelat = 0.0
    var sourcelong = 0.0
    var isFirstTime = false
    var orderId:String?
    
    var start_lat = 31.5143
    var start_long = 75.9115
    
    var arrLatLongData = [[String:Any]]()
    var trackStatus :Int?
      
    //  var start_lat = 0.0
    //  var start_long = 0.0
      
      var stop_lat = 30.7046
      var stop_long = 76.7179
    //MARK:- life cycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
      
        
        setView()
       // self.connect_socket_with_server()
       
    }
    
    //MARK:- ConnectSocket
       
       func connect_socket_with_server()
         {
           SocketHelper.shared.connectSocket
           { (success) in
             print(success)
           
            SocketHelper.Events.updateLocation.emit(params: ["methodName":"updateLocation","orderId":self.orderId,"latLong":self.arrLatLongData,"empId":AppDefaults.shared.userID])
           }
       }
      
       func receiveEventsFromSocket()
         {
           SocketHelper.Events.updateLocation.listen { [weak self] (result) in
              print(result)
           }
         }
    
    //MARK:- Actions
    
    @IBAction func btnBackActions(_ sender: Any)
    {        self.navigationController?.popViewController(animated: false)
    }
    
   
    @IBAction func btnMapAction(_ sender: Any)
    {
        if (UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!)) {
            UIApplication.shared.open(URL(string:"comgooglemaps://?center=\(sourcelat),\(sourcelong)&zoom=14&views=traffic&q=\(destinationlat ?? 0.0),\(destinationlong ?? 0.0)")!, options: [:], completionHandler: nil)
        } else {
            // if GoogleMap App is not installed
            UIApplication.shared.openURL(NSURL(string:"https://www.google.co.in/maps/dir/?saddr=\(sourcelat),\(sourcelong)&daddr=\(destinationlat ?? 0.0),\(destinationlong ?? 0.0)&directionsmode=driving")! as URL)
        }
    }
    
    //MARK:-Other functions
    func setView()
    {
        //Your map initiation code
        self.viewMap?.isMyLocationEnabled = true
        
        //Location Manager code to fetch current location
        self.locationManager.delegate = self
        self.locationManager.startUpdatingLocation()
        viewMap.delegate = self
        viewMap.isMyLocationEnabled = true
        viewMap.settings.myLocationButton = true
        
        //setColor
        btnMoveToMap.backgroundColor = Appcolor.kThemeColor
        btnMoveToMap.setTitleColor(Appcolor.kTextColorWhite, for: .normal)
        
        if(trackStatus == 8 || self.trackStatus == 9){
           btnMoveToMap.isHidden = false
        }
        else{
            btnMoveToMap.isHidden = true
        }
    }
   
    
    func getMyCurrentLocation()
       {
           if (destinationlat != 0.0 && destinationlong != 0.0)
           {
               Location.shared.stop_location_updates()
               self.DRAW_ROUTE_ON_MAP()
           }
           else
           {
             //  DispatchQueue.main.asyncAfter(deadline: .now() + 3.0)
             //  {
             //      Location.shared.start_location_updates()
             //      self.getMyCurrentLocation()
             //  }
           }
       }
    //MARK:  ADD POLYLINE ON MAP
    func addPolyLine(encodedString: String, coordinate: CLLocationCoordinate2D ,dotCoordinate : CLLocationCoordinate2D)
    {
        let dotPath :GMSMutablePath = GMSMutablePath()
        // add coordinate to your path
        dotPath.add(CLLocationCoordinate2DMake(coordinate.latitude, coordinate.longitude))
        dotPath.add(CLLocationCoordinate2DMake(dotCoordinate.latitude, dotCoordinate.longitude))
        
        let dottedPolyline  = GMSPolyline(path: dotPath)
        dottedPolyline.map = self.viewMap
        dottedPolyline.strokeWidth = 5.0
        let styles: [Any] = [GMSStrokeStyle.solidColor(UIColor.green), GMSStrokeStyle.solidColor(UIColor.clear)]
        let lengths: [Any] = [10, 5]
        dottedPolyline.spans = GMSStyleSpans(dottedPolyline.path!, styles as! [GMSStrokeStyle], lengths as! [NSNumber], GMSLengthKind.rhumb)
        
        //---------Route Polyline---------\\
        
        let path = GMSMutablePath(fromEncodedPath: encodedString)
        polyline = GMSPolyline(path: path)
        polyline.strokeWidth = 3
        polyline.strokeColor = .black//Appcolor.get_category_theme()
        
        polyline.map = self.viewMap
       
      DispatchQueue.main.async
      {
       if self.viewMap != nil
       {
        let bounds = GMSCoordinateBounds(path: path!)
        self.viewMap!.animate(with: GMSCameraUpdate.fit(bounds, withPadding: 60.0))
       }
    }
       
       self.ShowMapPin_source()
       
    }
    
    //MARK:  DRAWING ROUTE ON MAP
       func DRAW_ROUTE_ON_MAP()
       {
           self.viewMap.clear()
           
        var directionURL =  "https://maps.googleapis.com/maps/api/directions/json?origin=\(sourcelat),\(sourcelong)&destination=\(destinationlat ?? 0.0),\(destinationlong ?? 0.0)&key=\(GoogleAPIKey)"
           print(directionURL as Any)
           directionURL += "&mode=" + "drive"
           Alamofire.request(directionURL).responseJSON
               { response in
                   
                   if let JSON = response.result.value
                   {
                       let mapResponse: [String: AnyObject] = JSON as! [String : AnyObject]
                       
                       let routesArray = (mapResponse["routes"] as? Array) ?? []
                       
                       let routes = (routesArray.first as? Dictionary<String, AnyObject>) ?? [:]
                       //--------Dash line lat-long for starting point ----------\\
                       let dictArray = (routes["legs"] as? Array) ?? []
                       let dict = (dictArray.first as? Dictionary<String, AnyObject>) ?? [:]
                       let steps = (dict["steps"] as? Array) ?? []
                       
                       let stepsDict = (steps.first as? Dictionary<String, AnyObject>) ?? [:]
                       let startLocation = stepsDict["start_location"]
                       let lat = startLocation?["lat"] as? NSNumber ?? 0.0
                       let lng = startLocation?["lng"] as? NSNumber ?? 0.0
                       
                       // let dotCoordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(lat), longitude: CLLocationDegrees(lng))
                       let dotCoordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(truncating: lat), longitude: CLLocationDegrees(truncating: lng))
                       //--------Route polypoints----------\\
                       let overviewPolyline = (routes["overview_polyline"] as? Dictionary<String,AnyObject>) ?? [:]
                       let polypoints = (overviewPolyline["points"] as? String) ?? ""
                       let line  = polypoints
                       self.addPolyLine(encodedString: line, coordinate:dotCoordinate , dotCoordinate:dotCoordinate)
                       
                   }
                   else
                   {
                       // MBProgressHUD.hide(for: self.view, animated: true)
                   }
           }
           
       }
    
    //MARK:  SHOW SOURCE PIN IN MAP
    func ShowMapPin_source()
    {
        viewMap.delegate = self
        source_marker = GMSMarker()
//
        let camera = GMSCameraPosition.camera(withLatitude: sourcelat, longitude: sourcelong, zoom: 10.0)
        self.viewMap.camera = camera
        self.viewMap.mapType = .normal
        
        source_marker.position = CLLocationCoordinate2D(latitude: sourcelat, longitude: sourcelong)
       // source_marker.title = "Order pick-up Location"
        source_marker.title = "Order Pickup Location"
        source_marker.snippet = ""
        source_marker.icon = GMSMarker.markerImage(with: UIColor.red)
        source_marker.map = viewMap
        self.ShowMapPin_destination()
       
    }
    
    
    //MARK:  SHOW DESTINATION PIN IN MAP
    func ShowMapPin_destination()
    {
        self.viewMap.delegate = self
        destination_marker = GMSMarker()
        self.viewMap.mapType = .normal
        
//        let position = CLLocationCoordinate2D(latitude: 30.7046, longitude: 76.7179)
//        let marker = GMSMarker(position: position)
//        marker.title = "Hello World"
//        marker.map = viewMap
        
        destination_marker.position = CLLocationCoordinate2D(latitude: destinationlat ?? 0.0 , longitude: destinationlong ?? 0.0)
        destination_marker.title = "Order Destination Location"
        destination_marker.snippet = ""
        destination_marker.icon = GMSMarker.markerImage(with: UIColor.green)
        destination_marker.map = viewMap
        
       // self.add_pin_on_map_from_socket_lat_longs()
    }
    
        
    
}
//MARK:- mapDelegate
extension MapVC:GMSMapViewDelegate,CLLocationManagerDelegate{
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition)
    {
      //  arrLatLongData.removeAll()
        let coordinate = mapView.projection.coordinate(for: mapView.center)
        
        print(coordinate.latitude as Any)
        
     //   self.sourcelat = coordinate.latitude
     //   self.sourcelong = coordinate.longitude
        
        if isFirstTime == false
        {
                    isFirstTime = true
                    getMyCurrentLocation()
        }

        let obj = ["lat":"\(sourcelat)","long":"\(sourcelong)"]
        arrLatLongData.append(obj)
       // connect_socket_with_server()
    }
    
    private func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()
            viewMap.isMyLocationEnabled = true
            viewMap.settings.myLocationButton = true
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last
        let camera = GMSCameraPosition.camera(withLatitude: (location?.coordinate.latitude)!, longitude: (location?.coordinate.longitude)!, zoom: 10.0)
        self.viewMap.animate(to: camera)

      
        //Finally stop updating location otherwise it will come again and again in this delegate
        self.locationManager.stopUpdatingLocation()
    }
    
}
