//
//  AppConstants.swift
//  Cabbies
//
//  Created by Techwin Labs on 03/04/19.
//  Copyright © 2019 Techwin Labs. All rights reserved.
//
//
import Foundation
import UIKit

let KDone                                           =         "Done"
let KChooseImage                                    =         "Choose Image"
let KChooseVideo                                    =         "Choose Video"
let KCamera                                         =         "Camera"
let KGallery                                        =         "Gallery"
let KYoudonthavecamera                              =         "You don't have camera"
let KSettings                                       =         "Settings"

@available(iOS 13.0, *)
let KappDelegate                                    =        UIApplication.shared.delegate as! AppDelegate
let KOpenSettingForPhotos                           =         "App does not have access to your photos. To enable access, tap Settings and turn on Photos."
let KOpenSettingForCamera                           =         "App does not have access to your camera. To enable access, tap Settings and turn on Camera."
let KOK                                             =         "OK"
let KCancel                                         =       "Cancel"
let KYes                                            =       "Yes"
let KNo                                             =       "No"

let KOngoing                                        =       "Ongoing"
let KCompleted                                      =       "Completed"

let kOops = "Oops!"

let kLottieVerifyData = "Verify"

//MARK:- iDevice detection code
struct Device_type
{
    static let IS_IPAD             = UIDevice.current.userInterfaceIdiom == .pad
    static let IS_IPHONE           = UIDevice.current.userInterfaceIdiom == .phone
    static let IS_RETINA           = UIScreen.main.scale >= 2.0
    
    static let SCREEN_WIDTH        = Int(UIScreen.main.bounds.size.width)
    static let SCREEN_HEIGHT       = Int(UIScreen.main.bounds.size.height)
    static let SCREEN_MAX_LENGTH   = Int( max(SCREEN_WIDTH, SCREEN_HEIGHT) )
    static let SCREEN_MIN_LENGTH   = Int( min(SCREEN_WIDTH, SCREEN_HEIGHT) )
    
    static let IS_IPHONE_4_OR_LESS = IS_IPHONE && SCREEN_MAX_LENGTH  < 568
    static let IS_IPHONE_5         = IS_IPHONE && SCREEN_MAX_LENGTH == 568
    static let IS_IPHONE_6         = IS_IPHONE && SCREEN_MAX_LENGTH == 667
    static let IS_IPHONE_6P        = IS_IPHONE && SCREEN_MAX_LENGTH == 736
    static let IS_IPHONE_X         = IS_IPHONE && SCREEN_MAX_LENGTH >= 812
}

//MARK : STATIC TEXT
let kAppName = "ZigriCart Rider"
let kLoading = "Loading..."
let kVerifying = "Verifying..."
let kLoading_Getting_OTP = "Requesting OTP..."
let kDone = "Done"
let kSaved = "Saved"
let kError = "Error"
let kDataNotFound = "Data not found!"
let kStoryBoard_Main = "Main"
let kResponseNotCorrect = "Data isn't in correct form!"
let kUserNotRegistered = "User is not registered yet!"
let kSomthingWrong = "Something went wrong, please try again!"
let kDataSavedInDatabase = "Data saved successfully in database"
let kDatabaseSuccess = "Database Success"
let kDatabaseFailure = "Database Failure"



//MARK: DEFAULT IMAGES
let kplaceholderProfile = "dummy_user"
let noImage = "noImage"



let GoogleAPIKey = "AIzaSyAtPTNipftdbMLi1nX0CpyPGABVyJLEPi4"


let kPush_Approach_from_ForgotPassword = "coming_from_forgotPassword"
let kPush_Approach_from_SignUp = "coming_from_signup"

//MARK : KEYS FOR STORE DATA

struct defaultKeys
{
    
    static let ID = "ID"
    static let userID = "userID"
    static let userName = "userName"
    static let userFirstName = "userFirstName"
    static let userImage = "userImage"
    static let userEmail = "userEmail"
    static let userDeviceToken = "userDeviceToken"
    static let userJWT_Token = "userJWT_Token"
    static let userPhoneNumber = "userPhoneNumber"
    static let userHomeAddress = "userHomeAddress"
    static let appColor_Name = "appColor_Name"
    static let firebaseVID = "firebaseVID"
    static let userTYPE = "userTYPE"
    static let userCountryCode = "userCountryCode"
    static let firebaseToken = "firebaseToken"
    static let userLastName = "userLastName"
    static let currentJobID = "currentJobID"
    static let currentJobActive = "currentJobActive"
    static let synced_IDs = "synced_IDs"
    static let CompanyId = "CompanyId"
    static let jobStatus = "jobStatus"
    static let userCoverImage = "userCoverImage"
    static let startedJobId = "startedJobId"
}

struct database
{
    
    struct entityJobDetails
    {
        static let entityName_JobDetails = "JobDetails"
        static let tableID = "tableID"
        static let start_lat = "start_lat"
        static let start_long = "start_long"
        static let end_lat = "end_lat"
        static let end_long = "end_long"
        static let startDate = "startDate"
        static let syncStatus = "syncStatus"
        static let error = "error"
        static let jobID = "jobID"
        static let user_id = "user_id"
        static let job_status = "job_status"
        
    }
    
    struct entityJobSavedLocations
    {
        static let entityName_JobLocations = "JobLocations"
        static let tableID = "tableID"
        static let lat = "lat"
        static let long = "long"
        static let startDate = "startDate"
        static let syncStatus = "syncStatus"
        static let error = "error"
        static let jobID = "jobID"
        static let user_id = "user_id"
    }
    
}


struct APIAddress
{

    //CereKart live
 //   static let BASE_URL = "https://stgcerb.cerebruminfotech.com:9073/api/delivery/"
 //   static let SOCKET_BASE_URL = "https://stgcerb.cerebruminfotech.com:9073"
    
    
    static let BASE_URL = "https://stgcerb.cerebruminfotech.com:9062/zigricart/delivery/"// Grocery King
    static let SOCKET_BASE_URL = "https://stgcerb.cerebruminfotech.com:9062"
    
    //CereKart Staging
  //  static let BASE_URL = "https://stgcerb.cerebruminfotech.com:9074/api/delivery/"
  //  static let SOCKET_BASE_URL = "https://stgcerb.cerebruminfotech.com:9074"
    
    //CereHome
 //   static let BASE_URL = "https://stgcerb.cerebruminfotech.com:9075/api/delivery/"
 //  static let SOCKET_BASE_URL = "https://stgcerb.cerebruminfotech.com:9075"

    //MARK:- DriverDelivery
    static let Login = BASE_URL + "auth/login"
    static let SIGNUP = BASE_URL + "auth/signup"
    static let updateProfile = BASE_URL + "profile/updateprofile"
    static let GetProfile = BASE_URL + "profile/getprofile"
    static let GetJobApi = BASE_URL + "orders/list?progressStatus="
    static let updateTrackStatusApi = BASE_URL + "orders/status"
    static let CancelReasonslist = BASE_URL + "orders/getCancelReasons"
    static let submitCancel = BASE_URL + "orders/cancel"
    static let feedbacklist = BASE_URL + "orders/feedbacklist?page="
    static let orderDetail = BASE_URL + "orders/detail/"
    static let notificationList = BASE_URL + "notification/"
    static let deleteNotifications = BASE_URL + "notification/clearAll"
    static let acceptJob = BASE_URL + "orders/acceptJob"
    static let rejectJob = BASE_URL + "orders/rejectJob"
    static let allStatus = BASE_URL + "orders/allStatus"
    static let updateStatus = BASE_URL + "auth/markStatus"
    static let cashCollect = BASE_URL + "orders/cashCollected"
    static let walletHistory = BASE_URL + "profile/wallet/history"
    static let companyDetail = BASE_URL + "profile/getIdInfo"
    static let delayOrder = BASE_URL + "orders/updateDelay"
    static let transferMoney = BASE_URL + "profile/transferMoney"
    static let bankDetail = BASE_URL + "profile/getBankDetail"
    static let updateBankAcc = BASE_URL + "profile/updateBankDetail"
    static let uploadDocument = BASE_URL + "profile/updateDocument"
    static let polyRegions = BASE_URL + "profile/geoFence"
    
    static let GET_SETTINGSINFO = BASE_URL + "profile/settingsInfo"
    static let GET_EARNINGSINFO = BASE_URL + "profile/earningHistory?startDate="
    static let DRIVER_LOGOUT = BASE_URL + "auth/logout"
    
    
    static let CHECK_PHONE_NUMBER = BASE_URL + "driver/auth/checkPhoneNumber"
    static let REGISTER = BASE_URL + "driver/auth/register"
    
    static let LOGIN = BASE_URL + "api/loginEmployee"
    
    static let RESET_PASSWORD = BASE_URL + "driver/auth/resetpassword"
    static let CHANGE_PASSWORD = BASE_URL + "driver/auth/changepassword"
    
    
    
    
    static let MultipartAudioFileUpload = BASE_URL + "api/employee/update"
    
    
    
    //SOCKET
    //static let SOCKET_BASE_URL = "http://10.8.23.202:9062"//"http://51.79.40.224:9062"
    
    //http://51.79.40.224:9075
    static let SOCKET_EXCHANGE_LOCATION = SOCKET_BASE_URL
    
    //Driver JOBS
    static let GET_NEW_JOBS = BASE_URL + "api/job/getDriverJobs"
    static let JOBS_HISTORY = BASE_URL + "api/job/jobsHistory"
    static let ACCEPT_REJECT_JOB = BASE_URL + "api/job/AcceptReject"
    
    
    //FUEL
    static let ADD_FUEL_DETAILS = BASE_URL + "api/fuel/addFuel"
    static let GET_FUEL_LIST = BASE_URL + "api/fuel/getList"
    
    //VENDORS
    static let GET_VENDOR_LIST = BASE_URL + "api/vendor/list"
    
    //VEHICLES
    static let GET_VEHICLE_LIST = BASE_URL + "api/vehicle/vehicleDriverlist"
    
    //SERVICES
    static let GetUpcomingServiceList = BASE_URL + "api/service/list"
    static let AddServiceDetail = BASE_URL + "api/service/update"
    
    //NOTIFICATIONS
    static let GetNotificationList = BASE_URL + "api/notification/list/"
    static let DeleteNotificationList = BASE_URL + "api/notification/delete/"
    
    //START JOB
    static let StartJob = BASE_URL + "api/job/changeJobStatus"
    
    
    
    
}


//struct APIAddress
//{
//    static let BASE_URL = "http://infinitywebtechnologies.com:9062/"
//    static let BASE_URL2 = "http://10.8.23.202:9062/"
//
//    static let CHECK_PHONE_NUMBER = BASE_URL + "driver/auth/checkPhoneNumber"
//    static let REGISTER = BASE_URL + "driver/auth/register"
//    static let LOGIN = BASE_URL + "driver/auth/login"
//    static let RESET_PASSWORD = BASE_URL + "driver/auth/resetpassword"
//    static let CHANGE_PASSWORD = BASE_URL + "driver/auth/changepassword"
//    static let GetProfile = BASE_URL + "driver/auth/getProfile"
//    static let MultipartAudioFileUpload = BASE_URL + "driver/auth/updateProfile"
//    static let DRIVER_LOGOUT = BASE_URL + "driver/auth/logout"
//
//
//    //SOCKET
//    static let SOCKET_BASE_URL = "http://10.8.23.202:9062"
//    static let SOCKET_EXCHANGE_LOCATION = SOCKET_BASE_URL
//
//    //Driver JOBS
//    static let GET_NEW_JOBS = BASE_URL + "job/getDriverjob"
//    static let JOBS_HISTORY = BASE_URL + "job/driver/jobsHistory"
//    static let ACCEPT_REJECT_JOB = BASE_URL + "job/driver/acceptRejectJob"
//
//
//    //FUEL
//    static let ADD_FUEL_DETAILS = BASE_URL + "fuel/addFuel"
//    static let GET_FUEL_LIST = BASE_URL + "fuel/driver/getFuelList"
//
//    //VENDORS
//    static let GET_VENDOR_LIST = BASE_URL + "vendor/getVendorList"
//
//    //VEHICLES
//    static let GET_VEHICLE_LIST = BASE_URL + "driver/vehicle/list"
//
//    //SERVICES
//    static let GetUpcomingServiceList = BASE_URL + "service/driver/getServiceList"
//    static let AddServiceDetail = BASE_URL + "service/updateServiceEntry"
//
//    //NOTIFICATIONS
//    static let GetNotificationList = BASE_URL + "notification/driver/getList"
//    static let DeleteNotificationList = BASE_URL + "notification/driver/clearAll"
//
//    //START JOB
//    static let StartJob = BASE_URL + "job/driver/changeJobStatus"
//}

let kHeader_app_json = ["Accept" : "application/json"]


enum Parameter_Keys_All : String
{
    
    case deviceToken = "deviceToken"
    case deviceType = "deviceType"
    case voipDeviceToken = "voipDeviceToken"
    case appVersion = "appVersion"
    
    //User LoginProcess Keys signUp keys
    case language = "language"
    case countryCode = "countryCode"
    case phoneNumber = "phoneNumber"
    case otp = "otp"
    case email = "email"
    case signupBy = "signupBy"
    case firstName = "firstName"
    case lastName = "lastName"
    case socialId = "socialId"
    case loginBy = "loginBy"
    
    case password = "password"
    case address = "address"
    case city = "city"
    case country = "country"
    case latitude = "latitude"
    case longitude = "longitude"
    case socialPic = "socialPic"
    case profilePic = "profilePic"
    case emailPhone = "emailPhone"
    case DOB = "DOB"
    case gender = "gender"
    
}

enum Validate : String
{
    
    case none
    case success = "200"
    case failure = "400"
    case invalidAccessToken = "401"
    case fbLogin = "3"
    case fbLoginError = "405"
    
    func map(response message : String?) -> String?
    {
        
        switch self
        {
        case .success : return message
        case .failure :return message
        case .invalidAccessToken :return message
        case .fbLoginError : return Validate.fbLoginError.rawValue
        default :return nil
        }
    }
}



enum configs
{
    static let mainscreen = UIScreen.main.bounds
    static let kAppdelegate = UIApplication.shared.delegate as! AppDelegate
}


struct AlertTitles
{
    static let Ok:String = "OK"
    static let Cancel:String = "CANCEL"
    static let Yes:String = "Yes"
    static let No:String = "No"
    static let Alert:String = "Alert"
    
    static let Internet_not_available = "Please check your internet connection!"
    static let Success = "Success"
    static let Error = "Error"
    static let InternalError = "Internal Error"
    static let Enter_Email = "Please enter your email"
    static let Enter_UserName = "Please enter your username"
    static let Enter_Password = "Please enter your password"
    static let Phone_digits_exceeded = "Phone number digists are exceeded, make sure you are entering correct phone number"
    static let Enter_phone_number = "Please enter phone number"
    static let EnterValid_phone_number = "Please enter a valid phone number"
    static let PasswordEmpty = "Password is empty"
    static let EnterNewPassword = "Please enter new password"
    static let PasswordEmpty_OLD = "Old Password is empty"
    static let PasswordLength8 = "Password length should be of 8-20 characters"
    static let Password_ShudHave_SpclCharacter = "Your password should contain one numeric,one special character,one upper and lower case character"
    static let PasswordCnfrmEmpty = "Confirm password is empty"
    static let Passwordmismatch = "New password and confirm password does not match"
    
    
    //Validations
    static let CheckFName = "Please check your first name"
    static let CheckLName = "Please check your last name"
    static let CheckEmail = "Please check email you have entered"
    static let CheckPhone = "Please check phone number"
    static let CheckCountryCode = "Please check country code"
    static let CheckPassword = "Please check your password"
    static let CheckPasswordOld = "Please add your old password"
    static let AcceptTerms = "Please accept terms & conditions for sign up"
    static let CheckProfileImage = "Please add your profile image"
    static let CheckPaymentType = "Please select payment type"
    //Add new truck
    static let CheckTruckImages = "Please add mobile cart images first!"
    static let CheckGalleryImages = "Please add gallery images first!"
    static let CheckTruckName = "Please add mobile cart name!"
    static let CheckTruckLocation = "Please add mobile cart location!"
    static let CheckTruckRegistration = "Please add registration number!"
    static let CheckTruckStartTime = "Please choose start time!"
    static let CheckTruckEndTime = "Please choose end time!"
    static let CheckTruckOwnerName = "Please enter mobile cart owner name!"
    static let CheckTruckOwnerPhone = "Please enter mobile cart owner contact!"
    static let CheckTruckImages2 = "Please add atleast 2 mobile cart images first!"
    static let CheckgalleryImages2 = "Please add atleast 2 gallery images first!"
    
    
    static let kStartTime = "Start Time"
    static let kEndTime = "End Time"
    
    
    
}


enum DateFormat
{
    
    case dd_MMMM_yyyy
    case dd_MM_yyyy
    case dd_MM_yyyy2
    case yyyy_MM_dd
    case hh_mm_a
    case yyyy_MM_dd_hh_mm_a
    case yyyy_MM_dd_hh_mm_a2
    case dateWithTimeZone
    case dd_MMM_yyyy
    
    func get() -> String
    {
        
        switch self
        {
            
        case .dd_MMMM_yyyy : return "dd MMMM, yyyy"
        case .dd_MM_yyyy : return "dd-MM-yyyy"
        case .dd_MM_yyyy2 : return "dd/MM/yyyy"
        case .yyyy_MM_dd : return "yyyy-MM-dd"
        case .hh_mm_a : return "hh:mm a"
        case .yyyy_MM_dd_hh_mm_a : return  "yyyy-MM-dd hh:mm a"
        case .yyyy_MM_dd_hh_mm_a2 : return  "dd MMM yyyy, hh:mm a"
        case .dateWithTimeZone : return "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        case .dd_MMM_yyyy : return "dd MMM yyyy"
            
        }
    }
}

extension String
{
    func capitalizingFirstLetter() -> String
    {
        return prefix(1).capitalized + dropFirst()
    }
    
    mutating func capitalizeFirstLetter()
    {
        self = self.capitalizingFirstLetter()
    }
}



