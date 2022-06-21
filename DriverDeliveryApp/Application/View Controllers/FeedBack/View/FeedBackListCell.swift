//
//  FeedBackListCell.swift
//  DriverDeliveryApp
//
//  Created by Navaldeep Kaur on 02/05/20.
//  Copyright © 2020 Navaldeep Kaur. All rights reserved.
//

import UIKit
import Cosmos

class FeedBackListCell: UITableViewCell {

    //MARK:- outlet and Variables
    @IBOutlet weak var imgViewUser: UIImageView!
    @IBOutlet weak var viewRating: CosmosView!
    @IBOutlet weak var lblComment: UILabel!
    @IBOutlet weak var lblDateTime: UILabel!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var btnDetail: UIButton!
    var convertedDate : String?
    var viewDelegate : FeedbackDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    //MARK:- setData
    func setData(data:Rating){
        viewRating.settings.fillMode = .precise
        lblUserName.text = data.user?.firstName ?? "" + (data.user?.lastName ?? "")
        lblComment.text = data.review ?? ""
        if (data.rating != "") {
        viewRating.rating = Double(data.rating ?? "0")!
        }
        else{
            viewRating.rating = 0.0
        }
        imgViewUser.CornerRadius(radius: imgViewUser.frame.height / 2)
        if let url = data.user?.image
         {
            self.imgViewUser.setImage(with: url, placeholder: kplaceholderProfile)
          }
        
        let dateFormatter = DateFormatter()
              dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
              dateFormatter.timeZone = NSTimeZone(name: "UTC")! as TimeZone
              dateFormatter.formatterBehavior = .default
        if  let date = dateFormatter.date(from: data.order?.serviceDateTime ?? ""){
              let dateTime = "\(date)"
              if let date = dateTime.components(separatedBy: "+").first
              {
                  convertedDate = "\(date)"
              }
        }
              
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
                  lblDateTime.text = dateFormatterMonth.string(from: date)
              }
              else
              {
                  print("There was an error decoding the string")
              }
        
    }
    @IBAction func btnDetailAction(_ sender: Any) {
        self.viewDelegate?.showDetail(index: (sender as AnyObject).tag)
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
