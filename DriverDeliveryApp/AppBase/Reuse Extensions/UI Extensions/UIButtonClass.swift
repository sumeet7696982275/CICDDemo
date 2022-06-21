//
//  UIButtonClass.swift
//  Fleet Management
//
//  Created by Mohit Sharma on 2/25/20.
//  Copyright © 2020 Seasia Infotech. All rights reserved.
//

import Foundation
import UIKit

class ButtonWithShadowAndRadious: UIButton
{

    
    func updateLayerProperties()
    {
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        self.layer.masksToBounds = false
        self.layer.shadowRadius = 1.0
        self.layer.shadowOpacity = 0.5
        self.layer.cornerRadius = 10
        self.layer.borderColor = Appcolor.kTextColorGray.cgColor
        self.layer.borderWidth = 0.2
    }

    
    func updateLayerProperties_withCornerRadious(rds:CGFloat)
    {
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        self.layer.masksToBounds = false
        self.layer.shadowRadius = 1.0
        self.layer.shadowOpacity = 0.5
        self.layer.cornerRadius = rds
    }
}


