//
//  HomeViewModel.swift
//  DriverDeliveryApp
//
//  Created by Navaldeep Kaur on 01/05/20.
//  Copyright © 2020 Navaldeep Kaur. All rights reserved.
//

import Foundation
import UIKit
import Alamofire


protocol CancelAlertDelegate
{
  func Show(msg: String)
    func didError(error:String)
}

class CancelAlertViewModel
{
    typealias successHandler = (CancelListModel) -> Void
    var delegate : CancelAlertDelegate
    var view : UIViewController
    
    init(Delegate : CancelAlertDelegate, view : UIViewController)
    {
        delegate = Delegate
        self.view = view
    }

  
    //MARK:- CancelAPi
    func cancelReasonListApi(completion: @escaping successHandler)
       {
           WebService.Shared.GetApiForJOB(url: APIAddress.CancelReasonslist ,Target: self.view, showLoader: true, completionResponse: { (response) in
               print(response)
               do
               {
                   let jsonData = try JSONSerialization.data(withJSONObject: response, options: .prettyPrinted)
                   let getAllListResponse = try JSONDecoder().decode(CancelListModel.self, from: jsonData)
                   completion(getAllListResponse)
               }
               catch
               {
                   print(error.localizedDescription)
                   self.view.showAlertMessage(titleStr: kAppName, messageStr: error.localizedDescription)
               }
               
           }, completionnilResponse: {(error) in
               self.delegate.didError(error: error)
           })
       }
 
}
