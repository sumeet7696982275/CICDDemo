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


protocol FeedBackDelegate
{
  func Show(msg: String)
    func didError(error:String)
}

class FeedbackViewModel
{
     typealias success_Handler = (HomeJobModel) -> Void
    typealias successHandler = (FeedbackModel) -> Void
    var delegate : FeedBackDelegate
    var view : UIViewController
    
    init(Delegate : FeedBackDelegate, view : UIViewController)
    {
        delegate = Delegate
        self.view = view
    }

    func getFeedbackistApi(page:Int?,completion: @escaping successHandler)
       {
           WebService.Shared.GetApiForJOB(url: APIAddress.feedbacklist + "\(page ?? 0)" + "&limit=10"  ,Target: self.view, showLoader: true, completionResponse: { (response) in
               print(response)
               do
               {
                   let jsonData = try JSONSerialization.data(withJSONObject: response, options: .prettyPrinted)
                   let getAllListResponse = try JSONDecoder().decode(FeedbackModel.self, from: jsonData)
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

    //MARK: - ChangeStatus Api
    func changeStatus(status:String?,completion: @escaping success_Handler)
    {
        let obj : [String:Any] = ["status":status ?? ""]
    
        WebService.Shared.PostApi(url: APIAddress.updateStatus, parameter: obj, Target: self.view, completionResponse: { (response) in
                  do
                         {
                             let jsonData = try JSONSerialization.data(withJSONObject: response, options: .prettyPrinted)
                             let getAllListResponse = try JSONDecoder().decode(HomeJobModel.self, from: jsonData)
                             completion(getAllListResponse)
                         }
                         catch
                         {
                             print(error.localizedDescription)
                             self.view.showAlertMessage(titleStr: kAppName, messageStr: error.localizedDescription)
                         }
           }, completionnilResponse: { (error) in
                self.view.showAlertMessage(titleStr: kAppName, messageStr: error)
           })
        }
   
}
