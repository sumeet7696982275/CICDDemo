//
//  PaymentViewModel.swift
//  DriverDeliveryApp
//
//  Created by Navaldeep Kaur on 19/03/21.
//  Copyright © 2021 Navaldeep Kaur. All rights reserved.
//


import Foundation
protocol PaymentDetailDelegate
{
func Show_results(msg:String)
    func didError(error:String)
}
class PaymentDetailViewModel
{
    var view : PaymentDetailVC
    var delegate : PaymentDetailDelegate
   typealias successHandler = (PaymentModel) -> Void

    init(Delegate : PaymentDetailDelegate, view : PaymentDetailVC)
      {
          delegate = Delegate
          self.view = view
      }
    func getBankDetail(completion: @escaping successHandler){
        let urlPAth = APIAddress.bankDetail
        WebService.Shared.GetApi(url: urlPAth ,Target: self.view, showLoader: true, completionResponse: { (response) in
            print(response)
            do
            {
                let jsonData = try JSONSerialization.data(withJSONObject: response, options: .prettyPrinted)
                let getAllListResponse = try JSONDecoder().decode(PaymentModel.self, from: jsonData)
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
    
    //MARK: - updateBankDetailApi
    
    func updateBankApi(obj:[String:Any],completion: @escaping successHandler)
    {
        WebService.Shared.PostApi(url: APIAddress.updateBankAcc, parameter: obj, Target: self.view, completionResponse: { (response) in
                  do{
                             let jsonData = try JSONSerialization.data(withJSONObject: response, options: .prettyPrinted)
                             let getAllListResponse = try JSONDecoder().decode(PaymentModel.self, from: jsonData)
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
    
    func Validations(obj: [String:Any])
        {
            guard let accountNo = obj["accountNo"] as? String,  !accountNo.isEmpty, !accountNo.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else
            {
                delegate.Show_results(msg: "Account number is empty")
                return
            }
            
            guard let acHolderName = obj["acHolderName"] as? String,  !acHolderName.isEmpty, !acHolderName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else
            {
                delegate.Show_results(msg: "aAccount Holder Name is empty")
                return
            }
            guard let bankName  = obj["bankName"] as? String, !bankName.isEmpty, !bankName.trimmingCharacters(in: .whitespaces).isEmpty else
            {
                delegate.Show_results(msg: "Bank Name is empty")
                return
            }
           
            guard let branchIFSC = obj["branchIFSC"] as? String,  branchIFSC.count > 0 else
            {
                delegate.Show_results(msg: "Branch IFSC is empty")
                return
            }
            guard let branchName = obj["branchName"] as? String,  branchName.count > 0 else
                   {
                       delegate.Show_results(msg: "Branch Name is empty")
                       return
                   }
            updateBankApi(obj: obj) { (data) in
                self.view.AlertMessageWithOkAction(titleStr: kAppName, messageStr: data.message ?? "", Target: self.view) {
                    self.view.navigationController?.popViewController(animated: false)
                }
                
            }
        }
}
