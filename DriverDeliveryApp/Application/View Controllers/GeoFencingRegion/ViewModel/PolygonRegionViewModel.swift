//
//  PolygonRegionModel.swift
//  DriverDeliveryApp
//
//  Created by Navaldeep Kaur on 02/07/21.
//  Copyright © 2021 Navaldeep Kaur. All rights reserved.
//

import Foundation
import UIKit




class PolygonRegionViewModel
{
     typealias success_Handler = (PolygonRegionModel) -> Void
    var view : UIViewController
    
    init(view : UIViewController)
    {
        self.view = view
    }

    func getPolygonRegionApi(completion: @escaping success_Handler)
       {
           WebService.Shared.GetApiForJOB(url: APIAddress.polyRegions,Target: self.view, showLoader: true, completionResponse: { (response) in
               print(response)
               do
               {
                   let jsonData = try JSONSerialization.data(withJSONObject: response, options: .prettyPrinted)
                   let getAllListResponse = try JSONDecoder().decode(PolygonRegionModel.self, from: jsonData)
                   completion(getAllListResponse)
               }
               catch
               {
                   print(error.localizedDescription)
                   self.view.showAlertMessage(titleStr: kAppName, messageStr: error.localizedDescription)
               }
               
           }, completionnilResponse: {(error) in
               self.view.showAlertMessage(titleStr: kAppName, messageStr: error)
           })
       }

}
