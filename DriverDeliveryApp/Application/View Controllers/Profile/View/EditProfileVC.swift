//
//  EditProfileVC.swift
//  Fleet Management
//
//  Created by Mohit Sharma on 2/26/20.
//  Copyright © 2020 Seasia Infotech. All rights reserved.
//

import UIKit
import TPKeyboardAvoiding
import SDWebImage
import SkyFloatingLabelTextField

class EditProfileVC: CustomController,UIScrollViewDelegate,UITextFieldDelegate
{
    
    let validString = NSCharacterSet(charactersIn: "!₹@#$%^&*()_+{}[]|\"<>,.~`/:;?-=\\¥'£•¢1234567890.")
    
    @IBOutlet weak var btnEditBanner: CustomButton!
    @IBOutlet weak var imageViewBanner: UIImageView!
    @IBOutlet weak var txtIdProof: SkyFloatingLabelTextField!
    @IBOutlet weak var imgViewIdProof: UIImageView!
    @IBOutlet weak var imgViewSelectImage: UIImageView!
    @IBOutlet weak var btnUpdateProfile: UIButton!
    @IBOutlet weak var btnIdProof: UIButton!
    @IBOutlet weak var editButton: UIButton!
    //@IBOutlet weak var editButton: UIBarButtonItem!
    @IBOutlet var scrollView: TPKeyboardAvoidingScrollView!
    @IBOutlet var ivFemale: UIImageView!
    @IBOutlet var ivMale: UIImageView!
    @IBOutlet var tf_firstName: SkyFloatingLabelTextField!
    @IBOutlet var tf_lastName: SkyFloatingLabelTextField!
    @IBOutlet var tf_email: SkyFloatingLabelTextField!
    @IBOutlet var tf_phoneNumber: SkyFloatingLabelTextField!
    @IBOutlet var tf_address: SkyFloatingLabelTextField!
    @IBOutlet var ivProfile: UIImageView!
    @IBOutlet weak var btnDrawer: UIBarButtonItem!
    @IBOutlet var btnProceed: CustomButton!
    @IBOutlet var btnLicenseBack: UIButton!
    @IBOutlet var btnLicenseFront: UIButton!
    
    
    var maleSelected = true
    var viewModel:EditProfile_ViewModel?
    var  localModel : EditProfile_ResponseModel?
    private var selectedPicker: ImagePickers?
    var profileImage : URL?
    var idProofImage : URL?
    var bannerImage : URL?
    var licnseFront : URL?
    var licnseBack : URL?
    
    var licnseFrontImg = UIImage()
    var licnseBacjkImg = UIImage()
    
    enum ImagePickers
    {
        case Profile
        case LicenceFront
        case BannerImage
        case LicenceBack
        
        init()
        {
            self = .Profile
        }
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        setUpView()
    }
    
    //MARK:- other functions
    func setUpView()
    {
        
        self.viewModel = EditProfile_ViewModel.init(Delegate: self, view: self)
        self.hideKeyboardWhenTappedAround()
        //        btnDrawer.target = self.revealViewController()
        //        btnDrawer.action = #selector(SWRevealViewController.revealToggle(_:))
        //        if self.revealViewController()?.panGestureRecognizer() != nil {
        //            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        //            self.setTapGestureOnSWRevealontroller(view: self.view, controller: self) }
        showNAV_BAR(controller: self)
        self.setUI()
        getProfile()
    }
    
    //MARK:-Actions
  
   
    @IBAction func btnBAckAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: false)
    }
    @IBAction func EditBannerAction(_ sender: Any) {
        selectedPicker = ImagePickers.BannerImage
        OpenGalleryCamera(camera: true, imagePickerDelegate: self, isVideoAlso: false)
    }
    
    func getProfile() {
        
        viewModel?.getProfile()
        
    }
    
    
    override func viewDidLayoutSubviews()
    {
        //self.scrollView.contentSize = CGSize(width: self.view.frame.size.width, height: 700)
        
    }
    
    //MARK:- ACTION CHOOSING GENDER
    @IBAction func action_male_selected(_ sender: Any)
    {
        self.ivMale.image = UIImage(named: "btn_check")
        self.ivFemale.image = UIImage(named: "btn_uncheck")
        self.maleSelected = true
        ivMale.setImageColor(color: Appcolor.kTextColorBlack)
        ivFemale.setImageColor(color: Appcolor.kTextColorBlack)
    }
    @IBAction func action_female_selected(_ sender: Any)
    {
        self.ivMale.image = UIImage(named: "btn_uncheck")
        self.ivFemale.image = UIImage(named: "btn_check")
        self.maleSelected = false
        ivMale.setImageColor(color: Appcolor.kTextColorBlack)
        ivFemale.setImageColor(color: Appcolor.kTextColorBlack)
    }
    
    //MARK:- ACTION PROCEED
    
    @IBAction func action_proceed(_ sender: Any)
    {
        var parm = [String:Any]()
        parm["firstName"] = tf_firstName.text
        parm["lastName"] =  tf_lastName.text
        parm["address"] = tf_address.text
        parm["email"] = tf_email.text
        parm["idProofName"] = txtIdProof.text
        
        
        var mediaObjs = [[String:Any]]()
        var idProofObjs = [[String:Any]]()
        var coverImgObjs = [[String:Any]]()
        
        if(profileImage != nil)
        {
            var mediaObj = [String:Any]()
            mediaObj["fileType"] = "Image"
            mediaObj["url"] = profileImage
            mediaObjs.insert(mediaObj, at: 0)
        }
        if(idProofImage != nil)
        {
            var idProofObj = [String:Any]()
            idProofObj["fileType"] = "Image"
            idProofObj["url"] = idProofImage
            idProofObjs.insert(idProofObj, at: 0)
        }
        if(bannerImage != nil)
        {
            var coverImgObj = [String:Any]()
            coverImgObj["fileType"] = "Image"
            coverImgObj["url"] = bannerImage
            coverImgObjs.insert(coverImgObj, at: 0)
        }
        
        parm["profileImage"] = mediaObjs
        parm["idProof"] = idProofObjs
        parm["coverImage"] = coverImgObjs
        
        var uploadParm = [String:Any]()
        var licnseFrontObjs = [[String:Any]]()
        var licnseBackObjs = [[String:Any]]()
        if(licnseFront != nil)
        {
            var idProofObj = [String:Any]()
            idProofObj["fileType"] = "Image"
            idProofObj["url"] = licnseFront
            licnseFrontObjs.insert(idProofObj, at: 0)
        }
        if(licnseBack != nil)
        {
            var coverImgObj = [String:Any]()
            coverImgObj["fileType"] = "Image"
            coverImgObj["url"] = licnseBack
            licnseBackObjs.insert(coverImgObj, at: 0)
        }
        
        uploadParm["licenseFront"] = licnseFrontObjs
        uploadParm["licenseBack"] = licnseBackObjs
        
        
        
        viewModel?.Validations(obj: parm,profileImage: profileImage,idProofImage:idProofImage, uploadDoc: uploadParm)
        
        
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
    @IBAction func btnIdProofAction(_ sender: Any) {
        selectedPicker = ImagePickers.LicenceFront
        OpenGalleryCamera(camera: true, imagePickerDelegate: self, isVideoAlso: false)
    }
    
    @IBAction func updateProfile(_ sender: UIBarButtonItem) {
        
        btnUpdateProfile.isUserInteractionEnabled = true
        tf_firstName.isUserInteractionEnabled = true
        tf_lastName.isUserInteractionEnabled = true
        tf_email.isUserInteractionEnabled = true
        tf_address.isUserInteractionEnabled = true
        btnProceed.isUserInteractionEnabled = true
        txtIdProof.isUserInteractionEnabled = true
        btnIdProof.isUserInteractionEnabled = true
        btnProceed.isHidden = false
        btnProceed.backgroundColor = Appcolor.kOrangeThemeColor
        imgViewSelectImage.isHidden = false
        self.editButton.isEnabled = false
        self.btnEditBanner.isHidden = false
        self.editButton.tintColor = UIColor.clear
    }
    
    @IBAction func selectImage(_ sender: UIButton) {
        selectedPicker = ImagePickers.Profile
        OpenGalleryCamera(camera: true, imagePickerDelegate: self, isVideoAlso: false)
    }
    
    
    
    func setData() {
        self.ivProfile.layer.borderWidth = 5
        self.ivProfile.layer.borderColor = Appcolor.kTextColorWhite.cgColor
        if  localModel?.body?.image != nil && localModel?.body?.image != ""
        {
            ivProfile.sd_setImage(with: URL(string: localModel?.body?.image ?? ""), placeholderImage: UIImage(named: kplaceholderProfile), options: SDWebImageOptions(rawValue: 0))
            { (image, error, cacheType, imageURL) in
                self.ivProfile.image = image
            }
        }
        else{
            ivProfile.image = UIImage(named: kplaceholderProfile)
        }
        if  localModel?.body?.licenseFront != nil && localModel?.body?.licenseFront != ""
        {
            self.btnLicenseFront.sd_setImage(with: URL(string: localModel?.body?.licenseFront ?? ""), for: .normal, placeholderImage: UIImage(named: noImage), options: SDWebImageOptions(rawValue: 0))
            { (image, error, cacheType, imageURL) in
                self.btnLicenseFront.setTitle("", for: .normal)
                self.btnLicenseFront.setImage(image, for: .normal)
            }
        }
        else{
            self.btnLicenseFront.setTitle("Front", for: .normal)
        }
        if  localModel?.body?.licenseBack != nil && localModel?.body?.licenseBack != ""
        {
            self.btnLicenseBack.sd_setImage(with: URL(string: localModel?.body?.licenseBack ?? ""), for: .normal, placeholderImage: UIImage(named: noImage), options: SDWebImageOptions(rawValue: 0))
            { (image, error, cacheType, imageURL) in
                self.btnLicenseBack.setTitle("", for: .normal)
                self.btnLicenseBack.setImage(image, for: .normal)
            }
        }
        else{
            self.btnLicenseFront.setTitle("Back", for: .normal)
        }
        if localModel?.body?.firstName != nil && localModel?.body?.firstName != "" {
            tf_firstName.text = localModel?.body?.firstName
        }
        if localModel?.body?.lastName != nil && localModel?.body?.lastName != "" {
            tf_lastName.text = localModel?.body?.lastName
        }
        if  localModel?.body?.email != nil && localModel?.body?.email != "" {
            tf_email.text = localModel?.body?.email
        }
        if  localModel?.body?.phoneNumber != nil &&  localModel?.body?.phoneNumber != ""
        {
            tf_phoneNumber.text = "\(localModel?.body?.phoneNumber ?? "")"
        }
        if  localModel?.body?.address != nil && localModel?.body?.address != ""
        {
            tf_address.text = localModel?.body?.address
        }
        if  localModel?.body?.idProofName != nil && localModel?.body?.idProofName != ""
        {
            txtIdProof.text = localModel?.body?.idProofName
        }
        if  localModel?.body?.idProof != nil && localModel?.body?.idProof != ""
        {
            imgViewIdProof.sd_setImage(with: URL(string: localModel?.body?.idProof ?? ""), placeholderImage: UIImage(named: "attachment"), options: SDWebImageOptions(rawValue: 0))
            { (image, error, cacheType, imageURL) in
                self.imgViewIdProof.image = image
                self.imgViewIdProof.contentMode = .scaleAspectFill
            }
        }
        else{
            imgViewIdProof.image = UIImage(named: "attachment")
            self.imgViewIdProof.contentMode = .center
        }
        
        imgViewIdProof.layer.cornerRadius = 10
        imgViewIdProof.layer.masksToBounds = true
        imgViewIdProof.layer.borderWidth = 1
        imgViewIdProof.layer.borderColor = Appcolor.kThemeColor.cgColor
        
        if  localModel?.body?.coverImage != nil && localModel?.body?.coverImage != ""
        {
            imageViewBanner.sd_setImage(with: URL(string: localModel?.body?.coverImage ?? ""), placeholderImage: UIImage(named: "backGround"), options: SDWebImageOptions(rawValue: 0))
            { (image, error, cacheType, imageURL) in
                self.imageViewBanner.image = image
                self.imageViewBanner.contentMode = .scaleAspectFill
                AppDefaults.shared.userCoverImage = self.localModel?.body?.coverImage ?? ""
            }
        }
        else
        {
            imageViewBanner.image = UIImage(named: "backGround")
            self.imageViewBanner.contentMode = .scaleAspectFit
        }
        //                   if  localModel?.data?.gender != nil && localModel?.data?.gender  != "" {
        //                   }
        //
    }
    
    //MARK:- HANDLING UI
    func setUI()
    {
        // CornerRadius(radius: 28, view: imageViewBanner)
       // imageViewBanner.imageroundCorners([.topLeft, .topRight], radius: 28)
        ivProfile.layer.cornerRadius = ivProfile.frame.height/2
        ivProfile.layer.masksToBounds = true
        self.tf_firstName.backgroundColor = Appcolor.kTextColorWhite
        self.tf_lastName.backgroundColor = Appcolor.kTextColorWhite
        self.tf_email.backgroundColor = Appcolor.kTextColorWhite
        self.tf_phoneNumber.backgroundColor = Appcolor.kTextColorWhite
        self.tf_address.backgroundColor = Appcolor.kTextColorWhite
        self.txtIdProof.backgroundColor = Appcolor.kTextColorWhite
        
        self.tf_firstName.selectedTitleColor = Appcolor.kThemeColor
        self.tf_lastName.selectedTitleColor = Appcolor.kThemeColor
        self.tf_email.selectedTitleColor = Appcolor.kThemeColor
        self.tf_phoneNumber.selectedTitleColor = Appcolor.kThemeColor
        self.tf_address.selectedTitleColor = Appcolor.kThemeColor
        self.txtIdProof.selectedTitleColor = Appcolor.kThemeColor
        
        self.tf_firstName.selectedLineColor = Appcolor.kThemeColor
        self.tf_lastName.selectedLineColor = Appcolor.kThemeColor
        self.tf_email.selectedLineColor = Appcolor.kThemeColor
        self.tf_phoneNumber.selectedLineColor = Appcolor.kThemeColor
        self.tf_address.selectedLineColor = Appcolor.kThemeColor
        self.txtIdProof.selectedLineColor = Appcolor.kThemeColor
        
        self.imgViewIdProof.CornerRadius(radius: 8)
        
        btnUpdateProfile.isUserInteractionEnabled = true
        tf_firstName.isUserInteractionEnabled = true
        tf_lastName.isUserInteractionEnabled = true
        tf_email.isUserInteractionEnabled = true
        tf_address.isUserInteractionEnabled = true
        btnProceed.isUserInteractionEnabled = true
        txtIdProof.isUserInteractionEnabled = true
        btnIdProof.isUserInteractionEnabled = true
        btnProceed.isHidden = false
        btnProceed.backgroundColor = Appcolor.kOrangeThemeColor
        imgViewSelectImage.isHidden = false
        self.editButton.isEnabled = false
        self.btnEditBanner.isHidden = false
        self.editButton.tintColor = UIColor.clear
        //        self.tf_firstName.makeRound_Boarders_with_leftPadding()
        //        self.tf_lastName.makeRound_Boarders_with_leftPadding()
        //        self.tf_email.makeRound_Boarders_with_leftPadding()
        //        self.tf_phoneNumber.makeRound_Boarders_with_leftPadding()
        //        self.tf_address.makeRound_Boarders_with_leftPadding()
        
        
        //         addShadowToTextField(textField: self.tf_firstName)
        //         addShadowToTextField(textField: self.tf_lastName)
        //        addShadowToTextField(textField: self.tf_email)
        //        addShadowToTextField(textField: self.tf_phoneNumber)
        //        addShadowToTextField(textField: self.tf_address)
        //        ivMale.setImageColor(color: Appcolor.kText_Color_Black)
        //        ivFemale.setImageColor(color: Appcolor.kText_Color_Black)
        //        txtfieldPadding(textField: self.tf_firstName)
        //         txtfieldPadding(textField: self.tf_lastName)
        //         txtfieldPadding(textField: self.tf_email)
        //         txtfieldPadding(textField: self.tf_phoneNumber)
        //         txtfieldPadding(textField: self.tf_address)
    }
    
    let validStringAddress = NSCharacterSet(charactersIn: "!₹@#$%^&*()_+{}[]|\"<>,.~`/:;?-=\\¥'£•¢")
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        // restrict special char in test field
        if (textField == self.tf_firstName || textField == self.tf_lastName)
        {
            if let range = string.rangeOfCharacter(from: validString as CharacterSet)//rangeOfCharacterFromSet(validString)
            {
                print(range)
                return false
            }
        }
        
        if (textField == self.tf_address)
        {
            if let range = string.rangeOfCharacter(from: validStringAddress as CharacterSet)//rangeOfCharacterFromSet(validString)
            {
                print(range)
                return false
            }
        }
        return true
    }
}

//MARK:- EditProDelegate
extension EditProfileVC:EditProfileVCDelegate
{
    func updateSuccess(msg: String?) {
        
        self.AlertMessageWithOkAction(titleStr: kAppName, messageStr: msg ?? "", Target: self) {
            //            self.btnUpdateProfile.isUserInteractionEnabled = false
            //            self.tf_firstName.isUserInteractionEnabled = false
            //            self.tf_lastName.isUserInteractionEnabled = false
            //            self.tf_email.isUserInteractionEnabled = false
            //            self.tf_address.isUserInteractionEnabled = false
            //            self.btnProceed.isUserInteractionEnabled = false
            //            self.txtIdProof.isUserInteractionEnabled = false
            //            self.btnIdProof.isUserInteractionEnabled = false
            //            self.btnProceed.isHidden = true
            //            self.imgViewSelectImage.isHidden = true
            //            self.editButton.isEnabled = true
            //            self.btnEditBanner.isHidden = true
            //            self.editButton.tintColor = UIColor.darkGray
            self.navigationController?.popViewController(animated: false)
        }
    }
    
    func getData(model: EditProfile_ResponseModel)
    {
        localModel = model
        setData()
    }
    
    func Show_results(msg: String)
    {
        showAlertMessage(titleStr:kAppName , messageStr: msg)
    }
    
    
}
//MARK:- UIImagePickerDelegate
extension EditProfileVC: UIImagePickerDelegate
{
    func SelectedMedia(image: UIImage?, imageURL: URL?, videoURL: URL?)
    {
        switch selectedPicker
        {
        case .Profile:
            ivProfile.image = image
//        case .LicenceFront:
//            imgViewIdProof.contentMode = .scaleAspectFill
//            imgViewIdProof.image = image
        case .BannerImage:
            self.imageViewBanner.contentMode = .scaleAspectFill
            imageViewBanner.image = image
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
        switch selectedPicker
        {
        case .Profile:
            profileImage = url
            break
        case .LicenceFront:
            idProofImage = url
            break
        case .BannerImage:
            bannerImage = url
        default: break
        }
    }
    
    func cancelSelectionOfImg()
    {
        
    }
}
