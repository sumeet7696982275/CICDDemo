//
//  UILabel.swift
//  BidJones
//
//  Created by Rakesh Kumar on 5/3/18.
//  Copyright © 2018 Seasia. All rights reserved.
//

import Foundation
import UIKit
extension UILabel
{
    var optimalHeight : CGFloat
    {
        get
        {
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height: 2000))
            label.numberOfLines = 0
            label.lineBreakMode = self.lineBreakMode
            label.font = self.font
            label.text = self.text
            label.sizeToFit()
            return label.frame.height
        }
    }
}
