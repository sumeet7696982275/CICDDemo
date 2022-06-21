//
//  Commands.swift
//  GoodsDelivery
//
//  Created by Gurleen Osahan on 11/29/19.
//  Copyright © 2019 Seasia infotech. All rights reserved.
//

import Foundation
import Foundation
class Commands
{
    
    private init()
    {
        
    }
    //For globally print the objects
    static func println(object: Any)
    {
        print(object)
    }
    
}

extension UIButton {
    
    func flash() {
        
        let flash = CABasicAnimation(keyPath: "opacity")
        flash.duration = 0.5
        flash.fromValue = 1
        flash.toValue = 0.5
        flash.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        flash.autoreverses = true
        //  flash.repeatCount = 3
        
        layer.add(flash, forKey: nil)
    }
    
    func flashButton() {
           
           let flash = CABasicAnimation(keyPath: "opacity")
           flash.duration = 0.8
           flash.fromValue = 1
           flash.toValue = 0.8
           flash.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
           flash.autoreverses = true
           //  flash.repeatCount = 3
           
           layer.add(flash, forKey: nil)
       }
    
    func fadeOut(duration: TimeInterval = 1.0, delay: TimeInterval = 0.5, completion: @escaping (Bool) -> Void = {(finished: Bool) -> Void in }) {
         self.alpha = 1.0

         UIView.animate(withDuration: duration, delay: delay, options: UIView.AnimationOptions.curveEaseOut, animations: {
           //  self.isHidden = true
             self.alpha = 0.0
         }, completion: completion)
     }
    
    func fadeIn(duration: TimeInterval = 1.0, delay: TimeInterval = 0.5, completion: @escaping ((Bool) -> Void) = {(finished: Bool) -> Void in }) {
           self.alpha = 0.0

           UIView.animate(withDuration: duration, delay: delay, options: UIView.AnimationOptions.curveEaseIn, animations: {
               self.isHidden = false
               self.alpha = 1.0
           }, completion: completion)
       }
}

extension UIImageView
{
    func fadeIn(duration: TimeInterval = 1.5, delay: TimeInterval = 0.8, completion: @escaping ((Bool) -> Void) = {(finished: Bool) -> Void in }) {
        self.alpha = 0.0

        UIView.animate(withDuration: duration, delay: delay, options: UIView.AnimationOptions.curveEaseIn, animations: {
            self.isHidden = false
            self.alpha = 1.0
        }, completion: completion)
    }

    func fadeOut(duration: TimeInterval = 0.5, delay: TimeInterval = 0.5, completion: @escaping (Bool) -> Void = {(finished: Bool) -> Void in }) {
        self.alpha = 1.0

        UIView.animate(withDuration: duration, delay: delay, options: UIView.AnimationOptions.curveEaseOut, animations: {
         //   self.isHidden = true
            self.alpha = 0.0
        }, completion: completion)
    }
}
