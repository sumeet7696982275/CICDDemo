//
//  LoginWithPhoneVC.swift
//  DriverDeliveryApp
//
//  Created by Navaldeep Kaur on 30/04/20.
//  Copyright © 2020 Navaldeep Kaur. All rights reserved.
//


import UIKit
import FirebaseAuth
import Firebase
import CountryPickerView


class LoginWithPhoneVC: CustomController
{
    
    //MARK:- OUTLETS -->
    @IBOutlet var btnProceed: CustomButton!
    @IBOutlet weak var txtFldForCountryCode: CustomTextField!
    @IBOutlet var txtFldPhone: CustomTextField!
    @IBOutlet weak var loginImgView: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    //MARK:- VARIABLES -->
    var ACCEPTABLE_CHARACTERS_Phone = "1234567890 "
    let countryPickerView = CountryPickerView()
    var push_approach = ""
    var viewModel:LoginWithPhone_ViewModel?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        setUpView()
        
        if (AppDefaults.shared.showTutorial == "0")
        {
            AppDefaults.shared.showTutorial = "1"
            let controller = Navigation.GetInstance(of: .AppTutorailVC)as! AppTutorailVC
            controller.approach = "tabs"
            self.navigationController?.present(controller, animated: true, completion: nil)
        }
        
        if AppDefaults.shared.userID == "0"
        {
            // self.setRootView("LoginWithPhoneVC", storyBoard: "Main")
        }
        else
        {
            self.setRootView("SWRevealViewController", storyBoard: "Home")
        }
    }
    
    func setUpView()
    {
        //         let vc = UIStoryboard.init(name: "Home", bundle: Bundle.main).instantiateViewController(withIdentifier: "HomeScreenVC") as? HomeScreenVC
        //        self.navigationController?.pushViewController(vc!, animated: true)
        Location.shared.InitilizeGPS()
        self.set_controller_UI()
        self.hideKeyboardWhenTappedAround()
        self.hideNAV_BAR(controller: self)
        txtFldPhone.addDoneButtonToKeyboard(target:self,myAction:  #selector(self.doneButtonAction), Title: kDone)
        countryPickerView.delegate = self
        let country = countryPickerView.selectedCountry
        txtFldForCountryCode.text = country.phoneCode
       // loginImgView.image = UIImage(named: "deliveryIcon")
        txtfieldPadding(textField: txtFldPhone)
        
       // btnProceed.backgroundColor = Appcolor.kThemeColor
        
    }
    
    @IBAction func acnSignup(_ sender: Any)
    {
        let controller = Navigation.GetInstance(of: .SignupVC) as! SignupVC
        self.push_To_Controller(from_controller: self, to_Controller: controller)
    }
    
    
    @objc func doneButtonAction()
    {
        self.txtFldPhone.resignFirstResponder()
    }
    
    
    //MARK:- BUTTON ACTIONS -->
    @IBAction func SubmitAction(_ sender: UIButton)
    {
        if txtFldPhone.text!.count > 12
        {
            showAlertMessage(titleStr: kAppName, messageStr: AlertTitles.Phone_digits_exceeded)
            sender.shake()
        }
        else if txtFldPhone.text!.count == 0
        {
            showAlertMessage(titleStr: kAppName, messageStr: AlertTitles.Enter_phone_number)
            sender.shake()
        }
        else if txtFldPhone.text!.count < 10
        {
            showAlertMessage(titleStr: kAppName, messageStr: AlertTitles.EnterValid_phone_number)
            sender.shake()
        }
        else
        {
            var countryCode = self.txtFldForCountryCode.text!.replacingOccurrences(of: "+", with: "", options:
                NSString.CompareOptions.literal, range: nil)
            print(countryCode.trimmingCharacters(in: .whitespacesAndNewlines))
            // checking if number is exist or not in our server side
            self.viewModel?.SignIn(phoneNumber: self.txtFldPhone.text!, countryCode: countryCode.trimmingCharacters(in: .whitespacesAndNewlines))
        }
        
    }
    
    @IBAction func CountryCode(_ sender: Any)
    {
        countryPickerView.showCountriesList(from: self)
    }
    
}

extension LoginWithPhoneVC:UITextFieldDelegate
{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        if textField == txtFldPhone
        {
            let cs = NSCharacterSet(charactersIn: ACCEPTABLE_CHARACTERS_Phone).inverted
            let filtered = string.components(separatedBy: cs).joined(separator: "")
            return (string == filtered)
        }
        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        self.view.endEditing(true)
        return true
    }
}

extension LoginWithPhoneVC:CountryPickerViewDelegate
{
    func countryPickerView(_ countryPickerView: CountryPickerView, didSelectCountry country: Country)
    {
        let country = countryPickerView.selectedCountry
        txtFldForCountryCode.text = country.phoneCode
    }
}

extension LoginWithPhoneVC
{
    func set_controller_UI()
    {
        self.viewModel = LoginWithPhone_ViewModel.init(view: self)
        self.txtFldPhone.backgroundColor = Appcolor.kTextColorWhite
        self.txtFldForCountryCode.backgroundColor = Appcolor.kTextColorWhite
       // self.btnProceed.backgroundColor = Appcolor.kThemeColor
        self.lblTitle.textColor = Appcolor.kThemeColor
        self.btnProceed.setTitleColor(Appcolor.kThemeColor, for: UIControl.State.normal)
        //addShadowToTextField(textField: txtFldPhone)
        // addShadowToTextField(textField: txtFldForCountryCode)
       // txtFldPhone.setUnderLine()
       // txtFldForCountryCode.setUnderLine() 
        txtfieldPadding(textField: txtFldPhone)
        
    }
}


