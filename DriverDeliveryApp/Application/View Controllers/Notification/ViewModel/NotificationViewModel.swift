//
//  NotificationViewModel.swift
//  DriverDeliveryApp
//
//  Created by Navaldeep Kaur on 07/05/20.
//  Copyright © 2020 Navaldeep Kaur. All rights reserved.
//


import Foundation
import UIKit
import Alamofire


protocol NotificationDelegate
{
    func Show(msg: String)
    func didError(error:String)
}

class NotificationViewModel
{
    typealias successHandler = (NotificationModel) -> Void
    var delegate : NotificationDelegate
    var view : UIViewController
    
    init(Delegate : NotificationDelegate, view : UIViewController)
    {
        delegate = Delegate
        self.view = view
    }
    
    func getNotificationListApi(completion: @escaping successHandler)
    {
        WebService.Shared.GetApiForJOB(url: APIAddress.notificationList ,Target: self.view, showLoader: true, completionResponse: { (response) in
            print(response)
            do
            {
                let jsonData = try JSONSerialization.data(withJSONObject: response, options: .prettyPrinted)
                let getAllListResponse = try JSONDecoder().decode(NotificationModel.self, from: jsonData)
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
    
    //MARK:- DeleteAllNotifications Api
    func deleteAllNotificationsApi(completion: @escaping successHandler)
    {
        let obj = [String:Any]()
        WebService.Shared.deleteApi(url: APIAddress.deleteNotifications, Target: self.view, showLoader: true, completionResponse: { (response) in
            do
            {
                let jsonData = try JSONSerialization.data(withJSONObject: response, options: .prettyPrinted)
                let getAllListResponse = try JSONDecoder().decode(NotificationModel.self, from: jsonData)
                completion(getAllListResponse)
            }
            catch
            {
                print(error.localizedDescription)
                self.view.showAlertMessage(titleStr: kAppName, messageStr: error.localizedDescription)
            }
        }) { (error) in
            self.view.showAlertMessage(titleStr: kAppName, messageStr: error)
            
        }
    }
    
    
}
