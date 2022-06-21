//
//  DetailOrderListCell.swift
//  DriverDeliveryApp
//
//  Created by Navaldeep Kaur on 05/05/20.
//  Copyright © 2020 Navaldeep Kaur. All rights reserved.
//

import UIKit

class DetailOrderListCell: UITableViewCell {
    
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblNumber: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblDetail: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setUI(){
        
        lblPrice.textColor = Appcolor.kThemeColor
        
    }
    func setData(data:Suborder,currency:String?){
        lblUserName.text = data.service?.name ?? ""
        lblNumber.text = "Quantity : " + (data.quantity ?? "")
       
        lblPrice.text = (currency ?? "$")  + "\(data.service?.price ?? 0)"
        lblDetail.text = data.service?.duration
        if let url = data.service?.thumbnail
        {
            self.imgView.setImage(with: url, placeholder: noImage)
        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
