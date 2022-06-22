//
//  SettingsVC.swift
//  UrbanClap Replica
//
//  Created by Mohit Sharma on 5/21/20.
//  Copyright © 2020 Seasia Infotech. All rights reserved.
//

import UIKit

class SettingsVC: CustomController
{
    
    @IBOutlet weak var btnSwitch: UISwitch!
    @IBOutlet var btnDrawer: UIBarButtonItem!
    @IBOutlet var tblViw: UITableView!
    
    var Menu:[String]?
    var MenuImg:[String]?
    var viewModel:HomeViewModel?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        Menu = ["Terms & Conditions","Privacy Policy","My Earnings","Wallet","Payment Details","Company Details","Your Region","Rate Us","Share App","Logout"]
        MenuImg = ["terms","pp","walletW","wlt","bank","comp","comp", "rate", "share","log"]
        
        self.viewModel = HomeViewModel.init(Delegate: self, view: self)
        btnSwitch.addTarget(self, action: #selector(stateChanged), for: .valueChanged)
        self.tblViw.reloadData()
        //     self.tblViw.layer.cornerRadius = 10
        //      self.tblViw.layer.borderColor = UIColor.black.cgColor
        //      self.tblViw.layer.borderWidth = 1
        
        //   btnDrawer.target = self.revealViewController()
        //     btnDrawer.action = #selector(SWRevealViewController.revealToggle(_:))
        
        //self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        //    self.setTapGestureOnSWRevealontroller(view: self.view, controller: self)
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        self.navigationController?.navigationBar.isHidden = true
        // self.showNAV_BAR(controller: self)
        hideNAV_BAR(controller: self)
    }
    
    @objc func stateChanged(switchState: UISwitch)
    {
        if switchState.isOn {
            viewModel?.changeStatus(status: "1", completion: { (data) in
                if (data.code == 200){
                    //  self.lblOnOff.text = "Online"
                    AppDefaults.shared.offLineStatus = "On"
                }
            })
            
        } else {
            viewModel?.changeStatus(status: "0", completion: { (data) in
                if (data.code == 200){
                    //     self.lblOnOff.text = "Offline"
                    AppDefaults.shared.offLineStatus = "Off"
                }
            })
            
        }
    }
    
    @IBAction func actionBack(_ sender: UIButton) {
        
        self.revealViewController().revealToggle(self)
    }
    
    //MARK:- Actions
    @IBAction func bottomTabAction(_ sender: UIButton) {
        
        switch sender.tag {
        case 0:
            
            self.setRootView("SWRevealViewController", storyBoard: "Home")
            break
            
        case 1:
            
            self.setRootView("FeedBackVC", storyBoard: "Home")
            break
            
        case 2:
            
            self.setRootView("NotificationVC", storyBoard: "Home")
            break
        case 3:
            
            //self.setRootView("SettingsVC", storyBoard: "Home")
            break
        default:
            break
        }
    }
    
    
    override func viewWillDisappear(_ animated: Bool)
    {
        self.hideNAV_BAR(controller: self)
    }
    
    @IBAction func cellAction(_ sender: UIButton)
    {
        switch sender.tag
        {
        case 0:
            
            let controller = Navigation.GetInstance(of: .TermsAndConditionsVc) as! TermsAndConditionsVc
            controller.isFromTermCondition = true
            self.push_To_Controller(from_controller: self, to_Controller: controller)
            
            
            break
        case 1:
            
            let controller = Navigation.GetInstance(of: .TermsAndConditionsVc) as! TermsAndConditionsVc
            controller.isFromTermCondition = false
            self.push_To_Controller(from_controller: self, to_Controller: controller)
            break
        case 2:
            
            let controller = Navigation.GetInstance(of: .MyEarningsVC) as! MyEarningsVC
            self.push_To_Controller(from_controller: self, to_Controller: controller)
           // self.showAlertMessage(titleStr: kAppName, messageStr: "Coming Soon!")
            
            break
        case 3:
            
            let controller = Navigation.GetInstance(of: .WalletHistoryVC) as! WalletHistoryVC
            // controller.isFromTermCondition = false
            self.push_To_Controller(from_controller: self, to_Controller: controller)
            
            break
        case 4:
            
            let controller = Navigation.GetInstance(of: .PaymentDetailVC) as! PaymentDetailVC
            self.push_To_Controller(from_controller: self, to_Controller: controller)
            
            break
            
        case 5:
            
            let controller = Navigation.GetInstance(of: .LOCOMOIDVC) as! LOCOMOIDVC
            self.push_To_Controller(from_controller: self, to_Controller: controller)
            //            if let url = URL(string: "https://apps.apple.com/in/app/afterlight-photo-editor/id1293122457") {
            //                UIApplication.shared.open(url)
            //   }
            break
        case 6:
            
            let controller = Navigation.GetInstance(of: .GeoFenceAreaVC) as! GeoFenceAreaVC
            self.push_To_Controller(from_controller: self, to_Controller: controller)
            break
            
        case 7:
            // self.showAlertMessage(titleStr: kAppName, messageStr: "Coming Soon!")
            
            self.showAlertMessage(titleStr: kAppName, messageStr: "Coming Soon!")
            //
            //            let shareAll = ["https://apps.apple.com/in/app/afterlight-photo-editor/id1293122457"] as [Any]
            //            let activityViewController = UIActivityViewController(activityItems: shareAll, applicationActivities: nil)
            //            activityViewController.popoverPresentationController?.sourceView = self.view
            //            self.present(activityViewController, animated: true, completion: nil)
            //
            break
            
        case 8:
            
            shareApp()
          // self.showAlertMessage(titleStr: kAppName, messageStr: "Coming Soon!")
          //  self.shareApp()
            break
            
        case 9:
            
            
            self.logout_app()
            break
            
        default: break
            
        }
        
    }
    
    func shareApp()
    {
        // text to share
        let text = "Hey!! join me on \(kAppName) app and get some exciting offers, Android Play Store : www.google.com iOS App Store : www.google.com"
        
        // set up activity view controller
        let textToShare = [ text ]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        
        // exclude some activity types from the list (optional)
        activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook ]
        
        // present the view controller
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    func logout_app()
    {
        // create an actionSheet
        let actionSheetController: UIAlertController = UIAlertController(title: kAppName, message: "Do you want to logout?", preferredStyle: .actionSheet)
        // create an action
        let firstAction: UIAlertAction = UIAlertAction(title: "Yes", style: .default) { action -> Void in
            
            self.call_api_logoutDriver(Params : ["":""])
        }
        
        let cancelAction: UIAlertAction = UIAlertAction(title: "No", style: .cancel) { action -> Void in }
        
        // add actions
        actionSheetController.addAction(firstAction)
        actionSheetController.addAction(cancelAction)
        actionSheetController.popoverPresentationController?.sourceView = self.view // works for both iPhone & iPad
        present(actionSheetController, animated: true)
        {
            print("option menu presented")
        }
    }
    
    func call_api_logoutDriver(Params : [String:Any])
    {
        let obj = [String:Any]()
        WebService.Shared.PostApi(url: APIAddress.DRIVER_LOGOUT, parameter: obj, Target: self, completionResponse: { (response) in
            
            self.AlertMessageWithOkAction(titleStr: kAppName, messageStr: "Logout successfully!", Target: self)
            {
                self.empty_data()
            }
        }, completionnilResponse: { (error) in
            self.AlertMessageWithOkAction(titleStr: kAppName, messageStr: "Logout successfully!", Target: self)
            {
                self.empty_data()
            }
        })
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
        AppDefaults.shared.firebaseToken = ""
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
        AppDefaults.shared.startedJobId = ""
        AppDefaults.shared.userDeviceToken = ""
        configs.kAppdelegate.setRootViewController()
    }
    
}

//MARK:- UITableViewDelegate
extension SettingsVC : UITableViewDelegate,UITableViewDataSource
{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 70.0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.Menu?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellClass_Settings", for: indexPath)as! CellClass_Settings
        cell.lblText.text = self.Menu![indexPath.row]
        cell.btnTapOnCell.tag = indexPath.row
     //   cell.imageView?.setImageColor(color: .clear)
        cell.imgView.image = UIImage(named:"\(self.MenuImg![indexPath.row])")
        return cell
    }
    
}

extension SettingsVC:HomeVCDelegate{
    func Show(msg: String) {
        
    }
    
    func didError(error: String) {
        
    }
    
    
}



extension UIImage {
     func imageWithColor(tintColor: UIColor) -> UIImage {
         UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)

         let context = UIGraphicsGetCurrentContext()!
         context.translateBy(x: 0, y: self.size.height)
         context.scaleBy(x: 1.0, y: -1.0);
         context.setBlendMode(.normal)

         let rect = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height) as CGRect
         context.clip(to: rect, mask: self.cgImage!)
         tintColor.setFill()
         context.fill(rect)

         let newImage = UIGraphicsGetImageFromCurrentImageContext()!
         UIGraphicsEndImageContext()

         return newImage
     }
 }
