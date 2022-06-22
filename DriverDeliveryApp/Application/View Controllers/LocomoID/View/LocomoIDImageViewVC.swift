//
//  LocomoIDImageViewVC.swift
//  DriverApp
//
//  Created by Poonam  on 10/12/20.
//  Copyright © 2020 Seasia. All rights reserved.
//

import UIKit
import SDWebImage


protocol LocomoIDImageDelegate
{
    func refreshView()
}

class LocomoIDImageViewVC: UIViewController
{
    @IBOutlet weak var IMGSetView: UIImageView!
    
     var delegateOrder:LocomoIDImageDelegate?
    
    var imgUrl : String?

    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.setUI()
       
    }

    

    @IBAction func ActionBackBtn(_ sender: Any) {
       self.dismiss(animated: true) {
           self.delegateOrder?.refreshView()
       }
    }
    
    func setUI()
    {
    
        IMGSetView.sd_setImage(with: URL(string:  imgUrl ?? ""), placeholderImage: UIImage(named: kplaceholderProfile), options: SDWebImageOptions(rawValue: 0))
                       { (image, error, cacheType, imageURL) in
                           self.IMGSetView.image = image
            self.IMGSetView.layer.cornerRadius = 8.0
                           self.IMGSetView.clipsToBounds = true
                       }
    }
}
