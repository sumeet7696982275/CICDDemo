//
//  AlertVC.swift
//  DriverDeliveryApp
//
//  Created by Navaldeep Kaur on 06/03/21.
//  Copyright © 2021 Navaldeep Kaur. All rights reserved.
//

import UIKit

protocol AlertDelegate:class {
    func startCompleteJobAction(url:URL,otp:String,isStart:Bool)
    
}

class AlertVC: CustomController {
    
    //MARK:- Outlet and variables
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var viewOTP: CustomUIView!
    @IBOutlet weak var viewUploadImage: CustomUIView!
    @IBOutlet weak var btnUpload: UIButton!
    @IBOutlet weak var btnDone: CustomButton!
    @IBOutlet weak var txtOtp: UITextField!
    
    var profileImage : URL?
    var isStartJob : Bool?
    var alertDelegate:AlertDelegate?
    var tap: UITapGestureRecognizer!
    
    let validString = NSCharacterSet(charactersIn: "!₹@#$%^&*()_+{}[]|\"<>,.~`/:;?-=\\¥'£•¢.")
    
    //MARK:- lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imgView.CornerRadius(radius: 8)
        tap = UITapGestureRecognizer(target: self, action: #selector(dismissView))
        view.addGestureRecognizer(tap)
        
        if isStartJob == true{
            viewOTP.isHidden = true
            viewUploadImage.isHidden = false
            btnDone.isHidden = true
        }else{
            viewOTP.isHidden = false
            btnDone.isHidden = true
            viewUploadImage.isHidden = true
        }
        
    }
    
    //MARK:- Actions
    
    @objc func dismissView() {
        self.dismiss(animated: false, completion: nil)
        self.view.removeGestureRecognizer(tap)
    }
    
    @IBAction func OkActionOTP(_ sender: Any) {
        guard let otp = txtOtp.text,  !otp.isEmpty, !otp.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else
        {
            self.showAlertMessage(titleStr: kAppName, messageStr: "Enter OTP")
            return
        }
        viewOTP.isHidden = true
        viewUploadImage.isHidden = false
    }
    @IBAction func uploadImage(_ sender: Any) {
       // OpenGalleryCamera(camera: true, imagePickerDelegate: self, isVideoAlso: false)
        self.OpenCamera(imagePickerDelegate: self, isVideoAlso: false)

    }
    @IBAction func doneActionUpload(_ sender: Any) {
        self.alertDelegate?.startCompleteJobAction(url: profileImage!, otp: txtOtp.text ?? "", isStart: isStartJob ?? false)
        self.dismiss(animated: false, completion: nil)
    }
    
}

//MARK:- UIImagePickerDelegate
extension AlertVC: UIImagePickerDelegate
{
    func SelectedMedia(image: UIImage?, imageURL: URL?, videoURL: URL?)
    {
        imgView.contentMode = .scaleAspectFill
        imgView.image = image
        btnDone.isHidden = false
        btnUpload.isHidden = true
    }
    
    func selectedImageUrl(url: URL)
    {
        profileImage = url
    }
    
    func cancelSelectionOfImg()
    {
        
    }
}

//MARK:- TextFeild Delegate
extension AlertVC:UITextFieldDelegate
{
    func textFieldShouldClear(_ textField: UITextField) -> Bool
    {
        return true;
    }
        
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
         if textField == txtOtp{
                 self.txtOtp.resignFirstResponder()
               }
               return true;
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        if (string == " ") && (textField.text?.count)! == 0
        {
            return false
        }
        
        if let _  = string.rangeOfCharacter(from: validString as CharacterSet)//rangeOfCharacterFromSet(validString)
        {
            return false
        }
        
        return true
    }
}
