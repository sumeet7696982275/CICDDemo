//
//  HomeTableCell.swift
//  DriverDeliveryApp
//
//  Created by Navaldeep Kaur on 01/05/20.
//  Copyright © 2020 Navaldeep Kaur. All rights reserved.
//

import UIKit

class HomeTableCell: UITableViewCell {
    
    //MARK:-Outlet and Variables
    @IBOutlet weak var btnShowAddress: UIButton!
    @IBOutlet weak var lblOrderType: UILabel!
    @IBOutlet weak var lblDateTime: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var btnCall: CustomButton!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblTypeOrder: UILabel!
    @IBOutlet var lblAmntTitle: UILabel!
    
    @IBOutlet weak var btnStart: CustomButton!
    @IBOutlet weak var btnCancel: CustomButton!
    @IBOutlet weak var btnDetail: CustomButton!
    @IBOutlet var lblPriority: UILabel!
    
    @IBOutlet weak var lblDeliveryAddress: UILabel!
    
    var viewDelegate:HomeViewDelegate?
    var convertedDate : String?
    var jobDate:String?
    var jobStatus:Int?
    var currency : String?
    var cancellable = false
    var payment = ""
    var orderType = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    //MARK:- Other functions
    func add_shadow(btn:UIButton)
    {
        btn.layer.shadowColor = Appcolor.klightBlueColor.cgColor
        btn.layer.shadowOffset = CGSize(width: 5, height: 5)
        btn.layer.masksToBounds = false
        btn.layer.shadowRadius = 2.0
        btn.layer.shadowOpacity = 1.0
        
    }
    func setUI(){
        //    lblPrice.textColor = Appcolor.kThemeColor
        self.btnCall.backgroundColor = Appcolor.kOrangeThemeColor
        self.btnCall.setTitleColor(Appcolor.kTextColorWhite, for: UIControl.State.normal)
        
        self.btnStart.backgroundColor = Appcolor.kOrangeThemeColor
        self.btnStart.setTitleColor(Appcolor.kTextColorWhite, for: UIControl.State.normal)
        self.btnCancel.backgroundColor = Appcolor.kRedColor
        self.btnCancel.setTitleColor(Appcolor.kTextColorWhite, for: UIControl.State.normal)
        add_shadow(btn: btnStart)
        add_shadow(btn: btnCancel)
    }
    
    @IBAction func showAddressAction(_ sender: Any) {
        viewDelegate?.showMap(index:(sender as AnyObject).tag)
    }
    func setData(data:Body1!)
    {
        if(data?.jobInProgress == nil)
        {
            AppDefaults.shared.isJobStarted = ""
        }
        else
        {
            if (data?.jobInProgress == true)
            {
                AppDefaults.shared.isJobStarted = "true"
            }
            else
            {
                AppDefaults.shared.isJobStarted = ""
            }
        }
        
        
        lblAddress.text = (data?.address?.houseNo ?? "") + "," + (data?.address?.addressName ?? "")//(data?.company?.address1 ?? "")
        
        if data?.paymentType == 2{
            payment = "Cash on delivery"
        }else{
            payment = "Paid"
        }
        
        lblDeliveryAddress.text = (payment)//(data?.address?.houseNo ?? "") + "," + (data?.address?.addressName ?? "")
        if (data?.currency?.contains("RUPEES") ?? false)
        {
            currency = "Rs"
        }
        else
        {
            currency = data?.currency ?? ""
            AppDefaults.shared.currency = currency ?? "Rs"
        }
        lblPrice.text = (currency ?? "") + (data?.totalOrderPrice ?? "")
        
        lblOrderType.text = data?.orderNo ?? ""
        
        
        UTCtoLocal(dateToConvert:data?.serviceDateTime ?? "",lbl:self.lblDateTime)
        
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        dateFormatter.timeZone = NSTimeZone(name: "UTC")! as TimeZone
        dateFormatter.formatterBehavior = .default
        let date = dateFormatter.date(from: data?.serviceDateTime ?? "")
        let dateTime = "\(date!)"
        if let date = dateTime.components(separatedBy: "+").first
        {
            convertedDate = "\(date)"
        }
        
        
        let dateFormatterGet = DateFormatter()
        //Fri Apr 3 2020 2:00 PM
        dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss"
        //MonthFormateWithDay
        let dateFormatterMonth = DateFormatter()
        //2020-03-30 14:00:00
        dateFormatterMonth.dateFormat = "d MMM yyyy, h:mm a"
        if let date = dateFormatterGet.date(from: convertedDate ?? "")
        {
            print(dateFormatterMonth.string(from: date))
            //lblDateTime.text = dateFormatterMonth.string(from: date)
        }
        else
        {
            print("There was an error decoding the string.")
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
            print("There was an error decoding the string.")
        }
        //getCurrentDate
        let currentdate = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM yyyy"
        let currentDate =  formatter.string(from: currentdate) //"10 May 2021"//
        // "15 Aug 2020"//
        jobStatus = data?.assignedEmployees?[0].jobStatus ?? 0
        if(jobStatus == 0)
        {
            btnStart.isUserInteractionEnabled = true
            btnStart.isHidden = false
            btnStart.setTitle("Take Order", for: .normal)
            btnCancel.setTitle("Reject", for: .normal)
            // btnCancel.isUserInteractionEnabled = true
            btnStart.isUserInteractionEnabled = true//mohit
            self.cancellable = true
            btnStart.backgroundColor = Appcolor.kThemeColor
            btnCancel.backgroundColor = Appcolor.kRedColor
        }
        else
        {
            self.btnStart.backgroundColor = Appcolor.kOrangeThemeColor
            btnCancel.backgroundColor = Appcolor.kThemeColor
            btnStart.setTitle("Set Status", for: .normal)
            btnCancel.setTitle("Cancel", for: .normal)
            if (currentDate == jobDate ?? "")
            {
                if (data?.jobInProgress == true)//AppDefaults.shared.startedJobId != "")
                {
                    if (AppDefaults.shared.startedJobId == data?.id ?? "")
                    {
                        btnStart.isUserInteractionEnabled = true
                        btnStart.isHidden = false
                        btnStart.backgroundColor = Appcolor.kOrangeThemeColor
                    }
                    else
                    {
                        //Naval
                        // btnStart.isUserInteractionEnabled = false
                        // btnStart.isHidden = true
                        // btnStart.backgroundColor = Appcolor.kDisableBlueColor
                        
                        
                        //Mohit m adding this because its not allowing start button visible 
                        btnStart.isUserInteractionEnabled = true
                        btnStart.isHidden = false
                        btnStart.backgroundColor = Appcolor.kOrangeThemeColor
                    }
                    
                }
                else
                {
                    
                    btnStart.isUserInteractionEnabled = true
                    btnStart.isHidden = false
                    btnStart.backgroundColor = Appcolor.kOrangeThemeColor
                }
            }
            else{
                btnStart.isUserInteractionEnabled = false
                btnStart.isHidden = true
                btnStart.backgroundColor = Appcolor.kDisableBlueColor
            }
            
            switch data?.progressStatus {
            case 0:
                // btnStart.setTitle("Start", for: .normal)
                //  btnCancel.isUserInteractionEnabled = true//mohit
                self.cancellable = true
                //  btnStart.isHidden = false
                // btnCancel.backgroundColor = Appcolor.kThemeColor
                break
            case 8://8,3,6,7:
                //  btnStart.setTitle("On the Way", for: .normal)
                // btnCancel.isUserInteractionEnabled = false
                self.cancellable = false
                //  btnCancel.backgroundColor = Appcolor.kDisableRedColor
                break
            case 9://9:
                //  btnStart.setTitle("Reached", for: .normal)
                //                       btnCancel.isUserInteractionEnabled = false
                // btnStart.isHidden = true
                // btnCancel.isUserInteractionEnabled = false
                self.cancellable = false
                //   btnCancel.backgroundColor = Appcolor.kDisableRedColor
                break
            case 5:
                //  btnStart.setTitle("Completed", for: .normal)
                //                       btnCancel.isUserInteractionEnabled = false
                // btnStart.isHidden = true
                // btnCancel.isUserInteractionEnabled = false
                self.cancellable = false
                //    btnCancel.backgroundColor = Appcolor.kDisableRedColor
                break
            default:
                
                break
            }
        }
        
        if data?.deliveryType == "1"{
            orderType = "Visit Home"
        }else{
            orderType = "Visit Vendor"
            btnStart.isUserInteractionEnabled = false
            btnCancel.isUserInteractionEnabled = false
            btnCancel.backgroundColor = Appcolor.kDisableThemeColor
            btnStart.backgroundColor = Appcolor.kDisableThemeColor
            
        }
        lblTypeOrder.text = orderType
        
        let statusPriority = data?.priority ?? 0
        
        //checking order priority
        
        switch statusPriority
        {
        case 0:
            lblPriority.text = "Priority: Low"
            lblPriority.textColor = .orange
        case 1:
            lblPriority.text = "Priority: Low"
            lblPriority.textColor = .orange
        case 2:
            lblPriority.text = "Priority: Medium"
            lblPriority.textColor = .green
        case 3:
            lblPriority.text = "Priority: Medium"
            lblPriority.textColor = .green
        case 4:
            lblPriority.text = "Priority: High"
            lblPriority.textColor = .red
            
        default:
            break
        }
    }
    
    
    
    //MARK:-Actions
    @IBAction func btnDetailAction(_ sender: Any) {
        viewDelegate?.orderDetail(index:(sender as AnyObject).tag)
    }
    @IBAction func CallAction(_ sender: Any) {
        viewDelegate?.call(index:(sender as AnyObject).tag)
    }
    
    @IBAction func StartJobAction(_ sender: Any) {
        if(jobStatus == 0){
            viewDelegate?.acceptJob(index:(sender as AnyObject).tag)
        }
        else{
          
            viewDelegate?.startJob(index:(sender as AnyObject).tag, tag: (sender as AnyObject).tag)
        }
    }
    @IBAction func CancelJobAction(_ sender: Any)
    {
        if(self.cancellable == true)
        {
            if(jobStatus == 0)
            {
                viewDelegate?.rejectJob(index:(sender as AnyObject).tag)
            }
            else
            {
                viewDelegate?.cancelJob(index:(sender as AnyObject).tag)
            }
        }
        else
        {
            viewDelegate?.cancelJob(index:(sender as AnyObject).tag)
            //viewDelegate?.showAlert()
        }
        
    }
    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    func UTCtoLocal(dateToConvert:String,lbl:UILabel)
    {
        // create dateFormatter with UTC time format
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
        let date = dateFormatter.date(from: dateToConvert)// create   date from string
        
        // change to a readable time format and change to local time zone
        dateFormatter.dateFormat = "EEE MMM d, yyyy h:mm a"
        dateFormatter.timeZone = NSTimeZone.local
        
        if (date != nil)
        {
            let timeStamp = dateFormatter.string(from: date!)
            lbl.text = timeStamp
        }
        else
        {
            lbl.text = "N/A"
        }
    }
}
