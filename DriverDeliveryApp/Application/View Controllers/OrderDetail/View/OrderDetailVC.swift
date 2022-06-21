//
//  OrderDetailVC.swift
//  DriverDeliveryApp
//
//  Created by Navaldeep Kaur on 05/05/20.
//  Copyright © 2020 Navaldeep Kaur. All rights reserved.
//

import UIKit
import Cosmos

class OrderDetailVC: CustomController {
    
    //MARK:- Outlet and Variables
    @IBOutlet weak var btnUpdateDelay: CustomButton!
    @IBOutlet var lblPriority: UILabel!
    @IBOutlet weak var tbleInstrtuction: UITableView!
    @IBOutlet weak var lblOrderNo: UILabel!
    @IBOutlet weak var lblDateTime: UILabel!
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lblItemCount: UILabel!
    @IBOutlet weak var btnCompleteOrder: CustomButton!
    @IBOutlet weak var kTbleInstructionHeight: NSLayoutConstraint!
    @IBOutlet weak var kTableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblPickAddress: UILabel!
    @IBOutlet weak var lblDeliveryMethod: UILabel!
    @IBOutlet weak var lblDiscount: UILabel!
    @IBOutlet weak var lblTotalAmount: UILabel!
    @IBOutlet weak var stackViewTips: UIStackView!
    @IBOutlet weak var kBtnCompleteOrderHeight: NSLayoutConstraint!
    @IBOutlet weak var lblTips: UILabel!
    @IBOutlet weak var lblCompAddress: UILabel!
    @IBOutlet weak var viewCompRate: CosmosView!
    @IBOutlet weak var lblCompanyName: UILabel!
    @IBOutlet weak var imgCompany: UIImageView!
    @IBOutlet weak var lblRating: UILabel!
    @IBOutlet weak var viewLine: UIView!
    
    @IBOutlet weak var lbl_Delay_Order: UILabel!
    @IBOutlet weak var delay_Stack_View: UIStackView!
    @IBOutlet weak var lbl_Delay_Order_Static: UILabel!
    
    @IBOutlet weak var lbl_Delay: UILabel!
    @IBOutlet weak var lbl_Delay_Height: NSLayoutConstraint!
    
    var viewModel : OrderDetailViewModel?
    var orderId:String?
    var convertedDate : String?
    var orderItemList = [Suborder]()
    var isFromFeedBack : Bool?
    var currancy:String?
    var trackStatus:Int?
    var jobDate:String?
    var currentDate:String?
    var instractionList = [String]()
    var paymentType : Int?
    var price:String?
    var otp:String?
    var imgURL:URL!
    
    //MARK:- lifeCycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        // showNAV_BAR(controller: self)
    }
    //MARK:- Other functions
    func setUI()
    {
        self.viewModel = OrderDetailViewModel.init(Delegate: self, view: self)
        //TableView
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
        
        tbleInstrtuction.delegate = self
        tbleInstrtuction.dataSource = self
        tbleInstrtuction.separatorStyle = .none
        tbleInstrtuction.tableFooterView = UIView()
        
        // imgCompany.CornerRadius(radius: 8)
        viewLine.backgroundColor = Appcolor.kThemeColor
        //  imgCompany.imageroundCorners([.topRight,.topLeft], radius: 28)
        //getCurrentDate
        let currentdate = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM yyyy"
        currentDate = formatter.string(from: currentdate)//"22 Aug 2020"//
        
        if(isFromFeedBack == true){
            btnCompleteOrder.isHidden = true
            kBtnCompleteOrderHeight.constant = 0
        }
        else{
            // if(trackStatus == 8 || self.trackStatus == 9){
            if(trackStatus == 3 || trackStatus == 6 || trackStatus == 7 || trackStatus == 2){
                btnCompleteOrder.isHidden = false
                kBtnCompleteOrderHeight.constant = 58
            }
            else{
                btnCompleteOrder.isHidden = true
                kBtnCompleteOrderHeight.constant = 0
            }
            
        }
        //setColor
        btnCompleteOrder.backgroundColor = Appcolor.kOrangeThemeColor
        btnCompleteOrder.setTitleColor(Appcolor.kTextColorWhite, for: .normal)
        lblStatus.textColor = Appcolor.kGreenColor
        lblTotalAmount.textColor = Appcolor.kThemeColor
        
        getDetailApi()
    }
    
    //MARK:- hit APi
    
    func cashCollection(){
        viewModel?.cashCollect(orderId: self.orderId ?? "", amount: price, completion: { (response) in
            //StartIndicator(message: kLoading)
            self.UpdateTrackStatusApi(status: "5", id: self.orderId, otp: self.otp ?? "", imgURL: self.imgURL)
        })
    }
    
    func getDetailApi(){
        self.viewModel?.getDetailListApi(orderId: orderId, completion: { (data) in
            print(data)
            if let orderDetail = data.body{
                self.setDate(date:orderDetail.serviceDateTime)
                self.lblOrderNo.text = orderDetail.orderNo ?? ""
                self.price = orderDetail.orderPrice ?? ""
                self.priorityLabel(status:data.body?.priority ?? 0)
                self.paymentType = orderDetail.paymentType ?? 0
          self.lblDiscount.text = (orderDetail.currency ?? "") + (orderDetail.walletBalanceUsed ?? "")
                if let data = orderDetail.deliveryInstructions{
                    if data.count > 0{
                        self.instractionList = data
                        self.tbleInstrtuction.isHidden = false
                        self.kTbleInstructionHeight.constant = CGFloat((self.instractionList.count) * 60)
                        self.tbleInstrtuction.reloadData()
                    }
                    else{
                        self.tbleInstrtuction.isHidden = true
                        self.kTbleInstructionHeight.constant = 0
                        
                    }
                }
                
                self.lblCompAddress.text = orderDetail.company?.address1 ?? ""
                self.lblCompanyName.text = orderDetail.company?.companyName ?? ""
                self.viewCompRate.settings.fillMode = .precise
                if orderDetail.delay == "0" || orderDetail.delay == ""{
                    self.lbl_Delay_Height.constant = 0
                    self.lbl_Delay.isHidden = true
                }else{
                    self.lbl_Delay.text = "Order is delaying \(orderDetail.delay ?? "0") mins"
                    self.lbl_Delay_Height.constant = 17
                    self.lbl_Delay.isHidden = false
                }
               
                
                if (orderDetail.company?.rating != "")
                {
                    self.viewCompRate.rating = Double(orderDetail.company?.rating ?? "0.0")!
                    let rate = Double(orderDetail.company?.rating ?? "0.0")
                    self.lblRating.text = (String(format: "%.1f",rate ?? 0.0)) + " Ratings"
                }
                if let url = orderDetail.company?.logo1
                {
                    self.imgCompany.setImage(with: url, placeholder: "noImage")
                }
                else{
                    self.imgCompany.image = UIImage(named: "noImage")
                }
                if (orderDetail.tip ?? "" == "" || orderDetail.tip ?? "" == "0" || orderDetail.tip ?? "" == "0.0"){
                    self.stackViewTips.isHidden = true
                }
                else{
                    self.stackViewTips.isHidden = false
                    self.lblTips.text = (orderDetail.currency ?? "") + (orderDetail.tip ?? "")
                }
                if (orderDetail.orderStatus?.statusName ?? "" == "Completed"){
                    self.btnUpdateDelay.isHidden = true
                }else{
                    self.btnUpdateDelay.isHidden = false
                }
                self.lblStatus.text = orderDetail.orderStatus?.statusName ?? ""
                if(orderDetail.progressStatus == 5){
                  //  self.lblStatus.text = "Delivered"
                    self.lblStatus.textColor = Appcolor.kGreenColor
                    self.btnCompleteOrder.isHidden = true
                    self.kBtnCompleteOrderHeight.constant = 0
                }
                else{
                    //self.lblStatus.text = "Pending"
                    self.lblStatus.textColor = Appcolor.kRedColor
                    if(self.isFromFeedBack == true){
                        self.btnCompleteOrder.isHidden = true
                        self.kBtnCompleteOrderHeight.constant = 0
                    }
                    else{
                        
                        if(self.trackStatus == 8 || self.trackStatus == 9){
                            
                            if (self.currentDate == self.jobDate ?? ""){
                                self.btnCompleteOrder.isHidden = false
                                self.kBtnCompleteOrderHeight.constant = 58
                            }
                            else{
                                self.btnCompleteOrder.isHidden = true
                                self.kBtnCompleteOrderHeight.constant = 0
                            }
                        }
                        else{
                            
                            self.btnCompleteOrder.isHidden = true
                            self.kBtnCompleteOrderHeight.constant = 0
                            
                        }
                    }
                }
                self.lblTotalAmount.text =  (orderDetail.currency ?? "")  + (orderDetail.totalOrderPrice ?? "")
                self.lblAddress.text = orderDetail.address?.addressName
                self.lblPickAddress.text = self.lblCompAddress.text

                
                if orderDetail.suborders?.count == 1{
                    self.lblItemCount.text = "\(orderDetail.suborders?.count ?? 0) item"
                }
                else{
                    self.lblItemCount.text = "\(orderDetail.suborders?.count ?? 0) items"
                }
                self.currancy = orderDetail.currency ?? ""
                
                if let data = orderDetail.suborders{
                    if data.count  > 0{
                        self.orderItemList = data
                        self.kTableViewHeight.constant = ( CGFloat(self.orderItemList.count * 135))
                        self.tableView.reloadData()
                    }
                    else{
                        self.kTableViewHeight.constant = ( CGFloat(self.orderItemList.count * 135))
                    }
                }
            }
        })
    }
    
    
    func priorityLabel(status:Int)
    {
        switch status
        {
        case 0:
            self.lblPriority.text = "Priority: Low"
            self.lblPriority.textColor = .orange
        case 1:
            self.lblPriority.text = "Priority: Low"
            self.lblPriority.textColor = .orange
        case 2:
            self.lblPriority.text = "Priority: Medium"
            self.lblPriority.textColor = .green
        case 3:
            self.lblPriority.text = "Priority: Medium"
            self.lblPriority.textColor = .green
        case 4:
            self.lblPriority.text = "Priority: High"
            self.lblPriority.textColor = .red
            
        default:
            break
        }
    }
    
    func setDate(date: String?)
    {
        let ndate = date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        dateFormatter.timeZone = NSTimeZone(name: "UTC")! as TimeZone
        dateFormatter.formatterBehavior = .default
        let date = dateFormatter.date(from:date ?? "")
        let dateTime = "\(date!)"
        if let date = dateTime.components(separatedBy: "+").first
        {
            convertedDate = "\(date)"
        }
        
        let strDateTime = self.convertFromUTCtoLocal(dateToConvert: ndate ?? "")
        lblDeliveryMethod.text = strDateTime
        
        let dateFormatterGet = DateFormatter()
        //Fri Apr 3 2020 2:00 PM
        dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss"
        //MonthFormateWithDay
        let dateFormatterMonth = DateFormatter()
        //2020-03-30 14:00:00
        dateFormatterMonth.dateFormat = " d MMM yyyy, h:mm a"
        if let date = dateFormatterGet.date(from: convertedDate ?? "")
        {
            print(dateFormatterMonth.string(from: date))
            // lblDeliveryMethod.text = dateFormatterMonth.string(from: date)
        }
        else
        {
            print("There was an error decoding the string")
        }
        
        let date_Formatter = DateFormatter()
        //2020-03-30 14:00:00
        date_Formatter.dateFormat = "d MMM yyyy"
        if let date = dateFormatterGet.date(from: convertedDate ?? "")
        {
            print(date_Formatter.string(from: date))
            jobDate = date_Formatter.string(from: date)
        }
        else
        {
            print("There was an error decoding the string")
        }
    }
    
    //MARK:- hit api updateTrack
    func UpdateTrackStatusApi(status:String?,id:String?,otp:String,imgURL:URL?)
    {
        viewModel?.UpdateTrackStatusApi(Id: id ?? "", status: status, otp: otp, orderImage: imgURL, completion: { (response) in
            print(response)
            self.AlertMessageWithOkAction(titleStr: kAppName, messageStr: "Order Completed Successfully", Target: self) {
                self.navigationController?.popViewController(animated: false)
            }
        })
    }
    //MARK:- Actions
    @IBAction func orderDelayAction(_ sender: Any) {
        let controller = Navigation.GetInstance(of: .OrderDelayAlert) as! OrderDelayAlert
        controller.orderId = self.orderId
        self.navigationController?.present(controller, animated: false, completion: nil)
    }
    
    @IBAction func btnCompleteOrderAction(_ sender: Any)
    {
        self.AlertMessageWithOkCancelAction(titleStr: kAppName, messageStr: "Are you sure you want to cpmplete this order.", Target: self) { (alert) in
            if alert == KYes{
                let controller = Navigation.GetInstance(of: .AlertVC) as! AlertVC
                controller.isStartJob = false
                controller.alertDelegate = self
                self.navigationController?.present(controller, animated: false, completion: nil)
            }
        }
        
    }
    @IBAction func btnBackAction(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: false)
    }
}

//MARK:- TableViewDelegateAndDataSource

extension OrderDetailVC : UITableViewDelegate, UITableViewDataSource
{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        var count = 0
        if(tableView == tbleInstrtuction){
            count = self.instractionList.count
        }
        else{
            count = orderItemList.count
        }
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if(tableView == tbleInstrtuction){
            let cell = tableView.dequeueReusableCell(withIdentifier: "InstructionListCell")as! InstructionListCell
            cell.lblDetail.text = self.instractionList[indexPath.row]
            return cell
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "DetailOrderListCell")as! DetailOrderListCell
            cell.setUI()
            cell.setData(data:orderItemList[indexPath.row],currency:currancy)
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    
}

//MARK:- ViewDelegate
extension OrderDetailVC : OrderDetailDelegate{
    func Show(msg: String) {
        
    }
    
    func didError(error: String) {
        showAlertMessage(titleStr: kAppName, messageStr: error)
    }
    
    
}

extension OrderDetailVC : AlertDelegate{
    
    func startCompleteJobAction(url: URL, otp: String, isStart: Bool) {
        
        btnCompleteOrder.isUserInteractionEnabled = false
        self.otp = otp
        self.imgURL = url
        if paymentType == 2{
            self.cashCollection()
        }
        else{
            self.UpdateTrackStatusApi(status: "5", id: self.orderId, otp: otp, imgURL: url)
        }
    }
    
    
}
