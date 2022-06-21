//
//  JobHistoryCell.swift
//  DriverDeliveryApp
//
//  Created by Navaldeep Kaur on 04/05/20.
//  Copyright © 2020 Navaldeep Kaur. All rights reserved.
//

import UIKit

class JobHistoryCell: UITableViewCell {
    //MARK:-Outlet and Variables
    @IBOutlet weak var btnDetail: UIButton!
    @IBOutlet weak var lblRestaurantName: UILabel!
    @IBOutlet weak var lblDateTime: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblOrderType: UILabel!
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var lblItems: UILabel!
    @IBOutlet weak var lblPaymentType: UILabel!
    
    var convertedDate : String?
    var viewDelegate : JobHistory_Delegate?
    var totalOrders:String?
    var payment = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    //MARK:- other Functions
    func setUI(){
        // lblPrice.textColor = Appcolor.kThemeColor
        imgView.CornerRadius(radius: 8)
    }
    
    func setData(data:Body1?){
       // lblAddress.text = (data?.address?.houseNo ?? "") + "," + (data?.address?.addressName ?? "")
        lblPrice.text = (data?.currency ?? "") + (data?.totalOrderPrice ?? "")
        lblRestaurantName.text = data?.company?.companyName ?? ""
        lblAddress.text = data?.company?.address1 ?? ""
        if data?.paymentType == 2{
               payment = "Cash on delivery"
            }else{
                payment = "Paid"
            }
            
            lblPaymentType.text = (payment)//crash
        
      //  if let url = data?.companyAddress?.logo1
      //  {
      //     self.imgView.setImage(with: url, placeholder: noImage)
      //   }
        
        let img = data?.suborders![0].service?.thumbnail ?? ""
        self.imgView.setImage(with: img, placeholder: noImage)
        
        lblOrderType.text = data?.orderNo ?? ""
        var orderNames:String?
        totalOrders = ""
        
        //Naval
        if let subOrders = data?.suborders{
        for orderName in subOrders{
            if totalOrders == ""
            {
                totalOrders = "\(orderName.quantity ?? "")" + " X " + "\(orderName.service?.name ?? "")"
            }
            else{
                orderNames = (totalOrders ?? "") + " , " + "\(orderName.quantity ?? "")" + " X "
                totalOrders = (orderNames ?? "") + "\(orderName.service?.name ?? "")"
            }
        }
        }
        
        
        
        
        let ndate = data?.serviceDateTime ?? ""
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        dateFormatter.timeZone = NSTimeZone(name: "UTC")! as TimeZone
        dateFormatter.formatterBehavior = .default
        let date = dateFormatter.date(from:ndate)
        let dateTime = "\(date!)"
        if let date = dateTime.components(separatedBy: "+").first
        {
            convertedDate = "\(date)"
        }
        
        let strDateTime = self.convertFromUTCtoLocalNew(dateToConvert: ndate)
        lblDateTime.text = strDateTime
        
        lblItems.text = totalOrders
        
        
        
        
        
 //old
//        lblItems.text = totalOrders
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
//        dateFormatter.timeZone = NSTimeZone(name: "UTC")! as TimeZone
//        dateFormatter.formatterBehavior = .default
//        let date = dateFormatter.date(from: data?.serviceDateTime ?? "")
//        let dateTime = "\(date!)"
//        if let date = dateTime.components(separatedBy: "+").first
//        {
//            convertedDate = "\(date)"
//        }
//
//
//        let dateFormatterGet = DateFormatter()
//        //Fri Apr 3 2020 2:00 PM
//        dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss"
//        //MonthFormateWithDay
//        let dateFormatterMonth = DateFormatter()
//        //2020-03-30 14:00:00
//        dateFormatterMonth.dateFormat = "d MMM yyyy, h:mm a"
//        if let date = dateFormatterGet.date(from: convertedDate ?? "")
//        {
//            print(dateFormatterMonth.string(from: date))
//            lblDateTime.text = dateFormatterMonth.string(from: date)
//        }
//        else
//        {
//            print("There was an error decoding the string")
//        }
        
        if data?.progressStatus == 5
        {
            lblStatus.text = "Order Completed"
            lblStatus.textColor = Appcolor.kGreenColor
        }
        else{
            //            if (data?.cancellable == true){
            //                lblStatus.text = "Cancelled"
            //                lblStatus.textColor = Appcolor.kRedColor
            //            }
            //            else{
            lblStatus.text = "Order Pending"
            lblStatus.textColor = Appcolor.kRedColor
            //  }
            
        }
    }
    
    @IBAction func btnDetailAction(_ sender: Any) {
        viewDelegate?.jobDetail(index:(sender as AnyObject).tag)
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    func convertFromUTCtoLocalNew(dateToConvert:String) -> String
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
            return timeStamp
        }
        
        return "N/A"
    }
    
}
