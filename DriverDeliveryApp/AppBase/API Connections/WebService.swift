
//
//  WebService.swift
//  UnionGoods
//
//  Created by Rakesh Kumar on 11/20/19.
//  Copyright © 2019 Seasia infotech. All rights reserved.
//

//
//  Auth.swift
//  BidJones
//
//  Created by Rakesh Kumar on 3/8/18.
//  Copyright © 2018 Seasia. All rights reserved.
//

import Foundation
import Alamofire
import UIKit
//import AlamofireObjectMapper

enum MediaType
{
    case Image
    case Video
    case Song
    case Pdf
    case Graphic
}

class WebService
{
    static let Shared = WebService()
    private init()
    {
    }
    var view: UIViewController?
    
    var interntOff = "Internet appears to be offline!"
    var ssnExpire = "Your session has been expired. Please login again!"
    
    func PostApi(url : String, parameter : [String : Any],Target : UIViewController, completionResponse:@escaping (Any) -> (),completionnilResponse:  @escaping (String) -> Void)
    {
        if AllUtilies.isConnectedToInternet
        {
            view = Target
            view!.StartIndicator(message: kLoading)
            let urlComplete = url
            print(urlComplete)
            print("Your login parameter : \(parameter)")
            
            var headers = HTTPHeaders()
            
            if url.contains("login")
            {
                 headers    = ["Content-Type" : "application/json"]
            }
            
            else
            {
                 headers    = ["Content-Type" : "application/json","Authorization": AppDefaults.shared.userJWT_Token]
            }
            
            
            Alamofire.request(urlComplete, method: .post, parameters: parameter, encoding: JSONEncoding.default, headers : headers).responseJSON { response in
                self.view!.StopIndicator()
                switch response.result
                {
                case .success:
                    print(response.value!)
                    guard let data = response.value else{return}
                    guard let responseData  = data as? [String : Any] else
                    {
                        return
                    }
                    guard let statusCode = responseData["code"] as? Int else
                    {
                        return
                    }
                    if statusCode == 200
                    {
                        print(responseData)
                        completionResponse(response.result.value as Any)
                    }
                    else
                    {
                        guard let message = responseData["message"] as? String else {return}
                        
                        if  statusCode == 401
                        {
                            //Target.showErrorMessage(titleStr: kAppName, messageStr:message)
                           // completionnilResponse(message)
                            Target.AlertMessageWithOkAction(titleStr: kAppName, messageStr: message, Target: Target)
                            {
                                self.empty_data()
                                self.logoutUser(trgt: Target)
                            }

                        }
                        else if statusCode == 403
                        {
                            Target.showErrorMessage(titleStr: kAppName, messageStr:message)
                        }
                        else if statusCode == 404
                        {
                            Target.showErrorMessage(titleStr: kAppName, messageStr:message)
                        }
                        else if statusCode == 204
                        {
                           // Target.showErrorMessage(titleStr: kAppName, messageStr:message)
                            completionnilResponse(message)
                        }
                        else if statusCode == 500
                        {
                            Target.showErrorMessage(titleStr: kAppName, messageStr:message)
                        }
                        else
                        {
                            completionnilResponse(message)
                        }
                        
                    }
                    print(response.value as Any)
                case .failure(let error):
                    Target.showAlertMessage(titleStr: kAppName, messageStr: error.localizedDescription)
                }
            }
        }
        else
        {
            Target.showAlertMessage(titleStr: kAppName, messageStr: "Internet Error")
        }
    }
    
    //MARK:- TrakStatus
    func PostApiForTrackStatus(url : String, parameter : [String : Any],Target : UIViewController,showLoader:Bool, completionResponse:@escaping (Any) -> (),completionnilResponse:  @escaping (String) -> Void)
       {
           if AllUtilies.isConnectedToInternet
           {
               view = Target
                      if (showLoader == true)
                      {
                        view!.StartIndicator(message: kLoading)
                      }
                      
               let urlComplete = url
               print(urlComplete)
               print("Your login parameter : \(parameter)")
               
               var headers = HTTPHeaders()
              
                 headers    = ["Content-Type" : "application/json","Authorization": AppDefaults.shared.userJWT_Token,"CompanyId":AppDefaults.shared.CompanyID]
               
               Alamofire.request(urlComplete, method: .post, parameters: parameter, encoding: JSONEncoding.default, headers : headers).responseJSON { response in
                if (showLoader == true)
                {
                   self.view!.StopIndicator()
                }
                   switch response.result
                   {
                   case .success:
                       print(response.value!)
                       guard let data = response.value else{return}
                       guard let responseData  = data as? [String : Any] else
                       {
                           return
                       }
                       guard let statusCode = responseData["code"] as? Int else
                       {
                           return
                       }
                       if statusCode == 200
                       {
                           print(responseData)
                           completionResponse(response.result.value as Any)
                       }
                       else
                       {
                           guard let message = responseData["message"] as? String else {return}
                           
                           if  statusCode == 401
                           {
                            Target.AlertMessageWithOkAction(titleStr: kAppName, messageStr: message, Target: Target)
                            {
                                self.empty_data()
                                self.logoutUser(trgt: Target)
                            }
                               //Target.showErrorMessage(titleStr: kAppName, messageStr:message)
                           }
                           else if statusCode == 403
                           {
                               Target.showErrorMessage(titleStr: kAppName, messageStr:message)
                           }
                           else if statusCode == 404
                           {
                               Target.showErrorMessage(titleStr: kAppName, messageStr:message)
                           }
                           else if statusCode == 204
                           {
                              // Target.showErrorMessage(titleStr: kAppName, messageStr:message)
                               completionnilResponse(message)
                           }
                           else if statusCode == 500
                           {
                               Target.showErrorMessage(titleStr: kAppName, messageStr:message)
                           }
                           else
                           {
                               completionnilResponse(message)
                           }
                           
                       }
                       print(response.value as Any)
                   case .failure(let error):
                       Target.showAlertMessage(titleStr: kAppName, messageStr: error.localizedDescription)
                   }
               }
           }
           else
           {
               Target.showAlertMessage(titleStr: kAppName, messageStr: "Internet Error")
           }
       }
       
    
    func GetApi(url : String,Target : UIViewController,showLoader:Bool, completionResponse:@escaping (Any) -> (),completionnilResponse:  @escaping ((String)) -> Void)
    {
        if AllUtilies.isConnectedToInternet
        {
            view = Target
            if (showLoader == true)
            {
              view!.StartIndicator(message: kLoading)
            }
            
            
            let urlComplete = url
            print(urlComplete)
           
            let headers = ["Authorization": AppDefaults.shared.userJWT_Token]
            
            print(AppDefaults.shared.userJWT_Token)
            Alamofire.request(urlComplete, method: .get, parameters: nil, encoding: URLEncoding.default, headers : headers)
                .responseJSON { response in
                    
                    if (showLoader == true)
                    {
                      self.view!.StopIndicator()
                    }
                    
                    
                    print(response)
                    switch response.result{
                    case .success:
                        guard let data = response.value else{return}
                        let responseData  = data as! [String : Any]
                        guard let statusCode = responseData["code"] as? Int else{
                            return
                        }
                        if statusCode == 200
                        {
                            completionResponse(response.result.value as Any)
                        }
                        else
                        {
                            guard let message = responseData["message"] as? String else {return}
                            
                            if  statusCode == 401
                            {
                               // Target.showErrorMessage(titleStr: kAppName, messageStr:message)
                                Target.AlertMessageWithOkAction(titleStr: kAppName, messageStr: message, Target: Target)
                                {
                                    self.empty_data()
                                    self.logoutUser(trgt: Target)
                                }
                            }
                            else if statusCode == 403
                            {
                                //  if let Result = responseData["result"] as? [String:Any]
                                //  {
                                //      self.MoveToSignuP(mobileNum: Result["mobilePhone"] as! String, UserID: Result["userId"] as! Int, countryCode: Result["countryCode"] as! String, View: Target)
                                //  }
                                
                                Target.showErrorMessage(titleStr: kAppName, messageStr:message)
                            }
                            else if statusCode == 404
                            {
                               // Target.showErrorMessage(titleStr: kAppName, messageStr:message)
                                completionnilResponse(message)
                            }
                            else if statusCode == 204
                            {
                                Target.showErrorMessage(titleStr: kAppName, messageStr:message)
                            }
                            else if statusCode == 500
                            {
                                Target.showErrorMessage(titleStr: kAppName, messageStr:message)
                            }
                            else
                            {
                                completionnilResponse(message)
                            }
                        }
                    case .failure(let error):
                        print(error)
                        Target.showErrorMessage(titleStr: kAppName, messageStr: error.localizedDescription)
                    }
            }
        }
        else
        {
            Target.showErrorMessage(titleStr: kAppName, messageStr: "Internet Error")
        }
    }
    
    func GetApiForJOB(url : String,Target : UIViewController,showLoader:Bool, completionResponse:@escaping (Any) -> (),completionnilResponse:  @escaping ((String)) -> Void)
       {
           if AllUtilies.isConnectedToInternet
           {
               view = Target
               if (showLoader == true)
               {
                 view!.StartIndicator(message: kLoading)
               }
               
               
               let urlComplete = url
               print(urlComplete)
              
            let headers = ["Authorization": AppDefaults.shared.userJWT_Token,"CompanyId":AppDefaults.shared.CompanyID]
               
               print(AppDefaults.shared.userJWT_Token)
               Alamofire.request(urlComplete, method: .get, parameters: nil, encoding: URLEncoding.default, headers : headers)
                   .responseJSON { response in
                       
                       if (showLoader == true)
                       {
                         self.view!.StopIndicator()
                       }
                       
                       
                       print(response)
                       switch response.result{
                       case .success:
                           guard let data = response.value else{return}
                           let responseData  = data as! [String : Any]
                           guard let statusCode = responseData["code"] as? Int else{
                               return
                           }
                           if statusCode == 200
                           {
                               completionResponse(response.result.value as Any)
                           }
                           else
                           {
                               guard let message = responseData["message"] as? String else {return}
                               
                               if  statusCode == 401
                               {
                                  
                                if message == "You are not authorized Send Valid Token"{
                                    Target.AlertMessageWithOkAction(titleStr: kAppName, messageStr: message, Target: Target)
                                    {
                                        self.empty_data()
                                        self.logoutUser(trgt: Target)
                                    }
                                }
                                else{
                                   Target.showErrorMessage(titleStr: kAppName, messageStr:message)
                                }
                               }
                               else if statusCode == 403
                               {
                                   //  if let Result = responseData["result"] as? [String:Any]
                                   //  {
                                   //      self.MoveToSignuP(mobileNum: Result["mobilePhone"] as! String, UserID: Result["userId"] as! Int, countryCode: Result["countryCode"] as! String, View: Target)
                                   //  }
                                   
                                   Target.showErrorMessage(titleStr: kAppName, messageStr:message)
                               }
                               else if statusCode == 404
                               {
                                  // Target.showErrorMessage(titleStr: kAppName, messageStr:message)
                                   completionnilResponse(message)
                               }
                               else if statusCode == 204
                               {
                                  // Target.showErrorMessage(titleStr: kAppName, messageStr:message)
                                completionnilResponse(message)
                               }
                               else if statusCode == 500
                               {
                                   Target.showErrorMessage(titleStr: kAppName, messageStr:message)
                               }
                               else
                               {
                                   completionnilResponse(message)
                               }
                           }
                       case .failure(let error):
                           print(error)
                           Target.showErrorMessage(titleStr: kAppName, messageStr: error.localizedDescription)
                       }
               }
           }
           else
           {
               Target.showErrorMessage(titleStr: kAppName, messageStr: "Internet Error")
           }
       }
       func empty_data()
          {
              AppDefaults.shared.userID = "0"
              AppDefaults.shared.ID = "0"
              AppDefaults.shared.userTYPE = 0
              AppDefaults.shared.userName = ""
              AppDefaults.shared.userFirstName = ""
              AppDefaults.shared.userLastName = ""
              AppDefaults.shared.userImage = ""
              AppDefaults.shared.userEmail = ""
              AppDefaults.shared.userJWT_Token = ""
              AppDefaults.shared.firebaseVID = ""
              // AppDefaults.shared.firebaseToken = ""
              AppDefaults.shared.userPhoneNumber = ""
              AppDefaults.shared.userCountryCode = ""
              AppDefaults.shared.userHomeAddress = ""
              AppDefaults.shared.app_LATITUDE = ""
              AppDefaults.shared.app_LONGITUDE = ""
              AppDefaults.shared.appColor_Name = ""
              AppDefaults.shared.currentJobActive = "0"
              AppDefaults.shared.currentJobID = "0"
              AppDefaults.shared.synced_IDs = [""]
              AppDefaults.shared.CompanyID = ""
              // AppDefaults.shared.userDeviceToken = ""
              configs.kAppdelegate.setRootViewController()
          }
    
    func deleteApi(url : String,Target : UIViewController,showLoader:Bool, completionResponse:@escaping (Any) -> (),completionnilResponse:  @escaping ((String)) -> Void)
    {
        if AllUtilies.isConnectedToInternet
        {
            view = Target
            if (showLoader == true)
            {
              view!.StartIndicator(message: kLoading)
            }
            
            
            let urlComplete = url
            print(urlComplete)
            
            let headers = ["Authorization": AppDefaults.shared.userJWT_Token]
            
            
            print(AppDefaults.shared.userJWT_Token)
            Alamofire.request(urlComplete, method: .delete, parameters: nil, encoding: URLEncoding.default, headers : headers)
                .responseJSON { response in
                    
                    if (showLoader == true)
                    {
                      self.view!.StopIndicator()
                    }
                    
                    
                    print(response)
                    switch response.result{
                    case .success:
                        guard let data = response.value else{return}
                        let responseData  = data as! [String : Any]
                        guard let statusCode = responseData["code"] as? Int else{
                            return
                        }
                        if statusCode == 200
                        {
                            completionResponse(response.result.value as Any)
                        }
                        else
                        {
                            guard let message = responseData["message"] as? String else {return}
                            
                            if  statusCode == 401
                            {
                               // Target.showErrorMessage(titleStr: kAppName, messageStr:message)
                                Target.AlertMessageWithOkAction(titleStr: kAppName, messageStr: message, Target: Target)
                                {
                                    self.empty_data()
                                    self.logoutUser(trgt: Target)
                                }
                            }
                            else if statusCode == 403
                            {
                                //  if let Result = responseData["result"] as? [String:Any]
                                //  {
                                //      self.MoveToSignuP(mobileNum: Result["mobilePhone"] as! String, UserID: Result["userId"] as! Int, countryCode: Result["countryCode"] as! String, View: Target)
                                //  }
                                
                                Target.showErrorMessage(titleStr: kAppName, messageStr:message)
                            }
                            else if statusCode == 404
                            {
                                Target.showErrorMessage(titleStr: kAppName, messageStr:message)
                            }
                            else if statusCode == 204
                            {
                                Target.showErrorMessage(titleStr: kAppName, messageStr:message)
                            }
                            else if statusCode == 500
                            {
                                Target.showErrorMessage(titleStr: kAppName, messageStr:message)
                            }
                            else
                            {
                                completionnilResponse(message)
                            }
                        }
                    case .failure(let error):
                        print(error)
                        Target.showAlertMessage(titleStr: kAppName, messageStr: error.localizedDescription)
                    }
            }
        }
        else
        {
            Target.showAlertMessage(titleStr: kAppName, messageStr: "Internet Error")
        }
    }
    
    
    
    func GetApiForSearch(url : String,Target : UIViewController, completionResponse:@escaping (Any) -> (),completionnilResponse:  @escaping ((String)) -> Void)
    {
        if AllUtilies.isConnectedToInternet{
            view = Target
            // view!.StartIndicator(message: "Loading")
            let urlComplete = url
            print(urlComplete)
            
            
           
            
            let headers = ["Content-Type" : "application/json","Authorization": AppDefaults.shared.userJWT_Token]
            
            
            print(AppDefaults.shared.userJWT_Token)
            
            
            Alamofire.request(urlComplete, method: .get, parameters: nil, encoding: URLEncoding.default, headers : headers)
                .responseJSON{ response in
                    //   self.view!.StopIndicator()
                    print(response)
                    switch response.result{
                    case .success:
                        guard let data = response.value else{return}
                        guard let responseData  = data as? [String : Any] else{
                            return
                        }
                        guard let statusCode = responseData["code"] as? Int else{
                            return
                        }
                        if statusCode == 200
                        {
                            completionResponse(response.result.value as Any)
                        }
                        else
                        {
                            guard let message = responseData["message"] as? String else {return}
                            
                            if  statusCode == 401
                            {
                               // Target.showErrorMessage(titleStr: kAppName, messageStr:message)
                                Target.AlertMessageWithOkAction(titleStr: kAppName, messageStr: message, Target: Target)
                                {
                                    self.empty_data()
                                    self.logoutUser(trgt: Target)
                                }
                            }
                            else if statusCode == 403
                            {
                                //  if let Result = responseData["result"] as? [String:Any]
                                //  {
                                //      self.MoveToSignuP(mobileNum: Result["mobilePhone"] as! String, UserID: Result["userId"] as! Int, countryCode: Result["countryCode"] as! String, View: Target)
                                //  }
                                
                                Target.showErrorMessage(titleStr: kAppName, messageStr:message)
                            }
                            else if statusCode == 404
                            {
                                Target.showErrorMessage(titleStr: kAppName, messageStr:message)
                            }
                            else if statusCode == 204
                            {
                                Target.showErrorMessage(titleStr: kAppName, messageStr:message)
                            }
                            else if statusCode == 500
                            {
                                Target.showErrorMessage(titleStr: kAppName, messageStr:message)
                            }
                            else
                            {
                                completionnilResponse(message)
                            }
                        }
                    case .failure(let error):
                        print(error)
                        Target.showAlertMessage(titleStr: kAppName, messageStr: error.localizedDescription)
                    }
            }
        }
        else
        {
            Target.showAlertMessage(titleStr: kAppName, messageStr: "InternetError")
        }
    }
    
    func uploadDataMultiPart(mediaType:MediaType,url:String, postdatadictionary: [String: Any],Target : UIViewController, completionResponse:  @escaping ([String : Any]) -> Void,completionnilResponse:  @escaping (String) -> Void,completionError: @escaping (Error?) -> Void){
        
        if AllUtilies.isConnectedToInternet
        {
            view = Target
            view!.StartIndicator(message: kLoading)
            let urlComplete = url
            print(urlComplete)
            
            
            let headers = ["Content-Type" : "multipart/form-data","Authorization": AppDefaults.shared.userJWT_Token]
            
            print(AppDefaults.shared.userJWT_Token)
            
            var type = "images"
            var randomFileName = ""
            var mimType = ""
            
            Commands.println(object: postdatadictionary)
            let configuration = URLSessionConfiguration.default
            configuration.timeoutIntervalForRequest = 1200
            let alamoManager = Alamofire.SessionManager(configuration: configuration)
            
            Commands.println(object:postdatadictionary)
            alamoManager.upload(multipartFormData: { (multipartFormData) in
                
                for (key, value) in postdatadictionary {
                    Commands.println(object:value)
                    Commands.println(object:key)
                    
                    if(value is URL)
                    {
                        switch mediaType {
                        case .Image:
                            mimType = "Image/jpg"
                            randomFileName = "/\(Double(Date.timeIntervalSinceReferenceDate * 1000)).jpg"
                            type = "images"
                        case .Song:
                            mimType = "Audio/mp3"
                            randomFileName = "/\(Double(Date.timeIntervalSinceReferenceDate * 1000)).mp3"
                            type = "music"
                        case .Video:
                            mimType = "Video/mp4"
                            randomFileName = "/\(Double(Date.timeIntervalSinceReferenceDate * 1000)).mp4"
                            type = "videos"
                        case .Pdf:
                            mimType = "Doc/pdf"
                            randomFileName = "/\(Double(Date.timeIntervalSinceReferenceDate * 1000)).pdf"
                            type = "pdf"
                        case .Graphic:
                            mimType = "Image/jpg"
                            randomFileName = "/\(Double(Date.timeIntervalSinceReferenceDate * 1000)).jpg"
                            type = "graphics"
                        }
                        multipartFormData.append(value as! URL , withName: key, fileName: randomFileName, mimeType: mimType)
                        //multipartFormData.app
                    }
                        
                    else if let Item = value as? String
                    {
                        print(Item)
                        multipartFormData.append("\(Item)".data(using: String.Encoding.utf8)!, withName: key as String)
                    }
                    else if let Item = value as? Int
                    {
                        print(Item)
                        multipartFormData.append("\(Item)".data(using: String.Encoding.utf8)!, withName: key as String)
                        
                    }
                    else if let Item = value as? [String]
                    {
                        
                        for (i,value) in Item.enumerated()
                        {
                            multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key + "[" + "\(i)" + "]")
                        }
                    }
                    else
                    {
                        multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
                        
                    }
                }
                
            }, usingThreshold: UInt64.init(), to: url , method: .post, headers: headers) { (result) in
                switch result{
                case .success(let upload, _, _):
                    upload.responseJSON { response in
                        
                        print(response.result.value as Any)
                        self.view!.StopIndicator()
                        guard let data = response.value else{return}
                        guard let responseData  = data as? [String : Any] else{
                            return
                        }
                        guard let statusCode = responseData["code"] as? Int else{
                            return
                        }
                        if statusCode == 200
                        {
                            print(responseData)
                            completionResponse(response.result.value as Any as! [String : Any])
                        }
                        else
                        {
                            guard let message = responseData["message"] as? String else {return}
                            
                            if  statusCode == 401
                            {
                               // Target.showErrorMessage(titleStr: kAppName, messageStr:message)
                                Target.AlertMessageWithOkAction(titleStr: kAppName, messageStr: message, Target: Target)
                                {
                                    self.empty_data()
                                    self.logoutUser(trgt: Target)
                                }
                            }
                            else if statusCode == 403
                            {
                                //  if let Result = responseData["result"] as? [String:Any]
                                //  {
                                //      self.MoveToSignuP(mobileNum: Result["mobilePhone"] as! String, UserID: Result["userId"] as! Int, countryCode: Result["countryCode"] as! String, View: Target)
                                //  }
                                
                                Target.showErrorMessage(titleStr: kAppName, messageStr:message)
                            }
                            else if statusCode == 404
                            {
                                Target.showErrorMessage(titleStr: kAppName, messageStr:message)
                            }
                            else if statusCode == 204
                            {
                                Target.showErrorMessage(titleStr: kAppName, messageStr:message)
                            }
                            else if statusCode == 500
                            {
                                Target.showErrorMessage(titleStr: kAppName, messageStr:message)
                            }
                            else
                            {
                                completionnilResponse(message)
                            }
                        }
                        print(response.value as Any)
                        alamoManager.session.invalidateAndCancel()
                        
                    }
                case .failure(let error):
                    print("Error in upload: \(error.localizedDescription)")
                    Target.showAlertMessage(titleStr: kAppName, messageStr: error.localizedDescription)
                }
            }
        }
        else
        {
            Target.showAlertMessage(titleStr: kAppName, messageStr: "InternetError")
        }
    }
    
    
    
    
    func uploadDataMulti(mediaType:MediaType,url:String, postdatadictionary: [String: Any],Target : UIViewController,isTarckStatus:Bool, completionResponse:  @escaping ([String : Any]) -> Void,completionnilResponse:  @escaping (String) -> Void,completionError: @escaping (Error?) -> Void){
        
        if AllUtilies.isConnectedToInternet
        {
            view = Target
            view!.StartIndicator(message: kLoading)
            let urlComplete =   url
            print(urlComplete)
            
           var headers = HTTPHeaders()
            if isTarckStatus == true{
                           headers    = ["Content-Type" : "application/json","Authorization": AppDefaults.shared.userJWT_Token]//,"CompanyId":AppDefaults.shared.CompanyID]
            }else{
             headers = ["Content-Type" : "multipart/form-data","Authorization": AppDefaults.shared.userJWT_Token]
            }
                       
            let randomFileName = ""
            var mimType = ""
            
            Commands.println(object: postdatadictionary)
            let configuration = URLSessionConfiguration.default
            configuration.timeoutIntervalForRequest = 1200
            let alamoManager = Alamofire.SessionManager(configuration: configuration)
            
            Commands.println(object:postdatadictionary)
            alamoManager.upload(multipartFormData: { (multipartFormData) in
                for (key, value) in postdatadictionary {
                    Commands.println(object: postdatadictionary)
                    Commands.println(object: value)
                    if let arrData = value as? [[String:Any]]
                    {
                        print(arrData)
                        for item in arrData
                        {
                            if let fileType = item["fileType"] as? String
                            {
                                if(fileType == "Image")
                                {
                                    mimType = "Image/jpg"
                               multipartFormData.append(item["url"] as! URL , withName: key, fileName: randomFileName, mimeType: mimType)
                                   // multipartFormData.append(item["url"] as! URL, withName: key)
                                    
                                }
                                else if(fileType == "Video")
                                {
                                    mimType = "Video/mp4"
                                    multipartFormData.append(item["url"]  as! URL , withName: key, fileName: randomFileName, mimeType: mimType)
                                }
                                
                            }
                        }
                    }
                    else
                    {
                        multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
                    }
                }
                
            }, usingThreshold: UInt64.init(), to: url , method: .post, headers: headers) { (result) in
                switch result{
                case .success(let upload, _, _):
                    upload.responseJSON { response in
                        print(response.result.value as Any)
                        self.view!.StopIndicator()
                        guard let data = response.value else{return}
                        guard let responseData  = data as? [String : Any] else{
                            return
                        }
                        guard let statusCode = responseData["code"] as? Int else{
                            return
                        }
                        if statusCode == 200
                        {
                            print(responseData)
                            completionResponse(response.result.value as Any as! [String : Any])
                        }
                        else
                        {
                            guard let message = responseData["message"] as? String else {return}
                            
                            if  statusCode == 401
                            {
                               // Target.showErrorMessage(titleStr: kAppName, messageStr:message)
                                Target.AlertMessageWithOkAction(titleStr: kAppName, messageStr: message, Target: Target)
                                {
                                    self.empty_data()
                                    self.logoutUser(trgt: Target)
                                }
                            }
                            else if statusCode == 403
                            {
                                //  if let Result = responseData["result"] as? [String:Any]
                                //  {
                                //      self.MoveToSignuP(mobileNum: Result["mobilePhone"] as! String, UserID: Result["userId"] as! Int, countryCode: Result["countryCode"] as! String, View: Target)
                                //  }
                                
                                Target.showErrorMessage(titleStr: kAppName, messageStr:message)
                            }
                            else if statusCode == 404
                            {
                                Target.showErrorMessage(titleStr: kAppName, messageStr:message)
                            }
                            else if statusCode == 204
                            {
                                Target.showErrorMessage(titleStr: kAppName, messageStr:message)
                            }
                            else if statusCode == 500
                            {
                                Target.showErrorMessage(titleStr: kAppName, messageStr:message)
                            }
                                else if statusCode == 400
                                                         {
                                                             Target.showErrorMessage(titleStr: kAppName, messageStr:message)
                                                         }
                            else
                            {
                                completionnilResponse(message)
                            }
                            
                        }
                        print(response.value as Any)
                        alamoManager.session.invalidateAndCancel()
                        
                    }
                case .failure(let error):
                    print("Error in upload: \(error.localizedDescription)")
                    Target.showAlertMessage(titleStr: kAppName, messageStr: error.localizedDescription)
                }
            }
        }
        else
        {
            Target.showAlertMessage(titleStr: kAppName, messageStr: "InternetError")
        }
    }
    
    
    
    
    func uploadDataMulti_PUT(mediaType:MediaType,url:String, postdatadictionary: [String: Any],Target : UIViewController, completionResponse:  @escaping ([String : Any]) -> Void,completionnilResponse:  @escaping (String) -> Void,completionError: @escaping (Error?) -> Void){
        if AllUtilies.isConnectedToInternet
        {
            view = Target
            view!.StartIndicator(message: kLoading)
            let urlComplete =   url
            print(urlComplete)
           
            let headers = ["Content-Type" : "multipart/form-data","Authorization": AppDefaults.shared.userJWT_Token]
          
            
            let randomFileName = ""
            var mimType = ""
            
            Commands.println(object: postdatadictionary)
            let configuration = URLSessionConfiguration.default
            configuration.timeoutIntervalForRequest = 1200
            let alamoManager = Alamofire.SessionManager(configuration: configuration)
            
            Commands.println(object:postdatadictionary)
            alamoManager.upload(multipartFormData: { (multipartFormData) in
                for (key, value) in postdatadictionary {
                    Commands.println(object: postdatadictionary)
                    Commands.println(object: value)
                    if let arrData = value as? [[String:Any]]
                    {
                        print(arrData)
                        for item in arrData
                        {
                            if let fileType = item["fileType"] as? String
                            {
                                if(fileType == "Image")
                                {
                                    mimType = "Image/jpg"
                               multipartFormData.append(item["url"] as! URL , withName: key, fileName: randomFileName, mimeType: mimType)
                                   // multipartFormData.append(item["url"] as! URL, withName: key)
                                    
                                }
                                else if(fileType == "Video")
                                {
                                    mimType = "Video/mp4"
                                    multipartFormData.append(item["url"]  as! URL , withName: key, fileName: randomFileName, mimeType: mimType)
                                }
                                
                            }
                        }
                    }
                    else
                    {
                        multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
                    }
                }
                
            }, usingThreshold: UInt64.init(), to: url , method: .put, headers: headers) { (result) in
                switch result{
                case .success(let upload, _, _):
                    upload.responseJSON { response in
                        print(response.result.value as Any)
                        self.view!.StopIndicator()
                        guard let data = response.value else{return}
                        guard let responseData  = data as? [String : Any] else{
                            return
                        }
                        guard let statusCode = responseData["code"] as? Int else{
                            return
                        }
                        if statusCode == 200
                        {
                            print(responseData)
                            completionResponse(response.result.value as Any as! [String : Any])
                        }
                        else
                        {
                            guard let message = responseData["message"] as? String else {return}
                            
                            if  statusCode == 401
                            {
                               // Target.showErrorMessage(titleStr: kAppName, messageStr:message)
                                Target.AlertMessageWithOkAction(titleStr: kAppName, messageStr: message, Target: Target)
                                {
                                    self.empty_data()
                                    self.logoutUser(trgt: Target)
                                }
                            }
                            else if statusCode == 403
                            {
                                //  if let Result = responseData["result"] as? [String:Any]
                                //  {
                                //      self.MoveToSignuP(mobileNum: Result["mobilePhone"] as! String, UserID: Result["userId"] as! Int, countryCode: Result["countryCode"] as! String, View: Target)
                                //  }
                                
                                Target.showErrorMessage(titleStr: kAppName, messageStr:message)
                            }
                            else if statusCode == 404
                            {
                                Target.showErrorMessage(titleStr: kAppName, messageStr:message)
                            }
                            else if statusCode == 204
                            {
                                Target.showErrorMessage(titleStr: kAppName, messageStr:message)
                            }
                            else if statusCode == 500
                            {
                                Target.showErrorMessage(titleStr: kAppName, messageStr:message)
                            }
                                else if statusCode == 400
                                                         {
                                                             Target.showErrorMessage(titleStr: kAppName, messageStr:message)
                                                         }
                            else
                            {
                                completionnilResponse(message)
                            }
                            
                        }
                        print(response.value as Any)
                        alamoManager.session.invalidateAndCancel()
                        
                    }
                case .failure(let error):
                    print("Error in upload: \(error.localizedDescription)")
                    Target.showAlertMessage(titleStr: kAppName, messageStr: error.localizedDescription)
                }
            }
        }
        else
        {
            Target.showAlertMessage(titleStr: kAppName, messageStr: "InternetError")
        }
    }
    
    
    func uploadDataMulti_signup(mediaType:MediaType,url:String, postdatadictionary: [String: Any],Target : UIViewController, completionResponse:  @escaping ([String : Any]) -> Void,completionnilResponse:  @escaping (String) -> Void,completionError: @escaping (Error?) -> Void)
    {
        if AllUtilies.isConnectedToInternet{
            view = Target
            view!.StartIndicator(message: kLoading)
            let urlComplete = url
            print(urlComplete)
            
            
          
            let headers = ["Content-Type" : "application/json","x-access-token": AppDefaults.shared.userJWT_Token]
            
            
            //  var type = ""
            let randomFileName = ""
            var mimType = ""
            
            Commands.println(object: postdatadictionary)
            let configuration = URLSessionConfiguration.default
            configuration.timeoutIntervalForRequest = 1200
            let alamoManager = Alamofire.SessionManager(configuration: configuration)
            
            Commands.println(object:postdatadictionary)
            alamoManager.upload(multipartFormData: { (multipartFormData) in
                for (key, value) in postdatadictionary {
                    Commands.println(object: postdatadictionary)
                    Commands.println(object: value)
                    if let arrData = value as? [[String:Any]]
                    {
                        print(arrData)
                        for item in arrData
                        {
                            if let fileType = item["fileType"] as? String
                            {
                                if(fileType == "Image")
                                {
                                    mimType = "Image/jpg"
                                    multipartFormData.append(item["url"] as! URL , withName: key, fileName: randomFileName, mimeType: mimType)
                                    
                                }
                                else if(fileType == "Video")
                                {
                                    mimType = "Video/mp4"
                                    multipartFormData.append(item["url"]  as! URL , withName: key, fileName: randomFileName, mimeType: mimType)
                                }
                                
                            }
                        }
                    }
                    else
                    {
                        multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
                    }
                }
                
            }, usingThreshold: UInt64.init(), to: url , method: .post, headers: headers) { (result) in
                switch result{
                case .success(let upload, _, _):
                    upload.responseJSON { response in
                        print(response.result.value as Any)
                        self.view!.StopIndicator()
                        guard let data = response.value else{return}
                        guard let responseData  = data as? [String : Any] else{
                            return
                        }
                        guard let statusCode = responseData["code"] as? Int else{
                            return
                        }
                        if statusCode == 200
                        {
                            print(responseData)
                            completionResponse(response.result.value as Any as! [String : Any])
                        }
                        else
                        {
                            guard let message = responseData["message"] as? String else {return}
                            
                            if  statusCode == 401
                            {
                               // Target.showErrorMessage(titleStr: kAppName, messageStr:message)
                                Target.AlertMessageWithOkAction(titleStr: kAppName, messageStr: message, Target: Target)
                                {
                                    self.empty_data()
                                    self.logoutUser(trgt: Target)
                                }
                            }
                            else if statusCode == 403
                            {
                                //  if let Result = responseData["result"] as? [String:Any]
                                //  {
                                //      self.MoveToSignuP(mobileNum: Result["mobilePhone"] as! String, UserID: Result["userId"] as! Int, countryCode: Result["countryCode"] as! String, View: Target)
                                //  }
                                
                                Target.showErrorMessage(titleStr: kAppName, messageStr:message)
                            }
                            else if statusCode == 404
                            {
                                Target.showErrorMessage(titleStr: kAppName, messageStr:message)
                            }
                            else if statusCode == 204
                            {
                                Target.showErrorMessage(titleStr: kAppName, messageStr:message)
                            }
                            else if statusCode == 500
                            {
                                Target.showErrorMessage(titleStr: kAppName, messageStr:message)
                            }
                            else
                            {
                                completionnilResponse(message)
                            }
                            
                        }
                        print(response.value as Any)
                        alamoManager.session.invalidateAndCancel()
                        
                    }
                case .failure(let error):
                    print("Error in upload: \(error.localizedDescription)")
                    Target.showAlertMessage(titleStr: kAppName, messageStr: error.localizedDescription)
                }
            }
        }
        else
        {
            Target.showAlertMessage(titleStr: kAppName, messageStr: "InternetError")
        }
    }
    
    
    
    func uploadData_Multiple_image(mediaType:MediaType,url:String, postdatadictionary: [String: Any],Target : UIViewController, completionResponse:  @escaping ([String : Any]) -> Void,completionnilResponse:  @escaping (String) -> Void,completionError: @escaping (Error?) -> Void){
        if AllUtilies.isConnectedToInternet
        {
            view = Target
            view!.StartIndicator(message: kLoading)
            let urlComplete = url
            print(urlComplete)
            
         
            
            let headers = ["Content-Type" : "application/json","x-access-token": AppDefaults.shared.userJWT_Token]
            
            var mimType = ""
            
            Commands.println(object: postdatadictionary)
            let configuration = URLSessionConfiguration.default
            configuration.timeoutIntervalForRequest = 1200
            let alamoManager = Alamofire.SessionManager(configuration: configuration)
            
            Commands.println(object:postdatadictionary)
            alamoManager.upload(multipartFormData: { (multipartFormData) in
                for (key, value) in postdatadictionary {
                    Commands.println(object: postdatadictionary)
                    Commands.println(object: value)
                    if let arrData = value as? [[String:Any]]
                    {
                        print(arrData)
                        for item in arrData
                        {
                            if let fileType = item["fileType"] as? String
                            {
                                if(fileType == "Image")
                                {
                                    let filename = item["fileName"]as? String ?? "Image"
                                    mimType = "Image/jpg"
                                    let img = item["imageData"] as? UIImage
                                    
                                    if let imageData = img!.jpegData(compressionQuality: 0.5) as Any as? Data
                                    {
                                        multipartFormData.append(imageData, withName: filename, fileName: "image", mimeType: mimType)
                                    }
                                }
                                else if(fileType == "Video")
                                {
                                    mimType = "Video/mp4"
                                    multipartFormData.append(item["imageData"]  as! URL , withName: key, fileName: "", mimeType: mimType)
                                }
                                
                            }
                        }
                    }
                    else
                    {
                        multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
                    }
                }
                
            }, usingThreshold: UInt64.init(), to: url , method: .post, headers: headers) { (result) in
                switch result{
                case .success(let upload, _, _):
                    upload.responseJSON { response in
                        print(response.result.value as Any)
                        self.view!.StopIndicator()
                        guard let data = response.value else{return}
                        guard let responseData  = data as? [String : Any] else{
                            return
                        }
                        guard let statusCode = responseData["code"] as? Int else{
                            return
                        }
                        if statusCode == 200
                        {
                            print(responseData)
                            completionResponse(response.result.value as Any as! [String : Any])
                        }
                        else
                        {
                            guard let message = responseData["message"] as? String else {return}
                            
                            if  statusCode == 401
                            {
                               // Target.showErrorMessage(titleStr: kAppName, messageStr:message)
                                Target.AlertMessageWithOkAction(titleStr: kAppName, messageStr: message, Target: Target)
                                {
                                    self.empty_data()
                                    self.logoutUser(trgt: Target)
                                }
                            }
                            else if statusCode == 403
                            {
                                //  if let Result = responseData["result"] as? [String:Any]
                                //  {
                                //      self.MoveToSignuP(mobileNum: Result["mobilePhone"] as! String, UserID: Result["userId"] as! Int, countryCode: Result["countryCode"] as! String, View: Target)
                                //  }
                                
                                Target.showErrorMessage(titleStr: kAppName, messageStr:message)
                            }
                            else if statusCode == 404
                            {
                                Target.showErrorMessage(titleStr: kAppName, messageStr:message)
                            }
                            else if statusCode == 204
                            {
                                Target.showErrorMessage(titleStr: kAppName, messageStr:message)
                            }
                            else if statusCode == 500
                            {
                                Target.showErrorMessage(titleStr: kAppName, messageStr:message)
                            }
                            else
                            {
                                completionnilResponse(message)
                            }
                            
                        }
                        print(response.value as Any)
                        alamoManager.session.invalidateAndCancel()
                        
                    }
                case .failure(let error):
                    print("Error in upload: \(error.localizedDescription)")
                    Target.showAlertMessage(titleStr: kAppName, messageStr: error.localizedDescription)
                }
            }
        }
        else
        {
            Target.showAlertMessage(titleStr: kAppName, messageStr: "InternetError")
        }
    }
    
    
    
    //Working code for multy images
    func uploadData_Multiple(mediaType:MediaType,url:String, postdatadictionary: [String: Any],Target : UIViewController, completionResponse:  @escaping ([String : Any]) -> Void,completionnilResponse:  @escaping (String) -> Void,completionError: @escaping (Error?) -> Void){
        if AllUtilies.isConnectedToInternet
        {
            view = Target
            view!.StartIndicator(message: kLoading)
            let urlComplete = url
            print(urlComplete)
            
            
            
            let headers = ["Content-Type" : "multipart/form-data","Authorization": AppDefaults.shared.userJWT_Token]
            
            var mimType = ""
            
            
            Commands.println(object: postdatadictionary)
            let configuration = URLSessionConfiguration.default
            configuration.timeoutIntervalForRequest = 1200
            let alamoManager = Alamofire.SessionManager(configuration: configuration)
            
            Commands.println(object:postdatadictionary)
            alamoManager.upload(multipartFormData: { (multipartFormData) in
                for (key, value) in postdatadictionary
                {
                    Commands.println(object: postdatadictionary)
                    Commands.println(object: value)
                    
                    if let arrData = value as? [[String:Any]]
                    {
                        print(arrData)
                        for item in arrData
                        {
                            if let fileType = item["fileType"] as? String
                            {
                                if(fileType == "Image")
                                {
                                    //let filename = item["fileName"]as? String ?? "Image"
                                    mimType = "Image/jpg"
                                    let img = item["imageData"] as? UIImage
                                    let imageKeyName = item["imageKey"] as? String ?? ""
                                    let randomFileName = Target.generateRandomString()
                                    
                                    if let imageData = img!.jpegData(compressionQuality: 0.5) as Any as? Data
                                    {
                                        multipartFormData.append(imageData, withName: imageKeyName, fileName: "\(randomFileName).jpg", mimeType: mimType)
                                    }
                                }
                                else if(fileType == "Video")
                                {
                                    let randomFileName = Target.generateRandomString()
                                    mimType = "Video/mp4"
                                    multipartFormData.append(item["imageData"]  as! URL , withName: key, fileName: "\(randomFileName).mp4", mimeType: mimType)
                                }
                                
                            }
                            else
                            {
                                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
                            }
                        }
                    }
                    else
                    {
                        multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
                    }
                }
                
            }, usingThreshold: UInt64.init(), to: url , method: .post, headers: headers) { (result) in
                switch result{
                case .success(let upload, _, _):
                    upload.responseJSON { response in
                        print(response.result.value as Any)
                        self.view!.StopIndicator()
                        guard let data = response.value else{return}
                        guard let responseData  = data as? [String : Any] else
                        {
                            Target.showToastSwift(alrtType:.error,msg:kSomthingWrong,title:kOops)
                            return
                        }
                        guard let statusCode = responseData["code"] as? Int else
                        {
                            Target.showToastSwift(alrtType:.error,msg:kSomthingWrong,title:kOops)
                            return
                        }
                        if statusCode == 200
                        {
                            print(responseData)
                            completionResponse(response.result.value as Any as! [String : Any])
                        }
                        else
                        {
                            guard let message = responseData["message"] as? String else {return}
                            
                            if  statusCode == 401
                            {
                               // Target.showErrorMessage(titleStr: kAppName, messageStr:message)
                                Target.AlertMessageWithOkAction(titleStr: kAppName, messageStr: message, Target: Target)
                                {
                                    self.empty_data()
                                    self.logoutUser(trgt: Target)
                                }
                            }
                            else if statusCode == 403
                            {
                                Target.showErrorMessage(titleStr: kAppName, messageStr:message)
                            }
                            else if statusCode == 404
                            {
                                Target.showErrorMessage(titleStr: kAppName, messageStr:message)
                            }
                            else if statusCode == 204
                            {
                                Target.showErrorMessage(titleStr: kAppName, messageStr:message)
                            }
                            else if statusCode == 500
                            {
                                Target.showErrorMessage(titleStr: kAppName, messageStr:message)
                            }
                            else
                            {
                                completionnilResponse(message)
                            }
                            
                        }
                        print(response.value as Any)
                        alamoManager.session.invalidateAndCancel()
                        
                    }
                case .failure(let error):
                    print("Error in upload: \(error.localizedDescription)")
                    Target.showToastSwift(alrtType:.info,msg:error.localizedDescription,title:kOops)
                }
            }
        }
        else
        {
            Target.showToastSwift(alrtType:.info,msg:interntOff,title:kOops)
        }
    }
    
    
    
    
    
    func  MoveToSignuP(mobileNum: String,UserID : Int,countryCode: String,View : UIViewController)
    {
        
        View.AlertMessageWithOkAction(titleStr: kAppName, messageStr: "Please complete signup process", Target: View)
        {
            // let vc = UIStoryboard.init(name: "Auth", bundle: Bundle.main).instantiateViewController(withIdentifier: "SignUpVC") as? SignUpVC
            //  vc?.mobileNum = mobileNum
            //  vc?.UserID = UserID
            //  vc?.countryCode = countryCode
            //  View.navigationController?.pushViewController(vc!, animated: true)
        }
    }
    

    func logoutUser(trgt:UIViewController)
    {
       // let controller = SideMenuVC()
       // controller.emptyData()
        
        let cotntroller = Navigation.GetInstance(of: .LoginWithPhoneVC)as! LoginWithPhoneVC
        trgt.push_To_Controller(from_controller: trgt, to_Controller: cotntroller)
    }
    
}

