//
//  NotificationVC.swift
//  DriverDeliveryApp
//
//  Created by Navaldeep Kaur on 07/05/20.
//  Copyright © 2020 Navaldeep Kaur. All rights reserved.
//

import UIKit

class NotificationVC: CustomController {
    
    //MARK:- Outlet and Variables
    @IBOutlet weak var lblNoRecord: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btnMenu: UIBarButtonItem!
    
    @IBOutlet weak var btnDelete: UIBarButtonItem!
    
    @IBOutlet weak var imgTabOrder: UIImageView!
       @IBOutlet weak var imgProfile: UIImageView!
       @IBOutlet weak var imgNotification: UIImageView!
       @IBOutlet weak var imgSetting: UIImageView!
    
    var viewModel:NotificationViewModel?
    var notificationList = [Body18]()
    
    //MARK:- life Cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setView()
    }
    
    //MARK:-Actions
    @IBAction func deleteNotification(_ sender: Any) {
        self.AlertMessageWithOkCancelAction(titleStr: kAppName, messageStr: "Are you sure you want to delete all notifications?", Target: self) { (Alert) in
            if (Alert == "Yes")
            {
                self.viewModel?.deleteAllNotificationsApi(completion: { (data) in
                self.showAlertMessage(titleStr: kAppName, messageStr: data.message ?? "")
                    self.notificationListApi()
              })
            }
        }
    }
    @IBAction func DeleteNotificationAction(_ sender: Any) {
       
        self.AlertMessageWithOkCancelAction(titleStr: kAppName, messageStr: "Are you sure you want to delete all notifications?", Target: self) { (Alert) in
            if (Alert == "Yes")
            {
                self.viewModel?.deleteAllNotificationsApi(completion: { (data) in
                self.showAlertMessage(titleStr: kAppName, messageStr: data.message ?? "")
                    self.notificationListApi()
              })
            }
        }
       
    }
    //MARK:- Other functions
    func  setView(){
        
        self.viewModel = NotificationViewModel.init(Delegate: self, view: self)
//        btnMenu.target = self.revealViewController()
//        btnMenu.action = #selector(SWRevealViewController.revealToggle(_:))
//        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
//        self.setTapGestureOnSWRevealontroller(view: self.view, controller: self)
//
        //TableView
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
        
        notificationListApi()
    }
   
    @IBAction func bottomTabAction(_ sender: UIButton) {
           
           switch sender.tag {
           case 0:
               imgTabOrder.isHidden = false
               imgNotification.isHidden = true
               imgProfile.isHidden = true
               imgSetting.isHidden = true
               self.setRootView("SWRevealViewController", storyBoard: "Home")
               break
               
           case 1:
               imgTabOrder.isHidden = true
               imgNotification.isHidden = true
               imgProfile.isHidden = false
               imgSetting.isHidden = true
               self.setRootView("FeedBackVC", storyBoard: "Home")
               break
               
           case 2:
               imgTabOrder.isHidden = true
               imgNotification.isHidden = false
               imgProfile.isHidden = true
               imgSetting.isHidden = true
              // self.setRootView("NotificationVC", storyBoard: "Home")

               break
           case 3:
               imgTabOrder.isHidden = true
               imgNotification.isHidden = true
               imgProfile.isHidden = true
               imgSetting.isHidden = false
               self.setRootView("SettingsVC", storyBoard: "Home")

               break
           default:
               break
           }
       }
       
    //MARK:- Hit APi
    func notificationListApi(){
        self.viewModel?.getNotificationListApi(completion: { (data) in
            if let notificationData = data.body{
                if notificationData.count > 0{
                    self.notificationList = notificationData
                    self.tableView.isHidden = false
                    self.lblNoRecord.isHidden = true
                    self.btnDelete.isEnabled = true
                    self.btnDelete.tintColor = UIColor.gray
                    self.tableView.reloadData()
                    
                }
                else{
                    self.tableView.isHidden = true
                    self.lblNoRecord.isHidden = false
                    self.btnDelete.isEnabled = false
                    self.btnDelete.tintColor = UIColor.clear
                }
            }
        })
    }
    
}

//MARK:- TableViewDelegateAndDataSource

extension NotificationVC : UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return notificationList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationCell")as! NotificationCell
        cell.setData(data:notificationList[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    
}

//MARK:- ViewDelegate

extension NotificationVC: NotificationDelegate{
    func Show(msg: String) {
        
    }
    
    func didError(error: String) {
      //  showAlertMessage(titleStr: kAppName, messageStr: error)
        self.tableView.isHidden = true
        self.lblNoRecord.isHidden = false
        btnDelete.isEnabled = false
        btnDelete.tintColor = UIColor.clear
        
    }
    
    
}
