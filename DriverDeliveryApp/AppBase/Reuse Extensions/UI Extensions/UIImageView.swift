//
//  UIImageView.swift
//  BidJones
//
//  Created by Rakesh Kumar on 3/22/18.
//  Copyright © 2018 Seasia. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher

extension UIImageView
{
    
    func Rounded() {
        self.layer.cornerRadius = (self.frame.width / 2)
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.masksToBounds = true
    }
    func CornerRadius(radius:CGFloat)
    {
           self.layer.cornerRadius = radius
           self.layer.borderColor = UIColor.lightGray.cgColor
           self.layer.masksToBounds = true
       }
    
    
}

extension UIImageView
{
    func setImage(with urlString: String, placeholder:String)
    {
        guard let url = URL.init(string: urlString) else
        {
            return
        }
        //            let resource = ImageResource(downloadURL: url, cacheKey: urlString)
        //            var kf = self.kf
        //            kf.indicatorType = .activity
        //            //self.kf.placeholder
        //         self.kf.setImage(with: resource)
        
        //            let url = URL(string: urlString)
        ////            let processor = DownsamplingImageProcessor(size: self.frame.size)
        ////                |> RoundCornerImageProcessor(cornerRadius: 0)
        let scale = UIScreen.main.scale
        let resizingProcessor = ResizingImageProcessor(referenceSize: CGSize(width: self.frame.size.width * scale, height: self.frame.size.height * scale))
        //
        self.kf.indicatorType = .activity
        self.kf.setImage(
            with: url,
            placeholder: UIImage(named: placeholder),
            options: [
                .processor(resizingProcessor),
                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(1)),
                .cacheOriginalImage
            ])
        {
            result in
            switch result {
            case .success(let value):
                
                print("Task done for: \(value.source.url?.absoluteString ?? "")")
            case .failure(let error):
                print("Job failed: \(error.localizedDescription)")
            }
            
        }
    }
    
    func setImageColor(color: UIColor) {
       let templateImage = self.image?.withRenderingMode(.alwaysTemplate)
       self.image = templateImage
       self.tintColor = color
     }



}

