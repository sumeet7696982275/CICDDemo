//
//  SignupVC.swift
//  CourierApp
//
//  Created by Mohit Sharma on 9/24/20.
//  Copyright © 2020 Cerebrum Infotech. All rights reserved.
//

import UIKit
import ValidationTextField
import CountryPickerView

class SignupVC: CustomController,UITextFieldDelegate
{

    @IBOutlet weak var lblVendorLicense: UILabel!
    @IBOutlet var btnLicenseBack: UIButton!
    @IBOutlet var btnLicenseFront: UIButton!
    @IBOutlet var btnImage: CustomButton!
    @IBOutlet var viewContent: UIView!
    @IBOutlet var viewheader: UIView!
    @IBOutlet var btnCode: UIButton!
    @IBOutlet var viewBase: UIView!
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var tfFirstName: ValidationTextField!
    @IBOutlet var tfLastName: ValidationTextField!
    @IBOutlet var tfEmail: ValidationTextField!
    @IBOutlet var tfPhoneNumber: ValidationTextField!
   // @IBOutlet var tfPassword: ValidationTextField!
   // @IBOutlet var tfCPassword: ValidationTextField!
    @IBOutlet var tfRegis: ValidationTextField!
    @IBOutlet weak var tfCompCode: ValidationTextField!
    
    @IBOutlet var ivTerms: UIImageView!
    @IBOutlet var btnTerms: UIButton!
    @IBOutlet var btnSignup: CustomButton!
    
    var prefilledData = NSMutableDictionary()
    var approach = ""
    var socialUserID = ""
    var socialType = ""
    var paymentList = [PaymentBody?]()
    let maxLength = 13
    var paymentSelected = [String]()
    
    let countryPickerView = CountryPickerView()
    private var selectedPicker: ImagePickers?
    
    var profileImageUrl : URL?
    var licnseFront : URL?
    var licnseBack : URL?
    
    @IBOutlet weak var heightCollection: NSLayoutConstraint!
    var profileImg = UIImage()
    var licnseFrontImg = UIImage()
    var licnseBacjkImg = UIImage()
    
    
    var viewModel:SignupVC_ViewModel?
    var validDic = ["lName":false,"fname":false,"email":false,"phone":false]
    var lang = "en"
    
    
    
    
    enum ImagePickers
    {
        case Profile
        case LicenceFront
        case LicenceBack
        
        init()
        {
            self = .Profile
            self = .LicenceFront
            self = .LicenceBack
        }
    }
    
    var isValid: Bool?
    {
        didSet
        {
           // btnSignup.isEnabled = isValid ?? false
           // btnSignup.backgroundColor = isValid ?? false ? Appcolor.kThemeColorButtons : .lightGray
        }
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.viewModel = SignupVC_ViewModel.init(view: self)
        self.viewModel?.validateEntries()
        self.viewModel?.setUI()
        // self.viewModel?.callAPI_GetPaymentList()

    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        
    }

    @IBAction func ACTION_MOVEBACK(_ sender: Any)
    {
        self.moveBACK(controller: self)
    }
    
    
    
    
    @IBAction func acnChooseImage(_ sender: Any)
    {
        selectedPicker = ImagePickers.Profile
        OpenGalleryCamera(camera: true, imagePickerDelegate: self, isVideoAlso: false)
    }
    
    @IBAction func acnChooseImageLiceFront(_ sender: Any)
    {
        selectedPicker = ImagePickers.LicenceFront
        OpenGalleryCamera(camera: true, imagePickerDelegate: self, isVideoAlso: false)
    }
    
    @IBAction func acnChooseImageLiceBack(_ sender: Any)
    {
        selectedPicker = ImagePickers.LicenceBack
        OpenGalleryCamera(camera: true, imagePickerDelegate: self, isVideoAlso: false)
    }
    
    @IBAction func acnAcceptTerms(_ sender: Any)
    {
        if(btnTerms.tag == 0)
        {
            btnTerms.tag = 1
            self.ivTerms.image = UIImage(named:"TickImg")
        }
        else if (btnTerms.tag == 1)
        {
            btnTerms.tag = 0
            self.ivTerms.image = UIImage(named:"unTick")
        }
    }
    
    @IBAction func acnChooseCode(_ sender: Any)
    {
        countryPickerView.showCountriesList(from: self)
    }
    
    
    @IBAction func acnSignup(_ sender: Any)
    {
        self.viewModel?.validateFields()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        if(textField == self.tfPhoneNumber)
        {
            let currentString: NSString = (textField.text ?? "") as NSString
            let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
        }
        if(textField == self.tfEmail)
        {
            if(string == " ")
            {
                return false
            }
            
            return true
        }
        return true
    }
   
}

//MARK:- UIImagePickerDelegate
extension SignupVC: UIImagePickerDelegate
{
    func SelectedMedia(image: UIImage?, imageURL: URL?, videoURL: URL?)
    {
        switch selectedPicker
        {
        case .Profile:
            
            self.profileImageUrl = imageURL
            self.profileImg = image!
            self.btnImage.setImage(image, for: .normal)
            self.btnImage.cornerRadius = 65
            self.btnImage.layer.masksToBounds = true
            
        case .LicenceFront:
            btnLicenseFront.setTitle("", for: .normal)

            self.licnseFront =  imageURL
            self.licnseFrontImg = image!
            self.btnLicenseFront.setImage(image, for: .normal)
            break
        case .LicenceBack:
            btnLicenseBack.setTitle("", for: .normal)
            self.licnseBack = imageURL
            self.licnseBacjkImg = image!
            self.btnLicenseBack.setImage(image, for: .normal)
            
            break
        default: break
            
        }
    }
    
    func selectedImageUrl(url: URL)
    {
        
    }
    
    func cancelSelectionOfImg()
    {
        
    }
}

