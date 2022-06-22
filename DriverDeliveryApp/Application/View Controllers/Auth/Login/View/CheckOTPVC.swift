//
//  CheckOTPVC.swift
//  DriverDeliveryApp
//
//  Created by Navaldeep Kaur on 30/04/20.
//  Copyright © 2020 Navaldeep Kaur. All rights reserved.
//


import UIKit
import SVPinView
import FirebaseAuth
import Firebase

class CheckOTPVC: CustomController
{
    
    //MARK:- OUTLETS -->
    @IBOutlet var lblTitleDESC: UILabel!
    @IBOutlet var btnResendOTP: UIButton!
    @IBOutlet var lblOTP: UILabel!
    @IBOutlet var myPinView: SVPinView!
    @IBOutlet var btnProceed: CustomButton!
    @IBOutlet var lblTimer: UILabel!
    @IBOutlet var lblTimerDesc: UILabel!
    
    //MARK:- VARIABLES -->
    var viewModel:LoginWithPhone_ViewModel?
    var otp = ""
    var phoneNumber = ""
    var countryCode = ""
    var push_approach = ""
    var myTimer = Timer()
    var count  = 0
    var count_reverse  = 60
    var userData : SignIn_ResponseModel?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.set_controller_UI()
        self.hideKeyboardWhenTappedAround()
        self.btnProceed.isEnabled = false
        self.myPinView.isContentTypeOneTimeCode = true
        self.setUI()
       
        myPinView.style = .box
      
       
//        myPinView.didFinishCallback = { pin in
//            print("The pin entered is \(pin)")
//            self.btnProceed.isEnabled = true
//            self.otp = pin
//          //  self.btnProceed.backgroundColor = Appcolor.kThemeColor
//        }
        
        myPinView.didChangeCallback = { pin in
            self.btnProceed.isEnabled = false
        }
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        self.stop_timer()
       // self.btnProceed.backgroundColor = Appcolor.kGray
    }
    
    
    //MARK:- BUTTON ACTIONS -->
    @IBAction func ACTION_RESEND_OTP(_ sender: Any)
    {
        self.myPinView.clearPin()
        self.resend_OTP()
    }
    
    @IBAction func ACTION_MOVEBACK(_ sender: Any)
    {
        self.moveBACK(controller: self)
    }
    
    @IBAction func ACTION_PRCEED(_ sender: Any)
    {
        self.hideKeyboard()
        self.stop_timer()
        FirbaseOTPAuth.verify_number_from_firebase(controller: self, verifID: AppDefaults.shared.firebaseVID, OTP: self.otp)
        { (result) in
                        //go to root screen
            
            AppDefaults.shared.userName = (self.userData?.body?.firstName ?? "") + (self.userData?.body?.lastName ?? "")
            AppDefaults.shared.userFirstName = self.userData?.body?.firstName ?? ""
            AppDefaults.shared.userLastName = self.userData?.body?.lastName ?? ""
            AppDefaults.shared.userJWT_Token = self.userData?.body?.sessionToken ?? ""
            AppDefaults.shared.userEmail = self.userData?.body?.email ?? ""
            AppDefaults.shared.userPhoneNumber = "\(self.userData?.body?.phoneNumber ?? "")"
            AppDefaults.shared.userCountryCode = self.userData?.body?.countryCode ?? ""
            AppDefaults.shared.userID = self.userData?.body?.id ?? "0"
            AppDefaults.shared.ID = self.userData?.body?.id ?? "0"
            AppDefaults.shared.userImage = self.userData?.body?.image ?? ""
             AppDefaults.shared.CompanyID = self.userData?.body?.companyId ?? ""
            
            configs.kAppdelegate.setRootViewController()
        }
        
    }
    
    //MARK:- FUNCTION RESEND OTP -->
    func resend_OTP()
    {
        FirbaseOTPAuth.get_otp_from_firebase(controller: self, phoneNumber: "+"+self.countryCode + phoneNumber)
        { (result) in
            if (result.count > 0)
            {
                AppDefaults.shared.firebaseVID = result
                self.showAlertMessage(titleStr: kAppName, messageStr: "OTP has been sent on given number")
                self.Handle_Resend_OTP_Start_timer()
                self.myTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.startTimer), userInfo: nil, repeats: true)
                RunLoop.main.add(self.myTimer, forMode: RunLoop.Mode.common)
            }
        }
    }
    
    
    
    //MARK:- UI SETUP -->
    func set_controller_UI()
    {
        self.viewModel = LoginWithPhone_ViewModel.init(view: self)
      //  self.btnProceed.backgroundColor = Appcolor.kThemeColor
      //  self.btnProceed.setTitleColor(Appcolor.kTextColorWhite, for: UIControl.State.normal)
        self.btnResendOTP.setTitleColor(Appcolor.kThemeColor, for: UIControl.State.normal)
        self.lblOTP.textColor = Appcolor.kTextColorBlack
        self.lblTimer.textColor = Appcolor.kThemeColor
        self.lblTimerDesc.textColor = Appcolor.kTextColorBlack
        self.lblTitleDESC.textColor = Appcolor.kTextColorBlack
        
    }
    
    func setUI()
    {
      //  self.setStatusBarColor(view: self.view, color: Appcolor.kThemeColorStatus)
      //  AllUtilies.CameraGallaryPrmission()
        self.hideKeyboardWhenTappedAround()
        
        myPinView.didFinishCallback = { pin in
            print("The pin entered is \(pin)")
            self.otp = pin
            self.hideKeyboard()
             self.stop_timer()
            self.btnProceed.isEnabled = true

            
              FirbaseOTPAuth.verify_number_from_firebase(controller: self, verifID: AppDefaults.shared.firebaseVID, OTP: self.otp)
                    { (result) in
                                    //go to root screen
                        
                        AppDefaults.shared.userName = (self.userData?.body?.firstName ?? "") + (self.userData?.body?.lastName ?? "")
                        AppDefaults.shared.userFirstName = self.userData?.body?.firstName ?? ""
                        AppDefaults.shared.userLastName = self.userData?.body?.lastName ?? ""
                        AppDefaults.shared.userJWT_Token = self.userData?.body?.sessionToken ?? ""
                        AppDefaults.shared.userEmail = self.userData?.body?.email ?? ""
                        AppDefaults.shared.userPhoneNumber = "\(self.userData?.body?.phoneNumber ?? "")"
                        AppDefaults.shared.userCountryCode = self.userData?.body?.countryCode ?? ""
                        AppDefaults.shared.userID = self.userData?.body?.id ?? "0"
                        AppDefaults.shared.ID = self.userData?.body?.id ?? "0"
                        AppDefaults.shared.userImage = self.userData?.body?.image ?? ""
                         AppDefaults.shared.CompanyID = self.userData?.body?.companyId ?? ""
                        
                        configs.kAppdelegate.setRootViewController()
                    }
        }
        
        myPinView.didChangeCallback = { pin in
        }
    }
    
    @objc func startTimer()
    {
        self.count = self.count+1
        self.count_reverse = self.count_reverse-1
        self.lblTimer.text = "\(self.formatSecondsToString(TimeInterval(self.count_reverse)))"
        if (self.count >= 60)
        {
            self.myTimer.invalidate()
            self.stop_timer()
        }
        
    }
    
    func formatSecondsToString(_ seconds: TimeInterval) -> String
    {
        if seconds.isNaN
        {
            return "00:00"
        }
        let Min = Int(seconds / 60)
        let Sec = Int(seconds.truncatingRemainder(dividingBy: 60))
        return String(format: "%02d:%02d", Min, Sec)
    }
    
    func Handle_Resend_OTP_Start_timer()
    {
        self.lblTimer.text = "00:00"
        self.btnResendOTP.isHidden = true
        self.lblTimer.isHidden = false
        self.lblTimerDesc.isHidden = false
    }
    func stop_timer()
    {
        self.lblTimer.text = "00:00"
        self.btnResendOTP.isHidden = false
        self.lblTimer.isHidden = true
        self.lblTimerDesc.isHidden = true
    }
    
}

