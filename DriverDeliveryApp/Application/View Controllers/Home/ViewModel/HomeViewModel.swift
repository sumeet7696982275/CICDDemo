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


protocol HomeVCDelegate
{
  func Show(msg: String)
    func didError(error:String)
}

class HomeViewModel
{
    typealias successHandler = (HomeJobModel) -> Void
    typealias cancelOrder = (CancelOrderModel)  -> Void
    typealias statusHandler = (ChangeStatusModel) -> Void
    var delegate : HomeVCDelegate
    var view : UIViewController
    
    init(Delegate : HomeVCDelegate, view : UIViewController)
    {
        delegate = Delegate
        self.view = view
    }

    func getJobListApi(status:String?,page:Int?,jobStatus:String,completion: @escaping successHandler)
       {
           WebService.Shared.GetApiForJOB(url: APIAddress.GetJobApi+"\(status ?? "")" + "&page=" + "\(page ?? 0)" + "&limit=10" + "&jobStatus=" + jobStatus,Target: self.view, showLoader: true, completionResponse: { (response) in
             //  print(response)
         //   print()
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

    //MARK:- CancelAPi
    func cancelReasonListApi(status:Int?,completion: @escaping successHandler)
       {
           WebService.Shared.GetApiForJOB(url: APIAddress.CancelReasonslist ,Target: self.view, showLoader: true, completionResponse: { (response) in
            //   print(response)
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
    //MARK: - Submit cancel reason Api
    func submitCancelApi(orderId:String?,reasonId:String?,otherResason:String?,completion: @escaping cancelOrder)
       {
        let obj : [String:Any] = ["orderId":orderId ?? "","cancellationReason": reasonId ?? "","otherReason":otherResason ?? ""]
       
        WebService.Shared.PostApiForTrackStatus(url: APIAddress.submitCancel, parameter: obj, Target: self.view, showLoader: true, completionResponse: { (response) in
                     do
                            {
                                let jsonData = try JSONSerialization.data(withJSONObject: response, options: .prettyPrinted)
                                let getAllListResponse = try JSONDecoder().decode(CancelOrderModel.self, from: jsonData)
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
    
    //MARK: - Update Track Status Api
    func UpdateTrackStatusApi(Id:String?,status:String?,otp:String,orderImage:URL?,completion: @escaping successHandler)
    {
       // let obj : [String:Any] = ["id":Id ?? "","status": status ?? "","otp":otp]
    
        var parm = [String:Any]()
        parm["id"] = Id ?? ""
        parm["status"] = status ?? ""
        parm["otp"] = otp
        
        var mediaObjs = [[String:Any]]()
        if(orderImage != nil)
        {
            var orderImgObj = [String:Any]()
            orderImgObj["fileType"] = "Image"
            orderImgObj["url"] = orderImage
            mediaObjs.insert(orderImgObj, at: 0)
        }
        parm["image"] = mediaObjs

       // WebService.Shared.PostApiForTrackStatus(url: APIAddress.updateTrackStatusApi, parameter: obj, Target: self.view, showLoader: false, completionResponse: { (response) in
        
        WebService.Shared.uploadDataMulti(mediaType: .Image, url: APIAddress.updateTrackStatusApi, postdatadictionary: parm, Target: view, isTarckStatus: true, completionResponse: { (response) in
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

        }, completionError: { (error) in
            self.view.showAlertMessage(titleStr: kAppName, messageStr: error as! String)
        })
    }
    
    
    //MARK: -Accept Job Api
    func acceptJobApi(Id:String?,orderId:String?,completion: @escaping successHandler)
    {
            let obj : [String:Any] = ["id":Id ?? "","orderId": orderId ?? ""]
    
        WebService.Shared.PostApi(url: APIAddress.acceptJob, parameter: obj, Target: self.view, completionResponse: { (response) in
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
    
    //MARK: -Reject Job Api
    func rejectJobApi(Id:String?,orderId:String?,completion: @escaping successHandler)
    {
            let obj : [String:Any] = ["id":Id ?? "","orderId": orderId ?? ""]
        print(obj)
    
        WebService.Shared.PostApi(url: APIAddress.rejectJob, parameter: obj, Target: self.view, completionResponse: { (response) in
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
    
    //MARK: - ChangeStatus Api
    func changeStatus(status:String?,completion: @escaping successHandler)
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
    
    //MARK: - ChangeStatus Api
    func cashCollect(orderId:String?,amount:String?,completion: @escaping successHandler)
    {
        let obj : [String:Any] = ["orderId":orderId ?? "","amount":amount ?? "","currency":AppDefaults.shared.currency ]
    
        WebService.Shared.PostApi(url: APIAddress.cashCollect, parameter: obj, Target: self.view, completionResponse: { (response) in
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
    
    //MARK:- GetStatusAPi
       func getStatusListApi(completion: @escaping statusHandler)
          {
              WebService.Shared.GetApi(url: APIAddress.allStatus ,Target: self.view, showLoader: true, completionResponse: { (response) in
                //
                print(response)
                  do
                  {
                      let jsonData = try JSONSerialization.data(withJSONObject: response, options: .prettyPrinted)
                      let getAllListResponse = try JSONDecoder().decode(ChangeStatusModel.self, from: jsonData)
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
