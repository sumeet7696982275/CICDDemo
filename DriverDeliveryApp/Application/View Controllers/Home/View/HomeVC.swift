//
//  HomeVC.swift
//  DriverDeliveryApp
//
//  Created by Navaldeep Kaur on 30/04/20.
//  Copyright © 2020 Navaldeep Kaur. All rights reserved.
//

import UIKit
import SocketIO
import GoogleMaps
import GooglePlaces
import SwiftyJSON
import SocketIO
import GoogleMaps
import GooglePlaces

protocol  SendLocDataToServerDelegate
{
    func updateSocketData()
}

protocol HomeViewDelegate {
    func acceptJob(index:Int?)
    func rejectJob(index:Int?)
    func startJob(index:Int?,tag:Int?)
    func cancelJob(index:Int?)
    func call(index:Int?)
    func orderDetail(index:Int?)
    func showMap(index:Int?)
    func showAlert()
}

var myLocation = CLLocationCoordinate2D()

class HomeVC: CustomController {
    
    //MARK:- Outlet and Variables
    @IBOutlet weak var btnAvaliable: CustomButton!
    @IBOutlet weak var jobCount: UIBarButtonItem!
    @IBOutlet weak var lblNoRecord: UILabel!
    @IBOutlet weak var btnCompleteJob: UIButton!
    @IBOutlet weak var btnAssignJob: UIButton!
    @IBOutlet weak var btnMenuBar: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lblAssignJobCount: UILabel!
    @IBOutlet weak var lblOnOff: UILabel!
    @IBOutlet weak var btnSwitch: UISwitch!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var btnHistory: CustomButton!
    @IBOutlet weak var btnActive: CustomButton!
    @IBOutlet weak var viewTopBack: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgTabOrder: UIImageView!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var imgNotification: UIImageView!
    @IBOutlet weak var imgSetting: UIImageView!
    @IBOutlet weak var lblVerificationAlert: UILabel!
    
    var viewModel:HomeViewModel?
    var jobList = [Body1]()
    var selectedIndex : Int?
    var tag:Int?
    var cancelIndex:Int?
    var socket : SocketIOClient!
    var isMapCall = false
    var arrLatLongData = [[String:Any]]()
    var page = 1
    var isFetching:Bool = false
    var isScroll = false
    var jobStatus = "0"
    var fromAccept = false
    var tabNumber = 1
    
    var refreshTimer = Timer()
    
    static  var locationManager = CLLocationManager()
    
    //MARK:- LifeCycle methods
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        setUI()
        
        self.page = 1
        fromAccept = true
        // JobList(status:"",page:page,jobStatus:"0")
        //Location Manager code to fetch current location
        
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        self.refreshTimer.invalidate()
        JobList(status:"",page:page, jobStatus: jobStatus)
    //    self.refreshTimer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(self.startTimer), userInfo: nil, repeats: true)
        
        HomeVC.locationManager.delegate = self
        HomeVC.locationManager.startUpdatingLocation()
        HomeVC.locationManager.allowsBackgroundLocationUpdates = true
        HomeVC.locationManager.requestAlwaysAuthorization()
        
        
        Location.shared.InitilizeGPS()
        
        hideNAV_BAR(controller: self)
        
     
        if(self.tabNumber == 1)
        {
            self.avaliableJobSelected()
        }
        else if(self.tabNumber == 2)
        {
            self.assignJobSelected()
        }
        else
        {
            self.completedJobSelected()
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        self.refreshTimer.invalidate()
    }
    
    @objc func startTimer()
    {
        
        
        if(btnAvaliable.backgroundColor == Appcolor.kThemeColor)
        {
            jobStatus = "0"
            JobList(status:"",page:page, jobStatus: jobStatus)
        }
    }
    
    
    @IBAction func acnInfo(_ sender: Any)
    {
        let controller = Navigation.GetInstance(of: .ChargesInfoVC) as! ChargesInfoVC
        self.push_To_Controller(from_controller: self, to_Controller: controller)
    }
    
    
    //MARK:- Actions
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
    @IBAction func TabActions(_ sender: Any) {
        
        switch (sender as AnyObject).tag {
        case 0:
            self.tabNumber = 1
            self.isScroll = false
            avaliableJobSelected()
            break
        case 1:
            self.tabNumber = 2
            self.isScroll = false
            assignJobSelected()
            break
        case 2:
            self.tabNumber = 3
            self.isScroll = false
            completedJobSelected()
            break
        default:
            break
            
        }
    }
    //MARK:- Other Functions
    func avaliableJobSelected()
    {
        self.jobList.removeAll()
        self.tableView.reloadData()
        jobStatus = "0"
        self.page = 1
        btnAvaliable.backgroundColor = Appcolor.kThemeColor
        btnAvaliable.setTitleColor(Appcolor.kTextColorWhite, for: .normal)
        
        btnActive.backgroundColor = Appcolor.klightGrayBtnBack
        btnActive.setTitleColor(Appcolor.kTextColorBlack, for: .normal)
        
        btnHistory.backgroundColor = Appcolor.klightGrayBtnBack
        btnHistory.setTitleColor(Appcolor.kTextColorBlack, for: .normal)
        JobList(status:"",page:page, jobStatus: jobStatus)
    }
    
    func assignJobSelected()
    {
        self.jobList.removeAll()
        self.tableView.reloadData()
        self.page = 1
        jobStatus = "1"
        btnAvaliable.backgroundColor =  Appcolor.klightGrayBtnBack
        btnAvaliable.setTitleColor(Appcolor.kTextColorBlack, for: .normal)
        
        
        btnActive.backgroundColor = Appcolor.kThemeColor
        btnActive.setTitleColor(Appcolor.kTextColorWhite, for: .normal)
        
        btnHistory.backgroundColor = Appcolor.klightGrayBtnBack
        btnHistory.setTitleColor(Appcolor.kTextColorBlack, for: .normal)
        JobList(status:"",page:page, jobStatus: jobStatus)
    }
    
    func completedJobSelected()
    {
        self.jobList.removeAll()
        self.tableView.reloadData()
        self.page = 1
        jobStatus = "3"
        tableView.reloadData()
        btnAvaliable.backgroundColor =  Appcolor.klightGrayBtnBack
        btnAvaliable.setTitleColor(Appcolor.kTextColorBlack, for: .normal)
        
        btnHistory.backgroundColor = Appcolor.kThemeColor
        btnHistory.setTitleColor(Appcolor.kTextColorWhite, for: .normal)
        
        btnActive.backgroundColor = Appcolor.klightGrayBtnBack
        btnActive.setTitleColor(Appcolor.kTextColorBlack, for: .normal)
        JobList(status:"", page: page, jobStatus: jobStatus)
    }
    
    func setUI()
    {
        self.viewModel = HomeViewModel.init(Delegate: self, view: self)
        btnMenuBar.target = self.revealViewController()
        btnMenuBar.action = #selector(SWRevealViewController.revealToggle(_:))
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        //   self.setTapGestureOnSWRevealontroller(view: self.view, controller: self)
        viewTopBack.backgroundColor = Appcolor.kThemeColor
        
        lblVerificationAlert.textColor = Appcolor.kThemeColor
        lblNoRecord.textColor = Appcolor.kThemeColor
        lblOnOff.textColor = Appcolor.kThemeColor
        self.jobCount.tintColor = UIColor.clear
        //TableView
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
        
        btnSwitch.addTarget(self, action: #selector(stateChanged), for: .valueChanged)
        
        searchBar.backgroundColor = UIColor.white
        searchBar.clipsToBounds = true
        searchBar.layer.cornerRadius = 24
        searchBar.tintColor = UIColor.white
        //        searchBar.searchTextField.backgroundColor = UIColor.white
        //       searchBar.searchTextField.makeRound_Boarders()
        var searchTextField: UITextField?
        if let searchField = searchBar.value(forKey: "searchField") as? UITextField {
            searchTextField = searchField
            searchTextField?.textColor = .black
            searchTextField?.backgroundColor = .white
            
            searchTextField?.makeRound_Boarders()
        }
        //
        if (AppDefaults.shared.offLineStatus == "On"){
            btnSwitch.isOn = true
            lblOnOff.text = "Online"
        }
        else{
            btnSwitch.isOn = false
            lblOnOff.text = "Offline"
            
        }
        
        
    }
    
    //MARK:- Call
    func phone(phoneNum: String)
    {
        if let url = URL(string: "tel://\(phoneNum)") {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url as URL)
            }
        }
        
    }
    
    @objc func stateChanged(switchState: UISwitch)
    {
        if switchState.isOn {
            viewModel?.changeStatus(status: "1", completion: { (data) in
                if (data.code == 200){
                    self.lblOnOff.text = "Online"
                    AppDefaults.shared.offLineStatus = "On"
                }
            })
            
        } else {
            viewModel?.changeStatus(status: "0", completion: { (data) in
                if (data.code == 200){
                    self.lblOnOff.text = "Offline"
                    AppDefaults.shared.offLineStatus = "Off"
                }
            })
            
        }
    }
    
    //MARK:- HitApis
    func JobList(status:String?,page:Int?,jobStatus:String){
        self.viewModel?.getJobListApi(status: status, page: page, jobStatus: jobStatus, completion: { (response) in
            print(response)
            if let data = response.body?.orders
            {
                if (data.count > 0) && response.body?.verified == 1
                {
                    self.jobList.removeAll()
                    self.isFetching = true
                    if self.fromAccept == true
                    {
                        self.fromAccept = false
                  //      self.jobList.removeAll()
                        self.jobList = data
                    }
                    else
                    {
                        for i in 0..<data.count
                        {
                        ///
                         
                            self.jobList.append(data[i])
                        }
                    }
                    //                    self.jobList = data
                    
                    self.tableView.reloadData()
                    self.tableView.setEmptyMessage("")
                    // self.lblNoRecord.isHidden = true
                    self.jobCount.tintColor = UIColor.darkGray
                    self.jobCount.title = "(\(self.jobList.count))"
                    self.lblVerificationAlert.isHidden = true
                    self.lblNoRecord.isHidden = true
                }
                else{
                    self.isFetching = false
                    if self.isScroll == true
                    {
                        
                    }
                    else
                    {
                      //
                        //   self.tableView.isHidden = true
                        //   self.lblNoRecord.isHidden = false
                        self.jobCount.tintColor = UIColor.clear
                        if response.body?.verified == 0{
                            self.lblVerificationAlert.isHidden = false
                            self.lblNoRecord.isHidden = false
                          //  self.lblNoRecord.text = response.body?.verificationReason ?? ""
                        self.tableView.setAnimatingImage(fileName: kLottieVerifyData ,msg :"")
                        self.tableView.animateReload()
                        }else{
                            self.tableView.setEmptyMessage("No Record Found")
                            self.tableView.reloadData()
                        }
                    }
                    //  self.jobCount.title = "(\(0))"
                }
            }
            else{
                
                if self.isScroll == true{
                }
                else{
                    self.jobCount.tintColor = UIColor.clear
                    
                    if response.body?.verified == 0{
                        self.lblVerificationAlert.isHidden = false
                        self.lblNoRecord.isHidden = false
                        self.lblVerificationAlert.text = response.body?.verificationReason ?? ""
                    self.tableView.setAnimatingImage(fileName: kLottieVerifyData ,msg :"")
                    self.tableView.animateReload()
                    }else{
                        self.tableView.setEmptyMessage("No Record Found")
                        self.tableView.reloadData()
                    }
                }
                self.isFetching = false
                //self.jobCount.title = "(\(0))"
            }
        })
    }
    
    //updateTrack
    func UpdateTrackStatusApi(status:String?,id:String?)
    {
        viewModel?.UpdateTrackStatusApi(Id: id ?? "", status: status, otp: "", orderImage: nil, completion: { (response) in
            print(response)
            if (self.isMapCall == false)
            {
                self.isMapCall = true
                let controller = Navigation.GetInstance(of: .MapVC) as! MapVC
                controller.destinationlat = Double(self.jobList[self.selectedIndex ?? 0].address?.latitude ?? "")
                controller.destinationlong = Double(self.jobList[self.selectedIndex ?? 0].address?.longitude ?? "")
                controller.orderId = self.jobList[self.selectedIndex ?? 0].id ?? ""
                
                controller.sourcelat = Double(self.jobList[self.selectedIndex ?? 0].company?.latitude?.value ?? "") ?? 0.0
                controller.sourcelong = Double(self.jobList[self.selectedIndex ?? 00].company?.longitude?.value ?? "") ?? 0.0
                
                self.push_To_Controller(from_controller: self, to_Controller: controller)
            }
            
        })
    }
    
    //MARK:- ConnectSocket
    func connect_socket_with_server()
    {
        SocketHelper.shared.connectSocket
            { (success) in
                print(success)
                
                SocketHelper.Events.updateLocation.emit(params: ["methodName":"updateLocation","orderId":AppDefaults.shared.startedJobId,"latLong":self.arrLatLongData,"empId":AppDefaults.shared.userID])
        }
    }
    
    func receiveEventsFromSocket()
    {
        SocketHelper.Events.updateLocation.listen { [weak self] (result) in
            print(result)
        }
    }
}

//MARK:- TableViewDelegateAndDataSource

extension HomeVC : UITableViewDelegate, UITableViewDataSource
{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return jobList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if jobStatus == "3"{
            let cell = tableView.dequeueReusableCell(withIdentifier: "JobHistoryCell")as! JobHistoryCell
            cell.viewDelegate = self
            cell.btnDetail.tag = indexPath.row
            cell.setData(data:jobList[indexPath.row])
            cell.setUI()
            return cell
            
        }
        else
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTableCell")as! HomeTableCell
            cell.viewDelegate = self
            cell.setUI()
            cell.btnCancel.tag = indexPath.row
            cell.btnShowAddress.tag = indexPath.row
            cell.btnStart.tag = indexPath.row
            cell.btnCall.tag = indexPath.row
            cell.btnDetail.tag = indexPath.row
       
            let obj = jobList[indexPath.row]
     
            cell.setData(data:obj)
            
         
            if(tabNumber == 1)
            {
                cell.lblPrice.isHidden = true
                cell.lblAmntTitle.isHidden = true
            }
            else
            {
                cell.lblPrice.isHidden = false
                cell.lblAmntTitle.isHidden = false
            }
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if(tabNumber == 1)
        {
            //means available order do nothing here
        }
        else
        {
            tableView.deselectRow(at: indexPath, animated: false)
            let controller = Navigation.GetInstance(of: .OrderDetailVC) as! OrderDetailVC
            controller.orderId = jobList[indexPath.row].id
            controller.isFromFeedBack = false
            controller.trackStatus = jobList[indexPath.row].progressStatus
            self.push_To_Controller(from_controller: self, to_Controller: controller)
        }
        
    }
    
    
}

//MARK:- ViewModelDelegate
extension HomeVC:HomeVCDelegate{
    func Show(msg: String) {
        
    }
    
    func didError(error: String) {
        if isScroll == true{
            
        }
        else{
            showAlertMessage(titleStr: kAppName, messageStr: error)
        }
    }
    
    
}

//MARK:- ViewDelegate

extension HomeVC : HomeViewDelegate
{
    func acceptJob(index: Int?) {
        
        AlertMessageWithOkCancelAction(titleStr: kAppName, messageStr: "Are you sure, you want to accept this job?", Target: self) { (Alert) in
            if (Alert == KYes){
                self.viewModel?.acceptJobApi(Id: self.jobList[index ?? 0].assignedEmployees?[0].id, orderId: self.jobList[index ?? 0].id, completion: { (data) in
                    self.AlertMessageWithOkAction(titleStr: kAppName, messageStr: data.message ?? "", Target: self) {
                        self.fromAccept = true
                        self.jobList.removeAll()
                        self.tableView.reloadData()
                        self.page = 1
                        self.JobList(status:"", page: self.page, jobStatus: "0")
                    }
                })
            }
        }
        
    }
    
    func rejectJob(index: Int?)
    {
        AlertMessageWithOkCancelAction(titleStr: kAppName, messageStr: "Are you sure, you want to Reject this job?", Target: self) { (Alert) in
            if (Alert == KYes){
                self.viewModel?.rejectJobApi(Id: self.jobList[index ?? 0].assignedEmployees?[0].id, orderId: self.jobList[index ?? 0].id, completion: { (data) in
                    self.AlertMessageWithOkAction(titleStr: kAppName, messageStr: data.message ?? "", Target: self)
                    {
                        self.jobList.removeAll()
                        self.page = 1
                        self.fromAccept = true
                        self.tableView.reloadData()
                        self.JobList(status:"", page: self.page, jobStatus: "0")
                    }        })
            }
        }
    }
    
    func showMap(index: Int?)
    {
        let controller = Navigation.GetInstance(of: .MapVC) as! MapVC
        controller.destinationlat = Double(self.jobList[index ?? 0].address?.latitude ?? "")
        controller.destinationlong = Double(self.jobList[index ?? 0].address?.longitude ?? "")
        
        controller.sourcelat = Double(self.jobList[index ?? 0].company?.latitude?.value ?? "") ?? 0.0
        controller.sourcelong = Double(self.jobList[index ?? 0].company?.longitude?.value ?? "") ?? 0.0
        
        controller.orderId = self.jobList[index ?? 0].id ?? ""
        controller.trackStatus = self.jobList[index ?? 0].progressStatus ?? 0
        self.push_To_Controller(from_controller: self, to_Controller: controller)
    }
    
    func orderDetail(index: Int?) {
        let controller = Navigation.GetInstance(of: .OrderDetailVC) as! OrderDetailVC
        controller.orderId = jobList[index ?? 0].id
        controller.isFromFeedBack = false
        self.push_To_Controller(from_controller: self, to_Controller: controller)
    }
    
    func startJob(index: Int?,tag:Int?)
    {
        let controller = Navigation.GetInstance(of: .ChangeStatusVC) as! ChangeStatusVC
        controller.orderId = self.jobList[index ?? 0].id ?? ""
        controller.trankStatusfromApi = self.jobList[index ?? 0].progressStatus ?? 0//trackStatus ?? 0
        controller.destinationlat = Double(self.jobList[index ?? 0].address?.latitude ?? "")
        controller.destinationlog = Double(self.jobList[index ?? 0].address?.longitude ?? "")
        
        
        controller.sourcelat = Double(self.jobList[index ?? 0].company?.latitude?.value ?? "") ?? 0.0
        controller.sourcelog = Double(self.jobList[index ?? 0].company?.longitude?.value ?? "") ?? 0.0

        controller.paymentType = self.jobList[index ?? 0].paymentType ?? 0
        controller.price = self.jobList[index ?? 0].orderPrice ?? ""
        self.push_To_Controller(from_controller: self, to_Controller: controller)
        
    }
    
    func cancelJob(index: Int?)
    {
        let obj = jobList[index ?? 0].penalityAfterAcceptance
        cancelIndex = index ?? 0
        let controller = Navigation.GetInstance(of: .AlertCanacelJobVC) as! AlertCanacelJobVC
        controller.viewDelegate = self
        controller.cancellationPenalty = obj ?? "0"
        self.present_To_Controller(from_controller: self, to_Controller: controller)
    }
    
    func call(index: Int?)
    {
        phone(phoneNum: jobList[index ?? 0].user?.phoneNumber ?? "")
    }
    
    func showAlert()
    {
        self.AlertMessageWithOkAction(titleStr: kAppName, messageStr: "You can not cancel this order for now!", Target: self)
        {
            
        }
    }
    
}

//MARK:- AlertDelegate
extension HomeVC:AlertCanacelDelegate
{
    func selectedComment(id: String?, otherResason: String?)
    {
        if(self.cancelIndex ?? 0 <= self.jobList.count-1)
        {
            let indxID = self.jobList[self.cancelIndex ?? 0].id//mohit
            self.viewModel?.submitCancelApi(orderId: indxID, reasonId: id,otherResason:otherResason ,completion: { (data) in
                self.AlertMessageWithOkAction(titleStr: kAppName, messageStr: data.message ?? "", Target: self) {
                    self.jobList.removeAll()
                    self.fromAccept = true
                    self.page = 1
                    self.tableView.reloadData()
                    self.JobList(status:"", page: self.page, jobStatus: "1")
                }
            })
        }
        else
        {
            self.AlertMessageWithOkAction(titleStr: kAppName, messageStr: "Oops, Cancel index not found", Target: self)
            {
                //
            }
        }
        
    }
    
    func otherSelected(index: Int?, message: String?) {
        
    }
    
    
}


//MARK:- MapDelegate
extension HomeVC:GMSMapViewDelegate,CLLocationManagerDelegate{
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition)
    {
        arrLatLongData.removeAll()
        let coordinate = mapView.projection.coordinate(for: mapView.center)
        print(coordinate.latitude as Any)
        
        let obj = ["lat":"\(coordinate.latitude)","long":"\(coordinate.longitude)"]
        arrLatLongData.append(obj)
        //   connect_socket_with_server()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        let location = locations.last
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        arrLatLongData.removeAll()
        let obj = ["lat":"\(locValue.latitude)","long":"\(locValue.longitude)"]
        arrLatLongData.append(obj)
        if (AppDefaults.shared.startedJobId != "")
        {
            connect_socket_with_server()
        }
        else
        {
            SocketHelper.shared.disconnectSocket()
            HomeVC.locationManager.stopUpdatingLocation()
        }
    }
}

extension HomeVC : UIScrollViewDelegate{
    //Pagination
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        if scrollView == tableView{
            if ((tableView.contentOffset.y + tableView.frame.size.height) >= tableView.contentSize.height)
            {
                if isFetching == true
                {
                    isScroll = true
                    isFetching = false
                    self.page = self.page+1
                    JobList(status: "", page: self.page, jobStatus: jobStatus)
                }
                else{
                    isScroll = false
                }
            }
        }
    }
}



extension HomeVC : JobHistory_Delegate
{
    func jobDetail(index: Int?) {
        let controller = Navigation.GetInstance(of: .OrderDetailVC) as! OrderDetailVC
        controller.orderId = jobList[index ?? 0].id ?? ""
        controller.isFromFeedBack = true
        self.push_To_Controller(from_controller: self, to_Controller: controller)
    }
    
    
}
