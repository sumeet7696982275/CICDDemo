//
//  File.swift
//  Fleet Management
//
//  Created by Mohit Sharma on 2/20/20.
//  Copyright © 2020 Seasia Infotech. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseAuth

class FirbaseOTPAuth:NSObject
{
    class func get_otp_from_firebase(controller:UIViewController,phoneNumber:String, completionHandler: @escaping (String) -> Void)
    {
        controller.StartIndicator(message: kLoading_Getting_OTP)
       
        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) { (verificationID, error) in
            if let error = error
            {
                controller.StopIndicator()
                controller.showAlertMessage(titleStr: kAppName, messageStr: error.localizedDescription)
                return
            }
            else
            {
                controller.StopIndicator()
                completionHandler(verificationID ?? "")
            }
        }
    }
    
    class func verify_number_from_firebase(controller:UIViewController,verifID:String,OTP:String, completionHandler: @escaping (String) -> Void)
    {
        controller.StartIndicator(message: kVerifying)
        let credential = PhoneAuthProvider.provider().credential(withVerificationID: verifID,verificationCode: OTP)
        
        Auth.auth().signIn(with: credential) { (authResult, error) in
            if let error = error
            {
                controller.StopIndicator()
                controller.showAlertMessage(titleStr: kAppName, messageStr: error.localizedDescription)
                return
            }
            else
            {
               controller.StopIndicator()
               completionHandler("verified")
            }
        }
    }
}

