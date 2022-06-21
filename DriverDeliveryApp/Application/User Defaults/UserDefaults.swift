//
//  Extensions.swift
//  Hark
//
//  Created by MAC-4 on 05/03/19.
//  Copyright © 2019 KBS. All rights reserved.
//

import UIKit
import SystemConfiguration

class AppDefaults: NSObject
{
    static let shared = AppDefaults()
    
//    let sharedUserDefault =
//        UserDefaults(suiteName: "group.com.pa.AppName")
    
    //MARK:-CompanyId
    var CompanyID: String
       {
           get
           {
               let Company_Id =  UserDefaults.standard.string(forKey: defaultKeys.CompanyId) ?? "0"
               return Company_Id
           }
           set
           {
               UserDefaults.standard.set(newValue, forKey: defaultKeys.CompanyId)
               UserDefaults.standard.synchronize()
           }
       }
    
    //MARK:-CompanyId
    var currency: String
       {
           get
           {
               let currency =  UserDefaults.standard.string(forKey: "currency") ?? "Rs"
               return currency
           }
           set
           {
               UserDefaults.standard.set(newValue, forKey: "currency")
               UserDefaults.standard.synchronize()
           }
       }
    
    //MARK: USERID
    var userID: String
    {
        get
        {
            let user_Id =  UserDefaults.standard.string(forKey: defaultKeys.userID) ?? "0"
            return user_Id
        }
        set
        {
            UserDefaults.standard.set(newValue, forKey: defaultKeys.userID)
            UserDefaults.standard.synchronize()
        }
    }
    
    var showTutorial: String
    {
        get
        {
            if let showTutorial =  UserDefaults.standard.string(forKey: "showTutorial")
            {
                return showTutorial
            }
            else
            {
                return "0"
            }
        }
        set
        {
            UserDefaults.standard.set(newValue, forKey: "showTutorial")
            UserDefaults.standard.synchronize()
        }
    }
    //MARK: USERID
       var jobStatus: Int
       {
        
        get
        {
            let user_Id =  UserDefaults.standard.integer(forKey: defaultKeys.jobStatus)
            return user_Id
        }
        set
        {
            UserDefaults.standard.set(newValue, forKey: defaultKeys.jobStatus)
            UserDefaults.standard.synchronize()
        }
       }
    //MARK: ID
    var ID: String
    {
        get
        {
            let employeeID =  UserDefaults.standard.string(forKey: defaultKeys.ID) ?? "0"
            return employeeID
        }
        set
        {
            UserDefaults.standard.set(newValue, forKey: defaultKeys.ID)
            UserDefaults.standard.synchronize()
        }
    }
    
    //MARK: CURRENT JOB ID
    var currentJobID: String
    {
        get
        {
            if let currentJobID =  UserDefaults.standard.string(forKey: defaultKeys.currentJobID)
            {
                return currentJobID
            }
            else
            {
                return "0"
            }
        }
        set
        {
            UserDefaults.standard.set(newValue, forKey: defaultKeys.currentJobID)
            UserDefaults.standard.synchronize()
        }
    }
    
    //MARK: CURRENT JOB ID
    var currentJobActive: String
    {
        get
        {
            if let currentJob =  UserDefaults.standard.string(forKey: defaultKeys.currentJobActive)
            {
                return currentJob
            }
            else
            {
                return "0"
            }
        }
        set
        {
            UserDefaults.standard.set(newValue, forKey: defaultKeys.currentJobActive)
            UserDefaults.standard.synchronize()
        }
    }
    
    //MARK: USERID
    var userTYPE: Int
    {
        get
        {
            let user_Id =  UserDefaults.standard.integer(forKey: defaultKeys.userTYPE)
            return user_Id
        }
        set
        {
            UserDefaults.standard.set(newValue, forKey: defaultKeys.userTYPE)
            UserDefaults.standard.synchronize()
        }
    }
    
    //MARK: USERNAME
    var userName: String
    {
        get
        {
            if let user_Name =  UserDefaults.standard.string(forKey: defaultKeys.userName)
            {
                return user_Name
            }
            else
            {
                return ""
            }
        }
        set
        {
            UserDefaults.standard.set(newValue, forKey: defaultKeys.userName)
            UserDefaults.standard.synchronize()
        }
    }
    
    //MARK: USERNAME
    var userFirstName: String
    {
        get
        {
            if let user_Name =  UserDefaults.standard.string(forKey: defaultKeys.userFirstName)
            {
                return user_Name
            }
            else
            {
                return ""
            }
        }
        set
        {
            UserDefaults.standard.set(newValue, forKey: defaultKeys.userFirstName)
            UserDefaults.standard.synchronize()
        }
    }
    
    
    
    //MARK: LASTNAME
    var userLastName: String
    {
        get
        {
            if let user_Name =  UserDefaults.standard.string(forKey: defaultKeys.userLastName)
            {
                return user_Name
            }
            else
            {
                return ""
            }
        }
        set
        {
            UserDefaults.standard.set(newValue, forKey: defaultKeys.userLastName)
            UserDefaults.standard.synchronize()
        }
    }
    
    //MARK: LASTNAME
       var startedJobId: String
       {
           get
           {
               if let user_Name =  UserDefaults.standard.string(forKey: defaultKeys.startedJobId)
               {
                   return user_Name
               }
               else
               {
                   return ""
               }
           }
           set
           {
               UserDefaults.standard.set(newValue, forKey: defaultKeys.startedJobId)
               UserDefaults.standard.synchronize()
           }
       }
    
    
    
    var isJobStarted: String
          {
              get
              {
                  if let user_Name =  UserDefaults.standard.string(forKey:"isJobStarted")
                  {
                      return user_Name
                  }
                  else
                  {
                      return ""
                  }
              }
              set
              {
                  UserDefaults.standard.set(newValue, forKey: "isJobStarted")
                  UserDefaults.standard.synchronize()
              }
          }
    //MARK: OffLineStatus
          var offLineStatus: String
          {
              get
              {
                  if let status =  UserDefaults.standard.string(forKey: "offLineStatus")
                  {
                      return status
                  }
                  else
                  {
                      return ""
                  }
              }
              set
              {
                  UserDefaults.standard.set(newValue, forKey: "offLineStatus")
                  UserDefaults.standard.synchronize()
              }
          }
    //MARK: USER IMAGE
    var userImage: String
    {
        get
        {
            if let userProfile_Image =  UserDefaults.standard.string(forKey: defaultKeys.userImage)
            {
                return userProfile_Image
            }
            else
            {
                return ""
            }
        }
        set
        {
            UserDefaults.standard.set(newValue, forKey: defaultKeys.userImage)
            UserDefaults.standard.synchronize()
        }
    }
    //MARK: USER IMAGE
       var userCoverImage: String
       {
           get
           {
               if let userProfile_Image =  UserDefaults.standard.string(forKey: defaultKeys.userCoverImage)
               {
                   return userProfile_Image
               }
               else
               {
                   return ""
               }
           }
           set
           {
               UserDefaults.standard.set(newValue, forKey: defaultKeys.userCoverImage)
               UserDefaults.standard.synchronize()
           }
       }
    
    //MARK: USER Email
    var userEmail: String
    {
        get
        {
            if let userProfile_Image =  UserDefaults.standard.string(forKey: defaultKeys.userEmail)
            {
                return userProfile_Image
            }
            else
            {
                return ""
            }
        }
        set
        {
            UserDefaults.standard.set(newValue, forKey: defaultKeys.userEmail)
            UserDefaults.standard.synchronize()
        }
    }
    
    //MARK: USER DEVICE TOKEN
    var userDeviceToken: String
    {
        get
        {
            if let userProfile_Image =  UserDefaults.standard.string(forKey: defaultKeys.userDeviceToken)
            {
                return userProfile_Image
            }
            else
            {
                return "1234"
            }
        }
        set
        {
            UserDefaults.standard.set(newValue, forKey: defaultKeys.userDeviceToken)
            UserDefaults.standard.synchronize()
        }
    }
    
    
    //MARK: USER AUTH TOKEN
    var userJWT_Token: String
    {
        get
        {
            if let userProfile_Image =  UserDefaults.standard.string(forKey: defaultKeys.userJWT_Token)
            {
                return userProfile_Image
            }
            else
            {
                return ""
            }
        }
        set
        {
            UserDefaults.standard.set(newValue, forKey: defaultKeys.userJWT_Token)
            UserDefaults.standard.synchronize()
        }
    }
    
    //MARK: Firebase VerifcationID
       var firebaseVID: String
       {
           get
           {
               if let firebaseVID =  UserDefaults.standard.string(forKey: defaultKeys.firebaseVID)
               {
                   return firebaseVID
               }
               else
               {
                   return ""
               }
           }
           set
           {
               UserDefaults.standard.set(newValue, forKey: defaultKeys.firebaseVID)
               UserDefaults.standard.synchronize()
           }
       }
    
    //MARK: Firebase VerifcationID
    var firebaseToken: String
    {
        get
        {
            if let firebaseToken =  UserDefaults.standard.string(forKey: defaultKeys.firebaseToken)
            {
                return firebaseToken
            }
            else
            {
                return ""
            }
        }
        set
        {
            UserDefaults.standard.set(newValue, forKey: defaultKeys.firebaseToken)
            UserDefaults.standard.synchronize()
        }
    }
   
    
    //MARK: USER Phone Number
    var userPhoneNumber: String
    {
        get
        {
            if let nbr =  UserDefaults.standard.string(forKey: defaultKeys.userPhoneNumber)
            {
                return nbr
            }
            else
            {
                return ""
            }
        }
        set
        {
            UserDefaults.standard.set(newValue, forKey: defaultKeys.userPhoneNumber)
            UserDefaults.standard.synchronize()
        }
    }
    
    
    //MARK: USER COUNTRY CODE
    var userCountryCode: String
    {
        get
        {
            if let userDOB =  UserDefaults.standard.string(forKey: defaultKeys.userCountryCode)
            {
                return userDOB
            }
            else
            {
                return ""
            }
        }
        set
        {
            UserDefaults.standard.set(newValue, forKey: defaultKeys.userCountryCode)
            UserDefaults.standard.synchronize()
        }
    }
    
    //MARK: USER HOME ADDRESS
    var userHomeAddress: String
    {
        get
        {
            if let userHomeAddress =  UserDefaults.standard.string(forKey: defaultKeys.userHomeAddress)
            {
                return userHomeAddress
            }
            else
            {
                return ""
            }
        }
        set
        {
            UserDefaults.standard.set(newValue, forKey: defaultKeys.userHomeAddress)
            UserDefaults.standard.synchronize()
        }
    }
    
    //MARK: SYNCED Database IDs For Posted Locations
    var synced_IDs: [String]
    {
        get
        {
            if let IDs =  UserDefaults.standard.object(forKey: defaultKeys.synced_IDs) as? [String]
            {
                return IDs
            }
            else
            {
                return [""]
            }
        }
        set
        {
            UserDefaults.standard.set(newValue, forKey: defaultKeys.synced_IDs)
            UserDefaults.standard.synchronize()
        }
    }
    
    
    var app_LATITUDE: String
    {
        get
        {
            if let my_drop_LAT =  UserDefaults.standard.string(forKey: "app_LATITUDE")
            {
                return my_drop_LAT
            }
            else
            {
                return "00.00"
            }
        }
        set
        {
            UserDefaults.standard.set(newValue, forKey: "app_LATITUDE")
            UserDefaults.standard.synchronize()
        }
    }
    
    var app_LONGITUDE: String
    {
        get
        {
            if let my_drop_LONG =  UserDefaults.standard.string(forKey: "app_LONGITUDE")
            {
                return my_drop_LONG
            }
            else
            {
                return "00.00"
            }
        }
        set
        {
            UserDefaults.standard.set(newValue, forKey: "app_LONGITUDE")
            UserDefaults.standard.synchronize()
        }
    }
    
    //MARK: Get App Color Name
    var appColor_Name: String
    {
        get
        {
            if let appColor_Name =  UserDefaults.standard.string(forKey: defaultKeys.appColor_Name)
            {
                return appColor_Name
            }
            else
            {
                return ""
            }
        }
        set
        {
            UserDefaults.standard.set(newValue, forKey: defaultKeys.appColor_Name)
            UserDefaults.standard.synchronize()
        }
    }
    
}





