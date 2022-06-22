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


protocol OrderDetailDelegate
{
  func Show(msg: String)
    func didError(error:String)
}

class OrderDetailViewModel
{

    typealias successHandler = (OrderDetailModel) -> Void
    typealias success_Handler = (HomeJobModel) -> Void
    var delegate : OrderDetailDelegate
    var view : UIViewController
    
    init(Delegate : OrderDetailDelegate, view : UIViewController)
    {
        delegate = Delegate
        self.view = view
    }

    func getDetailListApi(orderId:String?,completion: @escaping successHandler)
       {
        WebService.Shared.GetApiForJOB(url: APIAddress.orderDetail + (orderId ?? "")  ,Target: self.view, showLoader: true, completionResponse: { (response) in
             //  print(response)
               do
               {
                   let jsonData = try JSONSerialization.data(withJSONObject: response, options: .prettyPrinted)
                   let getAllListResponse = try JSONDecoder().decode(OrderDetailModel.self, from: jsonData)
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
    func cashCollect(orderId:String?,amount:String?,completion: @escaping success_Handler)
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
    //MARK: - Update Track Status Api
    func UpdateTrackStatusApi(Id:String?,status:String?,otp:String,orderImage:URL?,completion: @escaping success_Handler)
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
   
    
    //MARK: - Delay Order Api
    func DelayOrderApi(Id:String?,time:String?,delayReason:String?,completion: @escaping success_Handler)
       {
        let obj : [String:Any] = ["orderId":Id ?? "","time": time ?? "","delayReason":delayReason]
       
        WebService.Shared.PostApiForTrackStatus(url: APIAddress.delayOrder, parameter: obj, Target: self.view, showLoader: true, completionResponse: { (response) in
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
