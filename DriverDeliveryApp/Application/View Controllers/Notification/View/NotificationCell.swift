//
//  NotificationCell.swift
//  DriverDeliveryApp
//
//  Created by Navaldeep Kaur on 07/05/20.
//  Copyright © 2020 Navaldeep Kaur. All rights reserved.
//

import UIKit

class NotificationCell: UITableViewCell {

    //MARK:- Outlet and Variables
    @IBOutlet weak var lblDetail: UILabel!
    @IBOutlet weak var lblOrderNAme: UILabel!
    @IBOutlet weak var lblDateTime: UILabel!
    
    var convertedDate : String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    //MARK:- Setdata
    func setData(data:Body18){
        lblDetail.text = data.notificationDescription ?? ""
        lblOrderNAme.text = data.notificationTitle ?? ""
        
          let dateFormatter = DateFormatter()
              dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
              dateFormatter.timeZone = NSTimeZone(name: "UTC")! as TimeZone
              dateFormatter.formatterBehavior = .default
        let date = dateFormatter.date(from: data.createdAt ?? "")
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
                  lblDateTime.text = dateFormatterMonth.string(from: date)
              }
              else
              {
                  print("There was an error decoding the string")
              }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
