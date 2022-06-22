//
//  SideMenuVC.swift
//  GoodsDelivery
//
//  Created by Rakesh Kumar on 12/19/19.
//  Copyright © 2019 Seasia infotech. All rights reserved.
//

import UIKit
import SDWebImage

class SideMenuVC: BaseUIViewController,UIActionSheetDelegate
{
    
    //MARK: - Outlets
    @IBOutlet var lblUserName: UILabel!
    @IBOutlet var lblAddress: UILabel!
    @IBOutlet var userImg: UIImageView!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var tableViewMenu: UITableView!
    @IBOutlet weak var viewBG: UIView!
    
    
    //MARK: - Variables
    var sideMenu:[String]?
    var sideMenuImg:[String]?
    //  var isSideMenuCallFirst:Bool = false
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.set_statusBar_color(view: self.view)
        //start live tracking
    }
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        SetUI()
        // isSideMenuCallFirst = false
        
    }
    
    override func viewDidLayoutSubviews()
    {
        // userImg.layer.borderWidth = 1.0
        userImg.layer.masksToBounds = false
        //   userImg.layer.borderColor = UIColor.white.cgColor
        userImg.layer.cornerRadius = userImg.frame.size.width / 2
        userImg.clipsToBounds = true
    }
    
    //MARK:- Other functions
    func SetUI()
    {
        sideMenu = ["Home","Job History","My Profile","Notifications","Terms & Conditions","Help","Sign Out"]
        sideMenuImg  = ["Home","Fuel","Services","Jobs History","Feedback","Notifications","Setting","Logout"]
        
        tableViewMenu.dataSource = self
        tableViewMenu.delegate = self
        tableViewMenu.tableFooterView = UIView()
        tableViewMenu.separatorStyle = .none
        self.userImg.image = UIImage(named:"dumProfile")
        if AppDefaults.shared.userImage == ""{
            userImg.image = UIImage(named: kplaceholderProfile)
        }
        else{
            self.userImg.setImage(with: AppDefaults.shared.userImage, placeholder: kplaceholderProfile)
            
        }
        self.lblUserName.text = AppDefaults.shared.userFirstName + " " + AppDefaults.shared.userLastName
        self.lblEmail.text = AppDefaults.shared.userEmail
        self.viewBG.backgroundColor = Appcolor.kThemeColor
        //lblAddress.text = AppDefaults.shared.userHomeAddress
        
        //        if   AppDefaults.shared.userImage != "" {
        //                    userImg.sd_setImage(with: URL(string: AppDefaults.shared.userImage ?? ""), placeholderImage: UIImage(named: "dummyImage"), options: SDWebImageOptions(rawValue: 0)) { (image, error, cacheType, imageURL) in
        //                        self.userImg.image = image
        //                    }
        //                }
        
    }
    
    
    //MARK:- IBActions
    @IBAction func Edit(_ sender: Any)
    {
        let controller = Navigation.GetInstance(of: .EditProfileVC) as! EditProfileVC
        let frontVC = revealViewController().frontViewController as? UINavigationController
        frontVC?.pushViewController(controller, animated: false)
        revealViewController().pushFrontViewController(frontVC, animated: true)
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        
        return 1
    }
}

//MARK:- UITableViewDelegate
extension SideMenuVC : UITableViewDelegate
{
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath)
    {
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat
    {
        return 0;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 60.0
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch indexPath.row
        {
        case 0:
            
            let controller = Navigation.GetInstance(of: .HomeVC) as! HomeVC
            let frontVC = revealViewController().frontViewController as? UINavigationController
            frontVC?.pushViewController(controller, animated: false)
            revealViewController().pushFrontViewController(frontVC, animated: true)
            
            break
        case 1:
            
//            let controller = Navigation.GetInstance(of: .JobHistoryVC) as! JobHistoryVC
//            let frontVC = revealViewController().frontViewController as? UINavigationController
//            frontVC?.pushViewController(controller, animated: false)
//            revealViewController().pushFrontViewController(frontVC, animated: true)
//
            configs.kAppdelegate.setRootViewController()
            
            break
//        case 2:
//
//            showAlertMessage(titleStr: kAppName, messageStr: "Coming Soon!")
//
//            break
            
        case 2:
            let controller = Navigation.GetInstance(of: .FeedBackVC) as! FeedBackVC
            let frontVC = revealViewController().frontViewController as? UINavigationController
            frontVC?.pushViewController(controller, animated: false)
            revealViewController().pushFrontViewController(frontVC, animated: true)
            
            break
            
        case 3:
            
            let controller = Navigation.GetInstance(of: .NotificationVC) as! NotificationVC
            let frontVC = revealViewController().frontViewController as? UINavigationController
            frontVC?.pushViewController(controller, animated: false)
            revealViewController().pushFrontViewController(frontVC, animated: true)
//            let controller = Navigation.GetInstance(of: .ChangeStatusVC) as! ChangeStatusVC
//                        let frontVC = revealViewController().frontViewController as? UINavigationController
//                        frontVC?.pushViewController(controller, animated: false)
//                        revealViewController().pushFrontViewController(frontVC, animated: true)
            
            break
        case 4:
            
            let controller = Navigation.GetInstance(of: .TermsAndConditionsVc) as! TermsAndConditionsVc
            let frontVC = revealViewController().frontViewController as? UINavigationController
            controller.isFromTermCondition = true
            frontVC?.pushViewController(controller, animated: false)
            revealViewController().pushFrontViewController(frontVC, animated: true)
            break
//        case 6:
//
//            let controller = Navigation.GetInstance(of: .TermsAndConditionsVc) as! TermsAndConditionsVc
//            let frontVC = revealViewController().frontViewController as? UINavigationController
//            controller.isFromTermCondition = false
//            frontVC?.pushViewController(controller, animated: false)
//            revealViewController().pushFrontViewController(frontVC, animated: true)
//            break
            
        case 6:
            
            self.logout_app()
            
            break
            
        default:
            showAlertMessage(titleStr: kAppName, messageStr: "Coming Soon!")
            break
        }
        
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
        // AppDefaults.shared.firebaseToken = ""
        AppDefaults.shared.userPhoneNumber = ""
        AppDefaults.shared.userCountryCode = ""
        AppDefaults.shared.userHomeAddress = ""
       // AppDefaults.shared.app_LATITUDE = ""
      //  AppDefaults.shared.app_LONGITUDE = ""
        AppDefaults.shared.appColor_Name = ""
        AppDefaults.shared.currentJobActive = "0"
        AppDefaults.shared.currentJobID = "0"
        AppDefaults.shared.synced_IDs = [""]
        AppDefaults.shared.CompanyID = ""
        AppDefaults.shared.startedJobId = ""
        // AppDefaults.shared.userDeviceToken = ""
        configs.kAppdelegate.setRootViewController()
    }
    
}

//MARK:- UITableViewDataSource
extension SideMenuVC : UITableViewDataSource
{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return sideMenu!.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell", for: indexPath) as! SideMenuCell
        cell.lblName.text = sideMenu![indexPath.row]
        //    cell.imgView.image = UIImage(named: sideMenuImg![indexPath.row])
        return cell
    }
}
