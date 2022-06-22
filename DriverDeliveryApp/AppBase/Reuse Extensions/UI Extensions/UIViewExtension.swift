//
//  UIViewExtension.swift
//  Fleet Management
//
//  Created by Mohit Sharma on 2/25/20.
//  Copyright © 2020 Seasia Infotech. All rights reserved.
//

import Foundation
import UIKit

class RoundShadowView: UIView
{
    
    private var shadowLayer: CAShapeLayer!
    private var cornerRadius: CGFloat = 10.0
    private var fillColor: UIColor = .white // the color applied to the shadowLayer, rather than the view's backgroundColor
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if shadowLayer == nil {
            shadowLayer = CAShapeLayer()
            
            shadowLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius).cgPath
            shadowLayer.fillColor = fillColor.cgColor
            
            shadowLayer.shadowColor = UIColor.black.cgColor
            shadowLayer.shadowPath = shadowLayer.path
            shadowLayer.shadowOffset = CGSize(width: 0.0, height: 1.0)
            shadowLayer.shadowOpacity = 0.8
            shadowLayer.shadowRadius = 3
            
            layer.insertSublayer(shadowLayer, at: 0)
        }
    }
    
}


class RoundView: UIView
{
    
    private var cornerRadius: CGFloat = 10.0
    
    override func layoutSubviews()
    {
        super.layoutSubviews()
        
        self.layer.cornerRadius = cornerRadius
        self.layer.masksToBounds = true
        
    }

}

extension UIView
{
    
    
    func roundCorners_TOPLEFT_TOPRIGHT_WithShadow(val:Int)
    {
        DispatchQueue.main.asyncAfter(deadline: .now()) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: val, height: val))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = self.bounds
        maskLayer.path = path.cgPath
        self.layer.mask = maskLayer
        
//          //  let shadowLayer = CAShapeLayer()
//
//            maskLayer.path = UIBezierPath(roundedRect: self.bounds, cornerRadius: CGFloat(val)).cgPath
//            maskLayer.fillColor = UIColor.clear.cgColor
//
//            maskLayer.shadowColor = UIColor.black.cgColor
//            maskLayer.shadowPath = maskLayer.path
//            maskLayer.shadowOffset = CGSize(width: 1.0, height: 1.0)
//            maskLayer.shadowOpacity = 1.0
//            maskLayer.shadowRadius = 2
//
//            self.layer.insertSublayer(maskLayer, at: 0)
            
        }
    }
    
    func roundCorners_TOPLEFT_TOPRIGHT(val:Int)
    {
        DispatchQueue.main.asyncAfter(deadline: .now()) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: val, height: val))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = self.bounds
        maskLayer.path = path.cgPath
        self.layer.mask = maskLayer
        }
    }
    
    func roundCorners(val:Int)
    {
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: [.topLeft, .topRight, .bottomLeft, .bottomRight], cornerRadii: CGSize(width: val, height: val))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = self.bounds
        maskLayer.path = path.cgPath
        self.layer.mask = maskLayer
        }
    }
    
    func roundCorners_BottomLeft(val:Int)
    {
        DispatchQueue.main.asyncAfter(deadline: .now()) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: [.bottomLeft], cornerRadii: CGSize(width: val, height: val))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = self.bounds
        maskLayer.path = path.cgPath
        self.layer.mask = maskLayer
        }
    }
    
    func roundCorners_BottomLeftRight(val:Int)
    {
        DispatchQueue.main.asyncAfter(deadline: .now()) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: [.bottomLeft,.bottomRight], cornerRadii: CGSize(width: val, height: val))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = self.bounds
        maskLayer.path = path.cgPath
        self.layer.mask = maskLayer
        }
    }
    
    func dropShadow(radius:CGFloat)
    {
        layer.masksToBounds = false
        layer.cornerRadius = radius
        
        // set the shadow properties
        layer.backgroundColor = UIColor.clear.cgColor
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 4, height: 4.0)
        layer.shadowOpacity = 0.2
        layer.shadowRadius = 2
    }
    
    //MARK:- Remove shadow
    func removeShadow()
    {
        layer.masksToBounds = false
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowOpacity = 0.0
    }
    
    //MARK: BOUNCE YOUR VIEW USING LAYER ANIMATION
    func explicitBounceAnimation()
    {
        let bounceAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
        var values = [Double]()
        let e = 2.71
        
        for t in 1..<100
        {
            let value = 0.6 * pow(e, -0.045 * Double(t)) * cos(0.1 * Double(t)) + 1.0
            values.append(value)
        }
        
        bounceAnimation.values = values
        bounceAnimation.duration = TimeInterval(0.5)
        bounceAnimation.calculationMode = CAAnimationCalculationMode.cubic
        
        layer.add(bounceAnimation, forKey: "bounceAnimation")
    }
    
    
    //MARK: FADE OUT UIVIEW
    func fadeOut(duration: TimeInterval)
    {
        UIView.animate(withDuration: duration) {
            self.alpha = 0.0
        }
    }
    
    //MARK: FADE IN UIVIEW
    func fadeIn(duration: TimeInterval)
    {
        UIView.animate(withDuration: duration) {
            self.alpha = 1.0
        }
    }
    
    
    enum animDirection
    {
        case top
        case left
        case right
        case bottom
    }
    
    func animateView(from: animDirection)
    {
        
        guard let window = UIApplication.shared.keyWindow else {return}
        let originalFrame = self.frame
        var tempFrame = originalFrame
        
        switch from
        {
        case .top:
            tempFrame.origin.y = -window.bounds.height
        case .bottom:
            tempFrame.origin.y = window.bounds.height
        case .left:
            tempFrame.origin.x = -window.bounds.width
        case .right:
            tempFrame.origin.x = window.bounds.width
        }
        
        self.frame = tempFrame
        
        UIView.animate(withDuration: 1.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 6, options: .curveEaseInOut, animations: {
            self.frame = originalFrame
        }) { _ in
        }
        
    }
    
}
