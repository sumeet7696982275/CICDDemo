//
//  WalletHistoryViewModel.swift
//  DriverDeliveryApp
//
//  Created by Navaldeep Kaur on 02/11/20.
//  Copyright © 2020 Navaldeep Kaur. All rights reserved.
//

import Foundation
import UIKit
import Alamofire


protocol WalletHistoryDelegate
{
  func Show(msg: String)
    func didError(error:String)
}

class WalletHistoryViewModel
{
    typealias successHandler = (WalletModel) -> Void
    typealias succes_Handler = (TransferMoneyModel) -> Void
    var delegate : WalletHistoryDelegate
    var view : UIViewController
    
    init(Delegate : WalletHistoryDelegate, view : UIViewController)
    {
        delegate = Delegate
        self.view = view
    }
   

    //MARK: - walletHistoryApi
    func walletHistoryApi(fromDate:String?,toDate:String?,page:String,payType:String,completion: @escaping successHandler)
    {
        let obj : [String:Any] = ["fromDate":fromDate ?? "","toDate": toDate ?? "","page":page,"limit":"10","payType":payType]
    
        WebService.Shared.PostApi(url: APIAddress.walletHistory, parameter: obj, Target: self.view, completionResponse: { (response) in
                  do
                         {
                             let jsonData = try JSONSerialization.data(withJSONObject: response, options: .prettyPrinted)
                             let getAllListResponse = try JSONDecoder().decode(WalletModel.self, from: jsonData)
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
    
    //MARK: - tranferMoneyApi
    func transferMoneyApi(amount:String?,completion: @escaping succes_Handler)
    {
        let obj : [String:Any] = ["amount":amount ?? ""]
        WebService.Shared.PostApi(url: APIAddress.transferMoney, parameter: obj, Target: self.view, completionResponse: { (response) in
                  do
                         {
                             let jsonData = try JSONSerialization.data(withJSONObject: response, options: .prettyPrinted)
                             let getAllListResponse = try JSONDecoder().decode(TransferMoneyModel.self, from: jsonData)
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
