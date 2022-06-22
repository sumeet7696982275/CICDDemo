//
//  InstructionListCell.swift
//  DriverDeliveryApp
//
//  Created by Navaldeep Kaur on 21/08/20.
//  Copyright © 2020 Navaldeep Kaur. All rights reserved.
//

import UIKit

class InstructionListCell: UITableViewCell {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDetail: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
