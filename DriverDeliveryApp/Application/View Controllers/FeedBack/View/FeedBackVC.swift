//
//  FeedBackVC.swift
//  DriverDeliveryApp
//
//  Created by Navaldeep Kaur on 02/05/20.
//  Copyright © 2020 Navaldeep Kaur. All rights reserved.
//

import UIKit
import Cosmos
import ParallaxHeader
import SnapKit

protocol FeedbackDelegate : class {
    func showDetail(index:Int?)
}
class FeedBackVC: CustomController {
    
    //MARK:- Outlet and Variables
    @IBOutlet weak var btnSwitch: UISwitch!
    @IBOutlet weak var lblOnline: UILabel!
    @IBOutlet weak var imgCover: UIImageView!
    @IBOutlet weak var lblTotalOrder: UILabel!
    @IBOutlet weak var btnmenu: UIBarButtonItem!
    @IBOutlet weak var imgViewUser: UIImageView!
    @IBOutlet weak var tableViewFeedBack: UITableView!
    @IBOutlet weak var viewOverallrating: CosmosView!
    @IBOutlet weak var lblNoRecordFound: UILabel!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblComment: UILabel!
    @IBOutlet weak var viewTop: CustomUIView!
    @IBOutlet weak var btnEdit: CustomButton!
    
    @IBOutlet weak var imgTabOrder: UIImageView!
          @IBOutlet weak var imgProfile: UIImageView!
          @IBOutlet weak var imgNotification: UIImageView!
          @IBOutlet weak var imgSetting: UIImageView!
    
    var viewModel : FeedbackViewModel?
    var feedbackList = [Rating]()
    var page = 1
    var isFetching:Bool = false
    var isScroll = false
    
    //MARK:- life Cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        if(AppDefaults.shared.userCoverImage == ""){
            self.imgCover.image = UIImage(named: "backGround")
      //      self.imgCover.contentMode = .scaleAspectFit
            self.imgCover.backgroundColor = Appcolor.klightGray
        }
        else{
            self.imgCover.setImage(with: AppDefaults.shared.userCoverImage, placeholder: "backGround")
      //      self.imgCover.contentMode = .scaleAspectFit
        }
        //setData
        
//        //naval
//        self.viewOverallrating.rating = 4.0
//        self.lblTotalOrder.text = "\(10) total orders - \(4) overall feedback"
//
              imgViewUser.CornerRadius(radius: imgViewUser.frame.height/2)
              self.imgViewUser.layer.borderWidth = 5
              self.imgViewUser.layer.borderColor = Appcolor.kTextColorWhite.cgColor
              if(AppDefaults.shared.userImage != ""){
               //self.imgViewUser.contentMode = .scaleAspectFill
                self.imgViewUser.setImage(with: AppDefaults.shared.userImage, placeholder: kplaceholderProfile)
              }
              else{
                  self.imgViewUser.image = UIImage(named: kplaceholderProfile)
                  // self.imgViewUser.contentMode = .scaleAspectFit
              }
             
              self.lblUserName.text = AppDefaults.shared.userFirstName + " " + AppDefaults.shared.userLastName
    }
    
    //MARK:- Actions
    
    @IBAction func btnEditAction(_ sender: Any)
    {
        let controller = Navigation.GetInstance(of: .EditProfileVC) as! EditProfileVC
        self.push_To_Controller(from_controller: self, to_Controller: controller)
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
              // self.setRootView("FeedBackVC", storyBoard: "Home")
               break
               
           case 2:
               imgTabOrder.isHidden = true
               imgNotification.isHidden = false
               imgProfile.isHidden = true
               imgSetting.isHidden = true
               self.setRootView("NotificationVC", storyBoard: "Home")
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
       
    
    //MARK:- Other Functions
    func setUI()
    {
        self.viewModel = FeedbackViewModel.init(Delegate: self, view: self)
      //  btnmenu.target = self.revealViewController()
      //  btnmenu.action = #selector(SWRevealViewController.revealToggle(_:))
        //self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
     //   self.setTapGestureOnSWRevealontroller(view: self.view, controller: self)
        //tableView
        tableViewFeedBack.delegate = self
        tableViewFeedBack.dataSource = self
        tableViewFeedBack.separatorStyle = .none
        tableViewFeedBack.tableFooterView = UIView()
        //tableViewFeedBack.layer.cornerRadius = 28
        setupParallaxHeader()
        btnSwitch.addTarget(self, action: #selector(stateChanged), for: .valueChanged)

    //  viewOverallrating.roundCorners([.topLeft, .topRight], radius: 28)
       // imgCover.imageroundCorners([.topLeft, .topRight], radius: 28)

        viewOverallrating.settings.fillMode = .precise
        //callApi
        getFeedBackList()
        
        if (AppDefaults.shared.offLineStatus == "On"){
            btnSwitch.isOn = true
            lblOnline.text = "Online"
        }
        else{
            btnSwitch.isOn = false
            lblOnline.text = "Offline"
            
        }
    }
    
    
    
    @objc func stateChanged(switchState: UISwitch)
      {
          if switchState.isOn {
              viewModel?.changeStatus(status: "1", completion: { (data) in
                  if (data.code == 200){
                      self.lblOnline.text = "Online"
                      AppDefaults.shared.offLineStatus = "On"
                  }
              })
              
          } else {
              viewModel?.changeStatus(status: "0", completion: { (data) in
                  if (data.code == 200){
                     self.lblOnline.text = "Offline"
                      AppDefaults.shared.offLineStatus = "Off"
                  }
              })
              
          }
      }
    
    //MARK: setupParallaxHeader
    private func setupParallaxHeader() {
        
//        viewTop.blurView.setup(style: UIBlurEffect.Style.dark, alpha: 1).enable()
//        viewTop.blurView.alpha = 0
        imgCover.blurView.setup(style: UIBlurEffect.Style.dark, alpha: 1).enable()
        imgCover.blurView.alpha = 0
        imgViewUser.blurView.setup(style: UIBlurEffect.Style.dark, alpha: 1).enable()
        imgViewUser.blurView.alpha = 0
      
       
          // Label for vibrant text
          let vibrantLabel = UILabel()
          vibrantLabel.text = AppDefaults.shared.userFirstName + " " + AppDefaults.shared.userLastName
          vibrantLabel.font = UIFont.systemFont(ofSize: 18.0)
          vibrantLabel.sizeToFit()
          vibrantLabel.textAlignment = .center
          vibrantLabel.textColor = UIColor.white
      //    viewTop.addSubview(vibrantLabel)
       //   viewTop.blurView.vibrancyContentView?.addSubview(vibrantLabel)
      //    viewTop.bringSubviewToFront(vibrantLabel)
        //  viewTop.addSubview(vibrantLabel)
          //add constraints using SnapKit library
//          vibrantLabel.snp.makeConstraints { make in
//              make.edges.equalToSuperview()
//          }
//        vibrantLabel.isHidden = true
        
        tableViewFeedBack.parallaxHeader.view = viewTop
        tableViewFeedBack.parallaxHeader.height = 370
        tableViewFeedBack.parallaxHeader.minimumHeight = 90
        tableViewFeedBack.parallaxHeader.mode = .bottom
        
        tableViewFeedBack.parallaxHeader.parallaxHeaderDidScrollHandler = { parallaxHeader in
            //update alpha of blur view on top of image view
        //    parallaxHeader.view.blurView.alpha = 1 - parallaxHeader.progress
            self.imgCover.blurView.alpha = 1 - parallaxHeader.progress
            self.imgViewUser.blurView.alpha = 1 - parallaxHeader.progress
            
            if parallaxHeader.progress == 0 {
            // scrolling up
                 vibrantLabel.isHidden = false
                self.btnEdit.isHidden = true
                self.imgViewUser.layer.borderWidth = 0
            }
            else{
                 vibrantLabel.isHidden = true
                self.btnEdit.isHidden = false
                self.imgViewUser.layer.borderWidth = 5
            }
        }
        
    }
    
    //MARK:- hitApi
    
    func getFeedBackList(){
        viewModel?.getFeedbackistApi(page: page, completion: { (data) in
            if let feedList = data.body?.ratings{
                if feedList.count > 0{
                    self.isFetching = true
                    self.feedbackList = feedList
                    self.viewOverallrating.rating = data.body?.avgRating ?? 0.0//Double(data.body?.avgRating ?? "0") ?? 0.0
                    self.lblTotalOrder.text = "\(data.body?.totalOrders ?? 0) total orders - \(data.body?.totalRating ?? 0) overall feedback"
                    self.tableViewFeedBack.isHidden = false
                    self.lblNoRecordFound.isHidden = true
                    self.tableViewFeedBack.reloadData()
                }
                else{
                    self.isFetching = false
                    self.tableViewFeedBack.isHidden = false
                   self.lblNoRecordFound.isHidden = true
                    
                }
            }
            else{
                self.isFetching = false
                self.tableViewFeedBack.isHidden = false
                self.lblNoRecordFound.isHidden = true
            }
        })
    }
    
}

//MARK:- TableViewDelegateAndDataSource

extension FeedBackVC : UITableViewDelegate, UITableViewDataSource
{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return feedbackList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FeedBackListCell")as! FeedBackListCell
        cell.btnDetail.tag = indexPath.row
        cell.viewDelegate = self
        cell.setData(data:feedbackList[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    
}

//MARK:- ViewDelegate
extension FeedBackVC : FeedBackDelegate{
    func Show(msg: String) {
        
    }
    
    func didError(error: String) {
        if isScroll == true{
            
        }
        else{
           // self.tableViewFeedBack.isHidden = true
            self.lblNoRecordFound.isHidden = false
        }
      
        // showAlertMessage(titleStr: kAppName, messageStr: error)
    }
    
    
}

//MARK:- viewdelegate

extension FeedBackVC: FeedbackDelegate{
    func showDetail(index: Int?)
    {
        let controller = Navigation.GetInstance(of: .OrderDetailVC) as! OrderDetailVC
        controller.orderId = feedbackList[index ?? 0].order?.id ?? ""
        controller.isFromFeedBack = true
        self.push_To_Controller(from_controller: self, to_Controller: controller)
    }
    
    
}


extension FeedBackVC : UIScrollViewDelegate{
    
    //Pagination
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        if scrollView == tableViewFeedBack{
            if ((tableViewFeedBack.contentOffset.y + tableViewFeedBack.frame.size.height) >= tableViewFeedBack.contentSize.height)
            {
                if isFetching == true
                {
                    isScroll = true
                    isFetching = false
                    self.page = self.page+1
                    getFeedBackList()
                }
                else{
                    isScroll = false
                }
            }
        }
    }
}
