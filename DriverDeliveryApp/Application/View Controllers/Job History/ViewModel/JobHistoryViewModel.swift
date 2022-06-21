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


protocol JobHistoryDelegate
{
  func Show(msg: String)
    func didError(error:String)
}

class JobHistoryViewModel
{
    typealias successHandler = (HomeJobModel) -> Void
    var delegate : JobHistoryDelegate
    var view : UIViewController
    
    init(Delegate : JobHistoryDelegate, view : UIViewController)
    {
        delegate = Delegate
        self.view = view
    }

    func getJobListApi(status:String?,page:Int?,jobStatus : String,completion: @escaping successHandler)
    {
        WebService.Shared.GetApiForJOB(url: APIAddress.GetJobApi+"\(status ?? "")" + "&page=" + "\(page ?? 0)" + "&limit=10" + "&jobStatus=" + jobStatus,Target: self.view, showLoader: true, completionResponse: { (response) in
            print(response)
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
               
           }, completionnilResponse: {(error) in
               self.delegate.didError(error: error)
           })
       }

    //MARK: - Update Track Status Api
    func UpdateTrackStatusApi(Id:String?,status:String?,completion: @escaping successHandler)
    {
            let obj : [String:Any] = ["id":Id ?? "","status": status ?? ""]
    
        WebService.Shared.PostApiForTrackStatus(url: APIAddress.updateTrackStatusApi, parameter: obj, Target: self.view, showLoader: true, completionResponse: { (response) in
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
