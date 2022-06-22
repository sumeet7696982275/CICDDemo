
//
//  SignInVC_ViewModel.swift
//  Fleet Management
//
//  Created by Mohit Sharma on 2/20/20.
//  Copyright © 2020 Seasia Infotech. All rights reserved.
//

import Foundation
import Alamofire

protocol EditProfileVCDelegate
{
    func Show_results(msg: String)
    func getData (model : EditProfile_ResponseModel)
    func updateSuccess(msg : String?)
}

class EditProfile_ViewModel
{
    var delegate : EditProfileVCDelegate
    var view : UIViewController
    
    init(Delegate : EditProfileVCDelegate, view : UIViewController)
    {
        delegate = Delegate
        self.view = view
    }
    
    func getProfile()
    {
        WebService.Shared.GetApi(url: APIAddress.GetProfile , Target: self.view, showLoader: true, completionResponse: { response in
            Commands.println(object: response)
            
            do
            {
                let jsonData = try JSONSerialization.data(withJSONObject: response, options: .prettyPrinted)
                let model = try JSONDecoder().decode(EditProfile_ResponseModel.self, from: jsonData)
                self.delegate.getData(model: model)
                
                AppDefaults.shared.CompanyID = model.body?.companyId ?? ""
                AppDefaults.shared.userName = (model.body?.firstName ?? "") + (model.body?.lastName ?? "")
                AppDefaults.shared.userFirstName = model.body?.firstName ?? ""
                AppDefaults.shared.userLastName = model.body?.lastName ?? ""
                AppDefaults.shared.userEmail = model.body?.email ?? ""
                AppDefaults.shared.userPhoneNumber = "\(model.body?.phoneNumber ?? "")"
                AppDefaults.shared.userCountryCode = model.body?.countryCode ?? ""
                AppDefaults.shared.userImage = model.body?.image ?? ""
                
            }
            catch
            {
                self.view.showAlertMessage(titleStr: kAppName, messageStr: kResponseNotCorrect)
            }
            
        }, completionnilResponse: {(error) in
            self.view.showAlertMessage(titleStr: kAppName, messageStr: error)
        })
        
    }
    
    func uploadDocuments(params:[String:Any])
    {
        self.view.view.endEditing(true)
        WebService.Shared.uploadDataMulti(mediaType:.Image, url: APIAddress.uploadDocument, postdatadictionary: params, Target: view, isTarckStatus: false, completionResponse: { response in
            Commands.println(object: response as Any)
            
            do
            {
                let jsonData = try JSONSerialization.data(withJSONObject: response, options: .prettyPrinted)
                let model = try JSONDecoder().decode(EditProfile_ResponseModel.self, from: jsonData)
                
                if(model.code == 200)
                {
                    self.delegate.updateSuccess(msg:"Profile updated successfully.")
                }
                else
                {
                    self.view.showToastSwift(alrtType: .error, msg: model.message ?? "", title: kOops)
                }

            }
            catch
            {
                self.view.showToastSwift(alrtType: .error, msg: kResponseNotCorrect, title: kOops)
            }
            
        }, completionnilResponse: { (errorMsg) in
            self.view.showToastSwift(alrtType: .error, msg: errorMsg, title: kOops)
        }, completionError: { (error) in
            self.view.showToastSwift(alrtType: .error, msg: error?.localizedDescription ?? kSomthingWrong, title: kOops)
        })
    }
    
    
    
    func Validations(obj: [String:Any],profileImage:URL?,idProofImage:URL?,uploadDoc:[String:Any])
    {
      
        guard let firstName = obj["firstName"] as? String,  !firstName.isEmpty, !firstName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else
        {
            delegate.Show_results(msg: "First Name is empty")
            return
        }
        
        guard let lastName = obj["lastName"] as? String,  !lastName.isEmpty, !lastName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else
        {
            delegate.Show_results(msg: "Last Name is empty")
            return
        }
        guard let emailAddress  = obj["email"] as? String, !emailAddress.isEmpty, !emailAddress.trimmingCharacters(in: .whitespaces).isEmpty else
        {
            delegate.Show_results(msg: "Email address is empty")
            return
        }
        if(!emailAddress.isEmail)
        {
            delegate.Show_results(msg: "Invalid Email address is ")
            return
        }
        guard let addressArr = obj["address"] as? String,  addressArr.count > 0 else
        {
            delegate.Show_results(msg: "Address is empty")
            return
        }
//        guard let IdProof = obj["idProofName"] as? String,  IdProof.count > 0 else
//               {
//                   delegate.Show_results(msg: "Id Proof is empty")
//                   return
//               }
//        if (idProofImage == nil){
//           delegate.Show_results(msg: "Id Proof Image is empty")
//        }
    //    else{
        WebService.Shared.uploadDataMulti(mediaType:.Image, url: APIAddress.updateProfile, postdatadictionary: obj, Target: view, isTarckStatus: false, completionResponse: { response in
            Commands.println(object: response as Any)
            
            if let dic = response as? NSDictionary
            {
                let code = dic.value(forKey: "code")as? Int
                let msg = dic.value(forKey: "message")as? String ?? kSomthingWrong
                
                if (code == 200)
                {
                    self.uploadDocuments(params: uploadDoc)
                    
                    if (dic.object(forKey: "body") as? NSDictionary) != nil
                    {
                        
                        let obj = dic.object(forKey: "body") as? NSDictionary
                        
                        let fname = obj?.value(forKey: "firstName")as? String ?? ""
                        let lname = obj?.value(forKey: "lastName")as? String ?? ""
                        
                        
                        AppDefaults.shared.userName = fname + lname
                        AppDefaults.shared.userFirstName = fname
                        AppDefaults.shared.userLastName = lname
                        AppDefaults.shared.userEmail = obj?.value(forKey: "email")as? String ?? ""
                        AppDefaults.shared.userPhoneNumber = obj?.value(forKey: "phoneNumber")as? String ?? ""
                        AppDefaults.shared.userImage = obj?.value(forKey: "image")as? String ?? ""
                        AppDefaults.shared.userCoverImage = obj?.value(forKey: "coverImage")as? String ?? ""
                    }
                    
                   
                  //  self.view.showAlertMessage(titleStr: kAppName, messageStr: "Profile updated successfully.")
                    
                }
                else
                {
                    self.view.showAlertMessage(titleStr: kAppName, messageStr: msg)
                }
            }
            else
            {
                self.view.showAlertMessage(titleStr: kAppName, messageStr: kSomthingWrong)
            }
            
        }, completionnilResponse: { (errorMsg) in
            self.view.showAlertMessage(titleStr: kAppName, messageStr: errorMsg)
        }, completionError: { (error) in
            self.view.showAlertMessage(titleStr: kAppName, messageStr: error as! String)
        })
 // }
    }
}







