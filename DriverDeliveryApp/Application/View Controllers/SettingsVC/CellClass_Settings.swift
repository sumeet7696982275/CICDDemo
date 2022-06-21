//
//  CellClass_Settings.swift
//  UrbanClap Replica
//
//  Created by Mohit Sharma on 5/21/20.
//  Copyright © 2020 Seasia Infotech. All rights reserved.
//

import UIKit

class CellClass_Settings: UITableViewCell
{

    @IBOutlet weak var ivBG: UIImageView!
    @IBOutlet var lblText: UILabel!
    @IBOutlet var btnTapOnCell: UIButton!
    @IBOutlet weak var imgView: UIImageView!
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        // Initialization code
        self.ivBG.layer.cornerRadius = 20
        self.ivBG.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(false, animated: animated)

        // Configure the view for the selected state
    }

}
