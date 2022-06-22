//
//  UIViewController.swift
//  BidJones
//
//  Created by Rakesh Kumar on 3/22/18.
//  Copyright © 2018 Seasia. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import Photos
import MobileCoreServices
import NVActivityIndicatorView
import SwiftMessages

public enum SwiftMessage
{
    case warning, success, statusRed,statusOrange,statusGreen,info,error
}

//MARK: - UIViewController Extnesion
extension UIViewController: NVActivityIndicatorViewable
{
    func hideKeyboardWhenTappedAround()
    {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    func hideKeyboard()
    {
        self.view.endEditing(true)
    }
    
    func convert_Array(arr:NSMutableArray) -> String
    {
        do
        {
            let data = try JSONSerialization.data(withJSONObject: arr)
            let dataString = String(data: data, encoding: .utf8)!
            print(dataString)
            return dataString
        }
        catch
        {
            print("JSON serialization failed: ", error)
            return ""
        }
    }
    
    func StartIndicator(message: String)
    {
        if(!AllUtilies.isAnimating)
        {
            AllUtilies.isAnimating = true
            let size = CGSize(width: 30, height: 30)
            startAnimating(size, message: message, type: .ballBeat, fadeInAnimation: nil)
            DispatchQueue.main.async {
                NVActivityIndicatorPresenter.sharedInstance.setMessage(message)
            }
        }
        //            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.5) {
        //                       NVActivityIndicatorPresenter.sharedInstance.setMessage("Authenticating...")
        //                   }
    }
    func StopIndicator()
    {
        AllUtilies.isAnimating = false
        DispatchQueue.main.async()
            {
                self.stopAnimating(nil)
        }
    }
    
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    //MARK: - GallaryCamera Actionc
    
    func OpenGallaryCamera(pickerController : UIImagePickerController)
    {
        let alert = UIAlertController(title: KChooseImage, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: KCamera, style: .default, handler: { _ in
            if AVCaptureDevice.authorizationStatus(for: .video) ==  .authorized {
                //  Open Camera
                if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera)
                {
                    pickerController.delegate = self as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
                    pickerController.sourceType = UIImagePickerController.SourceType.camera
                    pickerController.allowsEditing = true
                    pickerController.mediaTypes = [kUTTypeImage as String]
                    
                    //  pickerController.mediaTypes = [kUTTypeMovie as String]
                    //   UIImagePickerController.availableMediaTypes(for:.camera)!;
                    self.present(pickerController, animated: true, completion: nil)
                }
                else {
                    self.showAlertMessage(titleStr: kAppName, messageStr: KYoudonthavecamera)
                }
                
            } else
            {
                // Open setting alert for camera
                let alert = UIAlertController(title: KOpenSettingForCamera , message: "", preferredStyle: UIAlertController.Style.alert)
                
                alert.addAction(UIAlertAction(title: KCancel, style: .default))
                alert.addAction(UIAlertAction(title: KSettings, style: .cancel) { (alert) -> Void in
                    UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                })
                self.present(alert, animated: true)
                ////////
            }
        }))
        alert.addAction(UIAlertAction(title: KGallery, style: .default, handler: { _ in
            let status = PHPhotoLibrary.authorizationStatus()
            switch status {
            case .authorized:
                // Open Gallary
                if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary) {
                    pickerController.delegate = self as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
                    pickerController.sourceType = UIImagePickerController.SourceType.photoLibrary
                    pickerController.mediaTypes = [kUTTypeImage as String]
                    pickerController.allowsEditing = true
                    self.present(pickerController, animated: true, completion: nil)
                    /////////
                }
            case .denied, .restricted:
                // Open setting Alert for galllary
                // Open setting alert for camera
                let alert = UIAlertController(title: KOpenSettingForPhotos , message: "", preferredStyle: UIAlertController.Style.alert)
                
                alert.addAction(UIAlertAction(title: KCancel, style: .default))
                alert.addAction(UIAlertAction(title: KSettings, style: .cancel) { (alert) -> Void in
                    UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                })
                self.present(alert, animated: true)
            //////////
            case .notDetermined:
                break
            @unknown default:
                fatalError()
            }
        }))
        alert.addAction(UIAlertAction.init(title: KCancel, style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    func OpenGallaryCameraForVideo(pickerController : UIImagePickerController)
    {
        let alert = UIAlertController(title: KChooseImage, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: KCamera, style: .default, handler: { _ in
            if AVCaptureDevice.authorizationStatus(for: .video) ==  .authorized {
                //  Open Camera
                if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
                    pickerController.delegate = self as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
                    pickerController.sourceType = UIImagePickerController.SourceType.camera
                    // pickerController.allowsEditing = true
                    pickerController.videoMaximumDuration = 30
                    pickerController.videoQuality = UIImagePickerController.QualityType.typeMedium
                    pickerController.allowsEditing = false
                    pickerController.mediaTypes = [kUTTypeMovie as String]
                    //   UIImagePickerController.availableMediaTypes(for:.camera)!;
                    self.present(pickerController, animated: true, completion: nil)
                }
                else {
                    self.showAlertMessage(titleStr: kAppName, messageStr: KYoudonthavecamera)
                }
                //////////
            } else
            {
                // Open setting alert for camera
                let alert = UIAlertController(title: KOpenSettingForCamera , message: "", preferredStyle: UIAlertController.Style.alert)
                
                alert.addAction(UIAlertAction(title: KCancel, style: .default))
                alert.addAction(UIAlertAction(title: KSettings, style: .cancel) { (alert) -> Void in
                    UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                })
                self.present(alert, animated: true)
                ////////
            }
        }))
        alert.addAction(UIAlertAction(title: KGallery, style: .default, handler: { _ in
            let status = PHPhotoLibrary.authorizationStatus()
            switch status {
            case .authorized:
                // Open Gallary
                if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary) {
                    pickerController.delegate = self as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
                    pickerController.sourceType = UIImagePickerController.SourceType.photoLibrary
                    pickerController.allowsEditing = true
                    pickerController.videoMaximumDuration = 30
                    pickerController.videoQuality = UIImagePickerController.QualityType.typeMedium
                    //pickerController.allowsEditing = true
                    pickerController.mediaTypes = [kUTTypeMovie as String]
                    //   UIImagePickerController.availableMediaTypes(for:.camera)!;
                    self.present(pickerController, animated: true, completion: nil)
                }
            case .denied, .restricted:
                // Open setting Alert for galllary
                // Open setting alert for camera
                let alert = UIAlertController(title: KOpenSettingForPhotos , message: "", preferredStyle: UIAlertController.Style.alert)
                
                alert.addAction(UIAlertAction(title: KCancel, style: .default))
                alert.addAction(UIAlertAction(title: KSettings, style: .cancel) { (alert) -> Void in
                    UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                })
                self.present(alert, animated: true)
            //////////
            case .notDetermined:
                break
            @unknown default:
                fatalError()
            }
        }))
        alert.addAction(UIAlertAction.init(title: KCancel, style: .cancel, handler: nil))
        
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func OpenVideoCamera(pickerController : UIImagePickerController)
    {
        if AVCaptureDevice.authorizationStatus(for: .video) ==  .authorized {
            //  Open Camera
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
                pickerController.delegate = self as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
                pickerController.sourceType = UIImagePickerController.SourceType.camera
                pickerController.allowsEditing = true
                pickerController.videoMaximumDuration = 30
                pickerController.videoQuality = UIImagePickerController.QualityType.typeMedium
                pickerController.allowsEditing = false
                pickerController.mediaTypes = [kUTTypeMovie as String]
                //   UIImagePickerController.availableMediaTypes(for:.camera)!;
                self.present(pickerController, animated: true, completion: nil)
            }
            else {
                self.showAlertMessage(titleStr: kAppName, messageStr: KYoudonthavecamera)
            }
            //////////
        } else
        {
            // Open setting alert for camera
            let alert = UIAlertController(title: KOpenSettingForCamera , message: "", preferredStyle: UIAlertController.Style.alert)
            
            alert.addAction(UIAlertAction(title: KCancel, style: .default))
            alert.addAction(UIAlertAction(title: KSettings, style: .cancel) { (alert) -> Void in
                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
            })
            self.present(alert, animated: true)
            ////////
        }
    }
    
    
    //MARK: - MOHIT Toast CUSTOM
    func showToastSwift(alrtType:SwiftMessage,msg:String,title:String)
    {
        switch alrtType
        {
        case .success:
            
            let success = MessageView.viewFromNib(layout: .cardView)
            success.configureTheme(.success)
            success.configureDropShadow()
            success.configureContent(title: title, body: msg)
            success.button?.isHidden = true
            var successConfig = SwiftMessages.defaultConfig
            successConfig.presentationStyle = .top
            successConfig.duration = .seconds(seconds: 3.0)
            successConfig.presentationContext = .window(windowLevel: UIWindow.Level.normal)
            SwiftMessages.show(config: successConfig, view: success)
            
            break
        case .error:
            
            let error = MessageView.viewFromNib(layout: .tabView)
            error.configureTheme(.error)
            var errorConfig = SwiftMessages.defaultConfig
            errorConfig.presentationStyle = .bottom
            error.configureContent(title: title, body: msg)
            error.button?.isHidden = true
            errorConfig.duration = .seconds(seconds: 4.0)
            SwiftMessages.show(config: errorConfig, view: error)
            
            break
        case .warning:
            
            let warning = MessageView.viewFromNib(layout: .cardView)
            warning.configureTheme(.warning)
            warning.configureDropShadow()
            // let iconText = ["🤔", "😳", "🙄", "😶"].randomElement()!
            warning.configureContent(title: title, body: title, iconText: "")
            warning.button?.isHidden = true
            var warningConfig = SwiftMessages.defaultConfig
            warningConfig.presentationContext = .window(windowLevel: UIWindow.Level.statusBar)
            SwiftMessages.show(config: warningConfig, view: warning)
            
            break
        case .info:
            
            let info = MessageView.viewFromNib(layout: .messageView)
            info.configureTheme(.info)
            info.button?.isHidden = true
            info.configureContent(title: title, body: msg)
            var infoConfig = SwiftMessages.defaultConfig
            infoConfig.presentationStyle = .bottom
            infoConfig.duration = .seconds(seconds: 4.0)
            SwiftMessages.show(config: infoConfig, view: info)
            
            break
            
        case .statusRed:
            
            let status2 = MessageView.viewFromNib(layout: .statusLine)
            status2.backgroundView.backgroundColor = UIColor.red
            status2.bodyLabel?.textColor = UIColor.white
            status2.configureContent(body: msg)
            var status2Config = SwiftMessages.defaultConfig
            status2Config.presentationContext = .window(windowLevel: UIWindow.Level.normal)
            status2Config.preferredStatusBarStyle = .lightContent
            SwiftMessages.show(config: status2Config, view: status2)
            
            break
            
        case .statusOrange:
            
            let status2 = MessageView.viewFromNib(layout: .statusLine)
            status2.backgroundView.backgroundColor = .orange
            status2.bodyLabel?.textColor = UIColor.white
            status2.configureContent(body: msg)
            var status2Config = SwiftMessages.defaultConfig
            status2Config.presentationContext = .window(windowLevel: UIWindow.Level.normal)
            status2Config.preferredStatusBarStyle = .lightContent
            SwiftMessages.show(config: status2Config, view: status2)
            
            break
            
        case .statusGreen:
            
            let status2 = MessageView.viewFromNib(layout: .statusLine)
            status2.backgroundView.backgroundColor = UIColor.green
            status2.bodyLabel?.textColor = UIColor.white
            status2.configureContent(body: msg)
            var status2Config = SwiftMessages.defaultConfig
            status2Config.presentationContext = .window(windowLevel: UIWindow.Level.normal)
            status2Config.preferredStatusBarStyle = .lightContent
            SwiftMessages.show(config: status2Config, view: status2)
            
        }
        
    }
    
    func setStatusBarColor(view:UIView,color:UIColor)
    {
        if #available(iOS 13.0, *)
        {
           // let app = UIApplication.shared
            
            //let statusBarHeight: CGFloat = app.statusBarFrame.size.height
            let statusBarHeight: CGFloat = self.getStatusBarHeight()
            
            let statusbarView = UIView()
            // statusbarView.backgroundColor = Appcolor.get_category_theme()
            // statusbarView.backgroundColor = UIColor.clear
            statusbarView.backgroundColor = color
            view.addSubview(statusbarView)
            
            statusbarView.translatesAutoresizingMaskIntoConstraints = false
            statusbarView.heightAnchor
                .constraint(equalToConstant: statusBarHeight).isActive = true
            statusbarView.widthAnchor
                .constraint(equalTo: view.widthAnchor, multiplier: 1.0).isActive = true
            statusbarView.topAnchor
                .constraint(equalTo: view.topAnchor).isActive = true
            statusbarView.centerXAnchor
                .constraint(equalTo: view.centerXAnchor).isActive = true
            
        }
        else
        {
            let statusBar = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView
            //statusBar?.backgroundColor = Appcolor.get_category_theme()
            statusBar?.backgroundColor = color//UIColor.clear
        }
        
    }
    
    func getStatusBarHeight() -> CGFloat
    {
        var statusBarHeight: CGFloat = 0
        if #available(iOS 13.0, *)
        {
            let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
            statusBarHeight = window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        }
        else
        {
            statusBarHeight = UIApplication.shared.statusBarFrame.height
        }
        return statusBarHeight
    }
    
    //MARK: - Alert and Toast
    
    func AlertMessageWithOkAction(titleStr:String, messageStr:String,Target : UIViewController, completionResponse:@escaping () -> Void) {
        let alert = UIAlertController(title: titleStr, message: messageStr, preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title: KOK, style: UIAlertAction.Style.default) {
            UIAlertAction in
            completionResponse()
        }
        // Add the actions
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func AlertMessageWithOkCancelAction(titleStr:String, messageStr:String,Target : UIViewController, completionResponse:@escaping (String) -> Void) {
        let alert = UIAlertController(title: titleStr, message: messageStr, preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title: KYes, style: UIAlertAction.Style.default) {
            UIAlertAction in
            completionResponse("Yes")
        }
        let CancelAction = UIAlertAction(title: KNo, style: UIAlertAction.Style.default) {
            UIAlertAction in
            completionResponse("No")
        }
        // Add the actions
        alert.addAction(okAction)
        alert.addAction(CancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func showAlertMessage(titleStr:String, messageStr:String)
    {
        let alert = UIAlertController(title: titleStr, message: messageStr, preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title: KOK, style: UIAlertAction.Style.default) {
            UIAlertAction in
        }
        // Add the actions
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func showErrorMessage(titleStr:String, messageStr:String)
    {
        let alert = UIAlertController(title: titleStr, message: messageStr, preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title: KOK, style: UIAlertAction.Style.default)
        {
            UIAlertAction in
            self.backLogout()
        }
        // Add the actions
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    func backLogout()
    {
       // UserDefault.userPhone = ""
       // UserDefault.userId = 0
       // UserDefault.userName = ""
       // UserDefault.userType = ""
       // self.setRootView("LoginVC", storyBoard: "Auth")
    }
    
    
    func showToast(message : String)
    {
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 150, y: self.view.frame.size.height-100, width: 300, height: 35))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        toastLabel.textColor = Appcolor.kThemeColor
        toastLabel.textAlignment = .center;
        toastLabel.font = UIFont(name: "Montserrat-Light", size: 8.0)
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        configs.kAppdelegate.window?.addSubview(toastLabel)
        UIView.animate(withDuration: 2.0, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
    
    //MARK: - Screen width
    
    func ViewHeight() -> CGFloat
    {
        return UIScreen.main.bounds.size.height
    }
    //MARK: - Screen Height
    
    func ViewWidth() -> CGFloat
    {
        return UIScreen.main.bounds.size.width
    }
    
   
    //MARK: - Navigatin after Alert
    
    func AlertWithNavigation(message: String, completion: @escaping() -> (Void))
    {
        let alertController = UIAlertController(title: kAppName, message: message, preferredStyle: .alert)
        // Create the actions
        let okAction = UIAlertAction(title: AlertTitles.Ok, style: UIAlertAction.Style.default)
        {
            UIAlertAction in
            completion()
        }
        self.dismiss(animated: true, completion: nil)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
   
    
    //MARK: - ThumbNail From Video Url
    
    func getThumbnailImage(forUrl url: URL) -> UIImage?
    {
        
        guard let videoTrack = AVAsset(url: url).tracks(withMediaType: AVMediaType.video).first else {
            return nil
        }
        let transformedVideoSize = videoTrack.naturalSize.applying(videoTrack.preferredTransform)
        let videoIsPortrait = abs(transformedVideoSize.width) < abs(transformedVideoSize.height)
        print("Mode : \(videoIsPortrait)")
        let asset:AVAsset = AVAsset(url: url)
        let assetImageGenerator = AVAssetImageGenerator(asset: asset)
        assetImageGenerator.appliesPreferredTrackTransform = true
        var time = asset.duration
        time.value = min(time.value, 2)
        
        do
        {
            let imageRef = try assetImageGenerator.copyCGImage(at: time, actualTime: nil)
            return UIImage(cgImage: imageRef)
        }
        catch
        {
            return nil
        }
    }
    
    
    func set_statusBar_color(view:UIView)
    {
        if #available(iOS 13.0, *)
        {
            let app = UIApplication.shared
            let statusBarHeight: CGFloat = app.statusBarFrame.size.height
            
            let statusbarView = UIView()
            statusbarView.backgroundColor = Appcolor.kThemeColor
            view.addSubview(statusbarView)
          
            statusbarView.translatesAutoresizingMaskIntoConstraints = false
            statusbarView.heightAnchor
                .constraint(equalToConstant: statusBarHeight).isActive = true
            statusbarView.widthAnchor
                .constraint(equalTo: view.widthAnchor, multiplier: 1.0).isActive = true
            statusbarView.topAnchor
                .constraint(equalTo: view.topAnchor).isActive = true
            statusbarView.centerXAnchor
                .constraint(equalTo: view.centerXAnchor).isActive = true
          
        }
        else
        {
            let statusBar = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView
            statusBar?.backgroundColor = Appcolor.kThemeColor
        }
    }
    
}

//MARK:- UIViewController extensions
extension UIViewController
{
    
    func hideNAV_BAR (controller : UIViewController)
    {
        controller.navigationController?.isNavigationBarHidden = true
    }
    
    func showNAV_BAR (controller : UIViewController)
       {
           controller.navigationController?.isNavigationBarHidden = false
       }
    
    func moveBACK (controller : UIViewController)
    {
        controller.navigationController?.popViewController(animated: true);
    }
    func present_To_Controller(from_controller:UIViewController,to_Controller:UIViewController)
         {
             from_controller.navigationController?.present(to_Controller, animated: true, completion: nil)
         }
    func push_To_Controller(from_controller:UIViewController,to_Controller:UIViewController)
    {
        from_controller.navigationController?.pushViewController(to_Controller, animated: true)
    }
    
    func getAppDelegate() -> AppDelegate
    {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate
    }
    
    
    func hideBackButtonTitle()
    {
        self.navigationController?.navigationBar.topItem?.title = " "
    }
    
    func removeBackButton()
    {
        self.navigationItem.hidesBackButton = true
    }
    
    func setBackBarButtonCustom(addFrame:CGRect,contorller:UIViewController)
    {
        //Initialising "back button"
        let btnLeftMenu: UIButton = UIButton()
        btnLeftMenu.setImage(UIImage(named: "back"), for: UIControl.State.normal)
        btnLeftMenu.addTarget(contorller, action: #selector(onClickBack), for: UIControl.Event.touchUpInside)
        btnLeftMenu.frame = addFrame
        btnLeftMenu.imageEdgeInsets = UIEdgeInsets(top: 0, left: -40, bottom: 0, right: 0);
        let barButton = UIBarButtonItem(customView: btnLeftMenu)
        contorller.navigationItem.leftBarButtonItem = barButton
        
    }
    
    @objc func onClickBack()
    {
        if (self.navigationController?.viewControllers.count)! > 1
        {
            _ = self.navigationController?.popViewController(animated: true)
        }
        else
        {
            self.dismiss(animated: true, completion: nil)
        }
        
    }
    
    func generateRandomString() -> String
    {
        let letters : NSString = "0123456789"
        let len = UInt32(letters.length)
        
        var randomString = ""
        
        for _ in 0 ..< 10
        {
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }
        
        return randomString
    }
    
    
    
}
extension UIView {

    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
         let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
         let mask = CAShapeLayer()
         mask.path = path.cgPath
         self.layer.mask = mask
    }

}

extension UIImageView {

    func imageroundCorners(_ corners: UIRectCorner, radius: CGFloat) {
         let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
         let mask = CAShapeLayer()
         mask.path = path.cgPath
         self.layer.mask = mask
    }

}
