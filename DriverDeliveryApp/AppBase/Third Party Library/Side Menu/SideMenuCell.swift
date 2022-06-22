//
//  SideMenuCell.swift
//  GoodsDelivery
//
//  Created by Rakesh Kumar on 12/19/19.
//  Copyright © 2019 Seasia infotech. All rights reserved.
//

import UIKit

class SideMenuCell: UITableViewCell
{
    @IBOutlet weak var lblName: UILabel!

    @IBOutlet var imgView: UIImageView!
    override func awakeFromNib()
    {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
