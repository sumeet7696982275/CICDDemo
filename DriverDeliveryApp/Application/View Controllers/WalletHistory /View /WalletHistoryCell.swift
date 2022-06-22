//
//  WalletHistoryCell.swift
//  DriverDeliveryApp
//
//  Created by Navaldeep Kaur on 02/11/20.
//  Copyright © 2020 Navaldeep Kaur. All rights reserved.
//

import UIKit

class WalletHistoryCell: UITableViewCell {
    
    //MARK:- outlet and variables 
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblOrderId: UILabel!
    @IBOutlet weak var lblPayment: UILabel!
    @IBOutlet weak var lblAmount: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    
     var convertedDate : String?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setData(data:WalletBody){
        
        let dateFormatter = DateFormatter()
               dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
               dateFormatter.timeZone = NSTimeZone(name: "UTC")! as TimeZone
               dateFormatter.formatterBehavior = .default
               let date = dateFormatter.date(from: data.updatedAt ?? "")
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
               dateFormatterMonth.dateFormat = "dd MMM yyyy"
               if let date = dateFormatterGet.date(from: convertedDate ?? "")
               {
                   print(dateFormatterMonth.string(from: date))
                   lblDate.text = dateFormatterMonth.string(from: date)
               }
               else
               {
                   print("There was an error decoding the string.")
               }
       // lblDate.text = data.updatedAt ?? ""
        lblAmount.text = "\(AppDefaults.shared.currency)" + (data.amount ?? "")
        lblDescription.text = data.purpose ?? ""
       // lblOrderId.text = data.order?.orderNo ?? ""
        if data.payType == 0{
            lblOrderId.textColor = UIColor.green
            lblOrderId.text = "Debited"
        }
        else{
            lblOrderId.textColor = UIColor.red
            lblOrderId.text = "Credited"
        }
    }
}
