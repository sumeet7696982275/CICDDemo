//
//  SignupViewModel.swift
//  CourierApp
//
//  Created by Mohit Sharma on 9/24/20.
//  Copyright © 2020 Cerebrum Infotech. All rights reserved.
//

import Foundation
import ValidationTextField
import CountryPickerView

class SignupVC_ViewModel
{
    var view : SignupVC
    
    init(view : SignupVC)
    {
        self.view = view
    }
    
    func Signup(Params : [String:Any])
    {
        self.view.view.endEditing(true)
        WebService.Shared.uploadData_Multiple(mediaType:.Image, url: APIAddress.SIGNUP, postdatadictionary: Params, Target: view, completionResponse: { response in
            Commands.println(object: response as Any)
            
            do
            {
                let jsonData = try JSONSerialization.data(withJSONObject: response, options: .prettyPrinted)
                let model = try JSONDecoder().decode(SignupModel.self, from: jsonData)
                
                if(model.code == 200)
                {
                    self.view.showToastSwift(alrtType: .statusGreen, msg: "Your account is created successfully!", title: "")
                    let controller = Navigation.GetInstance(of: .LoginWithPhoneVC) as! LoginWithPhoneVC
                    self.view.push_To_Controller(from_controller: self.view, to_Controller: controller)
                }
                else
                {
                    self.view.showToastSwift(alrtType: .error, msg: model.message, title: kOops)
                }
                
                
//                let phone = (self.view.btnCode.titleLabel?.text ?? "") + (self.view.tfPhoneNumber.text ?? "")
//                 self.get_otp_from_firebase(phoneNumber:phone, data: model.body)
//
//                var parm = [String:Any]()
//                parm["sessionToken"] = model.body.sessionToken
//                parm["userId"] = model.body.id
//
//                AppDefaults.shared.userJWT_Token = model.body.sessionToken ?? ""
               // self.verifyUserAfterSignupAndOTP(Params : parm, Data: model.body)
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
    
    
    
    func validateEntries()
    {
        self.view.tfEmail.validCondition = {$0.count > 3 && $0.contains("@") && $0.contains(".")}
        self.view.tfFirstName.validCondition = {$0.count > 2}
        self.view.tfLastName.validCondition = {$0.count > 2}
        self.view.tfPhoneNumber.validCondition = {$0.count >= 10}
        
        //        self.view.tfPassword.validCondition = {$0.count > 5}
        //        self.view.tfCPassword.validCondition =
        //        {
        //                guard let password = self.view.tfPassword.text else
        //                {
        //                    return false
        //                }
        //                return $0 == password
        //        }
        
        self.view.tfFirstName.successImage = UIImage(named: "success")
        self.view.tfFirstName.errorImage = UIImage(named: "error")
        
        self.view.tfLastName.successImage = UIImage(named: "success")
        self.view.tfLastName.errorImage = UIImage(named: "error")
        
        self.view.tfPhoneNumber.successImage = UIImage(named: "success")
        self.view.tfPhoneNumber.errorImage = UIImage(named: "error")
        
        self.view.tfEmail.successImage = UIImage(named: "success")
        self.view.tfEmail.errorImage = UIImage(named: "error")
        
        //  self.view.tfPassword.successImage = UIImage(named: "success")
        //  self.view.tfPassword.errorImage = UIImage(named: "error")
        
        //  self.view.tfCPassword.successImage = UIImage(named: "success")
        //  self.view.tfCPassword.errorImage = UIImage(named: "error")
        
        self.view.tfEmail.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        self.view.tfFirstName.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        self.view.tfLastName.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        self.view.tfPhoneNumber.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        //  self.view.tfPassword.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        //  self.view.tfCPassword.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        //  self.view.btnSignup.backgroundColor = Appcolor.kGray
    }
    
    
    @objc func textFieldDidChange(_ textfield: UITextField)
    {
        let tf = textfield as! ValidationTextField
        
        switch tf
        {
        case self.view.tfFirstName:
            self.view.validDic["fname"] = tf.isValid
            
        case self.view.tfLastName:
            self.view.validDic["lName"] = tf.isValid
            
        case self.view.tfEmail:
            self.view.validDic["email"] = tf.isValid
            
        case self.view.tfPhoneNumber:
            self.view.validDic["phone"] = tf.isValid
            
            //  case self.view.tfPassword:
            //      self.view.validDic["password"] = tf.isValid
            
            //  case self.view.tfCPassword:
            //      self.view.validDic["cpassword"] = tf.isValid
            
        default:
            break
        }
        
        self.view.isValid = self.view.validDic.reduce(true){ $0 && $1.value}
    }
    
    func validatePrefilledTextFields()
    {
        self.view.validDic["fname"] = self.view.tfFirstName.isValid
        self.view.validDic["lName"] = self.view.tfLastName.isValid
        self.view.validDic["email"] = self.view.tfEmail.isValid
        self.view.validDic["phone"] = self.view.tfPhoneNumber.isValid
        // self.view.validDic["password"] = self.view.tfPassword.isValid
        // self.view.validDic["cpassword"] = self.view.tfCPassword.isValid
        
        self.view.isValid = self.view.validDic.reduce(true){ $0 && $1.value}
    }
    
    func validateFields()
    {
        if(self.view.profileImageUrl == nil)
        {
            self.view.btnSignup.shake()
            self.view.showToastSwift(alrtType: .statusRed, msg: "Please add your profile image and fill all details", title: "")
        }
        else if self.view.tfFirstName.text?.count ?? 0 == 0
        {
            self.view.btnSignup.shake()
            self.view.showToastSwift(alrtType: .statusRed, msg: AlertTitles.CheckFName, title: "")
        }
        else if self.view.tfLastName.text?.count ?? 0  == 0
        {
            self.view.btnSignup.shake()
            self.view.showToastSwift(alrtType: .statusRed, msg: AlertTitles.CheckLName, title: "")
        }
        else if self.view.tfEmail.text?.count ?? 0  == 0
        {
            self.view.btnSignup.shake()
            self.view.showToastSwift(alrtType: .statusRed, msg: AlertTitles.CheckEmail, title: "")
        }
        else if self.view.btnCode.titleLabel?.text?.count ?? 0  == 0
        {
            self.view.btnSignup.shake()
            self.view.showToastSwift(alrtType: .statusRed, msg: AlertTitles.CheckCountryCode, title: "")
        }
        else if self.view.tfPhoneNumber.text?.count ?? 0  == 0
        {
            self.view.btnSignup.shake()
            self.view.showToastSwift(alrtType: .statusRed, msg: AlertTitles.CheckPhone, title: "")
        }
        else if self.view.tfPhoneNumber.text?.count ?? 0 < 10
        {
            self.view.btnSignup.shake()
            self.view.showToastSwift(alrtType: .statusRed, msg: AlertTitles.CheckPhone, title: "")
        }
        else if self.view.tfRegis.text?.count ?? 0 == 0
        {
            self.view.btnSignup.shake()
            self.view.showToastSwift(alrtType: .statusRed, msg: "Please enter vehicle registration number", title: "")
        }
//        else if self.view.tfCompCode.text?.count ?? 0 == 0
//        {
//            self.view.btnSignup.shake()
//            self.view.showToastSwift(alrtType: .statusRed, msg: "Please enter company code", title: "")
//        }
        
//        else if self.view.paymentSelected.count == 0{
//            self.view.btnSignup.shake()
//            self.view.showToastSwift(alrtType: .statusRed, msg: AlertTitles.CheckPaymentType, title: "")
//        }
        else if(self.view.licnseFront == nil)
        {
            self.view.btnSignup.shake()
            self.view.showToastSwift(alrtType: .statusRed, msg: "Please add image for driving license front side", title: "")
        }
        else if(self.view.licnseBack == nil)
        {
            self.view.btnSignup.shake()
            self.view.showToastSwift(alrtType: .statusRed, msg: "Please add image for driving license back side", title: "")
        }
        else if self.view.btnTerms.tag == 0
        {
            self.view.btnSignup.shake()
            self.view.showToastSwift(alrtType: .statusRed, msg: AlertTitles.AcceptTerms, title: "")
        }
        else
        {
            var parm = [String:Any]()
            
            let socialTyp = self.view.prefilledData.value(forKey: "socialType") ?? ""
            let socialID = self.view.prefilledData.value(forKey: "userID") ?? ""
            
            parm["firstName"] = self.view.tfFirstName.text
            parm["lastName"] = self.view.tfLastName.text
            parm["email"] = self.view.tfEmail.text
            parm["phoneNumber"] = self.view.tfPhoneNumber.text
            parm["countryCode"] = self.view.btnCode.titleLabel?.text
            parm["email"] = self.view.tfEmail.text
            
            parm["regNo"] = self.view.tfRegis.text
            
            
            if(self.view.approach == "socialLogin")//sign up user from social login
            {
                parm["isSocial"] = true
            }
            else
            {
                parm["isSocial"] = false
            }
            
            
            parm["socialType"] = socialTyp
            //parm["deviceToken"] = AppDefaults.shared.userDeviceToken
            parm["deviceToken"] = AppDefaults.shared.firebaseToken
            parm["platform"] = "ios"
            parm["socialId"] = socialID
            
            
            var mediaObjs = [[String:Any]]()
            
            //Profile Photo
            var mediaObj = [String:Any]()
            mediaObj["fileType"] = "Image"
            mediaObj["url"] = self.view.profileImageUrl
            mediaObj["imageData"] = self.view.profileImg
            mediaObj["imageKey"] = "profileImage"
            
            mediaObjs.insert(mediaObj, at: 0)
            
            //License Front
            if(self.view.licnseFront != nil)
            {
                //License Front
                var mediaObjLiceFront = [String:Any]()
                mediaObjLiceFront["fileType"] = "Image"
                mediaObjLiceFront["url"] = self.view.licnseFront
                mediaObjLiceFront["imageData"] = self.view.licnseFrontImg
                mediaObjLiceFront["imageKey"] = "licenseFront"
                
                mediaObjs.insert(mediaObjLiceFront, at: 1)
            }
            
            //License Back
            if(self.view.licnseBack != nil)
            {
                //License Back
                var mediaObjLiceBack = [String:Any]()
                mediaObjLiceBack["fileType"] = "Image"
                mediaObjLiceBack["url"] = self.view.licnseBack
                mediaObjLiceBack["imageData"] = self.view.licnseBacjkImg
                mediaObjLiceBack["imageKey"] = "licenseBack"
                
                mediaObjs.insert(mediaObjLiceBack, at: 2)
            }
            
            parm["images"] = mediaObjs
             
         //   parm["code"] = self.view.tfCompCode.text
            parm["code"] = "ADMGHI"
            
            self.Signup(Params : parm)
            
        }
    }
    
    
    func setUI()
    {
        self.view.lblTitle.textColor = Appcolor.kThemeColor
        self.view.lblTitle.text = "Signup"
        self.view.btnSignup.setTitleColor(.white, for: .normal)
        self.view.btnSignup.backgroundColor = Appcolor.kThemeColor
        self.view.btnCode.setTitleColor(Appcolor.kThemeColor, for: .normal)
        self.view.setStatusBarColor(view: self.view.view, color: Appcolor.kThemeColor)
        self.view.btnLicenseBack.setTitle("Back", for: .normal)
        self.view.btnLicenseFront.setTitle("Front", for: .normal)

        
        self.view.countryPickerView.delegate = self.view
        let country = self.view.countryPickerView.selectedCountry
        self.view.btnCode.setTitle(country.phoneCode, for: .normal)
        
        
        if(self.view.approach == "socialLogin")//sign up user from social login
        {
            self.view.tfFirstName.text = self.view.prefilledData.value(forKey: "fname")as? String ?? ""
            self.view.tfLastName.text = self.view.prefilledData.value(forKey: "lname")as? String ?? ""
            self.view.tfEmail.text = self.view.prefilledData.value(forKey: "email")as? String ?? ""
            self.view.socialUserID = self.view.prefilledData.value(forKey: "userID")as? String ?? ""
            self.view.socialType = self.view.prefilledData.value(forKey: "socialType")as? String ?? ""
            
            //  self.view.tfPassword.text = self.view.prefilledData.value(forKey: "userID")as? String ?? ""
            //  self.view.tfCPassword.text = self.view.prefilledData.value(forKey: "userID")as? String ?? ""
            
            //  self.view.tfPassword.isUserInteractionEnabled = false
            //  self.view.tfCPassword.isUserInteractionEnabled = false
            
            self.validatePrefilledTextFields()
        }
        
        self.view.viewheader.roundCorners_BottomLeftRight(val:30)
        self.view.viewContent.roundCorners(val:30)
        self.view.viewheader.backgroundColor = Appcolor.kThemeColor
    }
    
    func get_otp_from_firebase(phoneNumber:String,data:SignupBody)
    {
        FirbaseOTPAuth.get_otp_from_firebase(controller: self.view, phoneNumber: phoneNumber) { (result) in
            
            
            if (result.count > 0)
            {
                AppDefaults.shared.firebaseVID = result
                AppDefaults.shared.userJWT_Token = data.sessionToken ?? ""
                
                //go to otp screen
//                let controller = Navigation.GetInstance(of: .OTPVC)as! OTPVC
//                controller.signupData = data
//                controller.approach = "signup"
//                controller.countryCode = self.view.btnCode.titleLabel?.text ?? ""
//                controller.phoneNumber = self.view.tfPhoneNumber.text ?? ""
//                self.view.pushToController(from_controller: self.view, to_Controller: controller)
            }
            
        }
    }
    
    func verifyUserAfterSignupAndOTP(Params : [String:Any],Data:SignupBody)
    {
        
//        WebService.Shared.PostApi(url: APIAddress.VERIFY_VENDOR, parameter: Params, showLoader: true, Target: self.view, completionResponse: { response in
//
//            Commands.println(object: response)
//
//            if let responseData = response as? NSDictionary
//            {
//                let code = responseData.value(forKey: "code") as? Int ?? 0
//                let msg = responseData.value(forKey: "message") as? String ?? "success"
//
//                if (code == 200)
//                {
//                    self.setUserDataSignup(data:Data)
//                }
//                else
//                {
//                    self.view.showToastSwift(alrtType: .error, msg: msg, title: "")
//                }
//            }
//            else
//            {
//                self.view.showToastSwift(alrtType: .error, msg: kResponseNotCorrect, title: kOops)
//            }
//
//        }, completionnilResponse: {(error) in
//            self.view.showToastSwift(alrtType: .error, msg: error, title: kOops)
//        })
        
    }
    
    func setUserDataSignup(data:SignupBody)
    {
        DispatchQueue.main.async {
            AppDefaults.shared.userName = (data.firstName ?? "") + (data.lastName ?? "")
            AppDefaults.shared.userFirstName = data.firstName ?? ""
            AppDefaults.shared.userLastName = data.lastName ?? ""
            AppDefaults.shared.userJWT_Token = data.sessionToken ?? ""
            AppDefaults.shared.userEmail = data.email ?? ""
            AppDefaults.shared.userPhoneNumber = self.view.tfPhoneNumber.text!
            AppDefaults.shared.userCountryCode = self.view.btnCode.titleLabel!.text!
            AppDefaults.shared.userID = data.id ?? "0"
            AppDefaults.shared.userImage = data.image ?? ""
            
            
            self.view.showToastSwift(alrtType: .success, msg: "Welcome" + (AppDefaults.shared.userFirstName.capitalizingFirstLetter())  + (AppDefaults.shared.userLastName.capitalizingFirstLetter()), title: "")
            configs.kAppdelegate.setRootViewController()
        }
    }
    
    
    
    
}

extension SignupVC:CountryPickerViewDelegate
{
    func countryPickerView(_ countryPickerView: CountryPickerView, didSelectCountry country: Country)
    {
        let country = countryPickerView.selectedCountry
        self.btnCode.setTitle(country.phoneCode, for: .normal)
    }
}

