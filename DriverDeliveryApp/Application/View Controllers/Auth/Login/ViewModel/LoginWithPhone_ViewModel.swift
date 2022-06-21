//
//  LoginWithPhone_ViewModel.swift
//  DriverDeliveryApp
//
//  Created by Navaldeep Kaur on 30/04/20.
//  Copyright © 2020 Navaldeep Kaur. All rights reserved.
//

//

import Foundation
import Alamofire
import FirebaseAuth
import Firebase



class LoginWithPhone_ViewModel
{
    var view : UIViewController
    var phnNumber = ""
    var cntryCode = ""
    
    init(view : UIViewController)
    {
        self.view = view
    }
    
    func SignIn(phoneNumber:String,countryCode:String)
    {
        self.phnNumber = phoneNumber
        self.cntryCode = countryCode
        
        
        var dvcID =  "\(AppDefaults.shared.firebaseToken)"
        if (dvcID.count == 0)
        {
           dvcID = "123"
        }
    
      //  let obj : [String:Any] = ["phoneNumber":"9355717524","countryCode":"91", "deviceToken": dvcID,"platform" :"ios"]
        
        
        let obj : [String:Any] = ["phoneNumber":phoneNumber,"countryCode":countryCode, "deviceToken": dvcID,"platform" :"ios"]
        
        
        WebService.Shared.PostApi(url: APIAddress.Login, parameter: obj , Target: self.view, completionResponse: { response in
            Commands.println(object: response)
            
            DispatchQueue.main.async {
                
                do
                {
                    let jsonData = try JSONSerialization.data(withJSONObject: response, options: .prettyPrinted)
                    let model = try JSONDecoder().decode(SignIn_ResponseModel.self, from: jsonData)
                    
                    if (model.code == 200)
                    {
                       self.get_otp_from_firebase(phoneNumber:"+" + countryCode+phoneNumber, userData: model)
                //      self.setRoot(userData:model)
                    }
                    else
                    {
                        self.view.showAlertMessage(titleStr: kAppName, messageStr: kUserNotRegistered)
                    }
                    
                }
                catch
                {
                    self.view.showAlertMessage(titleStr: kAppName, messageStr: kResponseNotCorrect)
                }
                
            }
            
            
            
        }, completionnilResponse: {(error) in
            
            if (error == "Phone Number does not exist")
            {
               // self.get_otp_from_firebase(phoneNumber:countryCode+phoneNumber, userData: nil)
                self.view.showAlertMessage(titleStr: kAppName, messageStr: error)
            }
            else
            {
                self.view.showAlertMessage(titleStr: kAppName, messageStr: error)
            }
            
        })
        
    }
    
    
    func get_otp_from_firebase(phoneNumber:String,userData:SignIn_ResponseModel?)
    {
        FirbaseOTPAuth.get_otp_from_firebase(controller: self.view, phoneNumber: phoneNumber) { (result) in
            if (result.count > 0)
            {
                AppDefaults.shared.firebaseVID = result
                //go to otp screen
                let controller = Navigation.GetInstance(of: .CheckOTPVC) as! CheckOTPVC
                controller.phoneNumber = self.phnNumber
                controller.countryCode = self.cntryCode
                controller.push_approach = kPush_Approach_from_SignUp
                controller.userData = userData!
                self.view.push_To_Controller(from_controller: self.view, to_Controller: controller)
            }
            
        }
    }
    
    func setRoot(userData:SignIn_ResponseModel?)
    {
        AppDefaults.shared.userName = (userData?.body?.firstName ?? "") + (userData?.body?.lastName ?? "")
        AppDefaults.shared.userFirstName = userData?.body?.firstName ?? ""
        AppDefaults.shared.userLastName = userData?.body?.lastName ?? ""
        AppDefaults.shared.userJWT_Token = userData?.body?.sessionToken ?? ""
        AppDefaults.shared.userEmail = userData?.body?.email ?? ""
        AppDefaults.shared.userPhoneNumber = "\(userData?.body?.phoneNumber ?? "")"
        AppDefaults.shared.userCountryCode = userData?.body?.countryCode ?? ""
        AppDefaults.shared.userID = userData?.body?.id ?? "0"
        AppDefaults.shared.ID = userData?.body?.id ?? "0"
        AppDefaults.shared.userImage = userData?.body?.image ?? ""
         AppDefaults.shared.CompanyID = userData?.body?.companyId ?? ""
        
        configs.kAppdelegate.setRootViewController()
    }
    
}

