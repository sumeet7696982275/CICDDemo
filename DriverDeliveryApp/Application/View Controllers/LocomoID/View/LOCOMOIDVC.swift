//
//  LOCOMOIDVC.swift
//  DriverApp
//
//  Created by Poonam  on 18/11/20.
//  Copyright © 2020 Seasia. All rights reserved.
//

import UIKit
import SDWebImage

class LOCOMOIDVC: UIViewController {

    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblLocoPhn: UILabel!
    @IBOutlet weak var lblMobilePhn: UILabel!
    @IBOutlet weak var lblCity: UILabel!
    @IBOutlet weak var lblLocoID: UILabel!
    @IBOutlet weak var imgDelivery: UIImageView!
    @IBOutlet weak var viewBottom: CustomUIView!
    @IBOutlet weak var lblView: CustomUIView!
    @IBOutlet weak var viewTop: CustomUIView!
    
    var viewModel:locomoIdViewModel?
    var locoModelId : LOCOMOIDModel?
    var locoIDData : BodyID?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel = locomoIdViewModel.init(Delegate: self, view: self)
        self.viewModel?.getLocomoIDDetail(completion: { (response) in
                  self.locoModelId = response
                  self.locoIDData = self.locoModelId?.body
                  self.setData()
              })
        // Do any additional setup after loading the view.
    }
    
    func setData(){
        if self.locoModelId?.code == 208{
            viewBottom.isHidden = true
            viewTop.isHidden = false
            lblView.isHidden = false
            if self.locoIDData?.image != ""{
                let radius = self.imgProfile.frame.width / 2
                self.imgProfile.layer.cornerRadius = radius
                self.imgProfile.layer.masksToBounds = true
                self.imgProfile.layer.borderWidth = 4
                self.imgProfile.layer.borderColor =  UIColor.white.cgColor
                imgProfile.sd_setImage(with: URL(string: self.locoIDData?.image ?? ""), placeholderImage: UIImage(named: kplaceholderProfile), options: SDWebImageOptions(rawValue: 0))
                { (image, error, cacheType, imageURL) in
                    self.imgProfile.image = image
                }
            }
        }else{
            viewBottom.isHidden = false
            lblView.isHidden = true
            viewTop.isHidden = false
            self.lblName.text = self.locoIDData?.userName
            self.lblLocoID.text = self.locoIDData?.employeeId
            self.lblCity.text = self.locoIDData?.address ?? ""
            self.lblMobilePhn.text = self.locoIDData?.phoneNumber
            self.lblLocoPhn.text = self.locoIDData?.compNo
            self.lblEmail.text = self.locoIDData?.compEmail
            if self.locoIDData?.image != ""{
                let radius = self.imgProfile.frame.width / 2
                self.imgProfile.layer.cornerRadius = radius
                self.imgProfile.layer.masksToBounds = true
                self.imgProfile.layer.borderWidth = 4
                self.imgProfile.layer.borderColor =  UIColor.white.cgColor
                imgProfile.sd_setImage(with: URL(string: self.locoIDData?.image ?? ""), placeholderImage: UIImage(named: kplaceholderProfile), options: SDWebImageOptions(rawValue: 0))
                { (image, error, cacheType, imageURL) in
                    self.imgProfile.image = image
                }
            }
            if self.locoIDData?.compLogo != ""{
            
             imgDelivery.sd_setImage(with: URL(string: self.locoIDData?.compLogo ?? ""), placeholderImage: UIImage(named: kplaceholderProfile), options: SDWebImageOptions(rawValue: 0))
                { (image, error, cacheType, imageURL) in
                    self.imgDelivery.image = image
                }
            }
        }
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: false)
    }
    @IBAction func actionImageView(_ sender: UIButton)
    {
        if(self.locoIDData?.compIdUrl?.count ?? 0 > 0)
        {
            let storyBoard: UIStoryboard = UIStoryboard(name: "Home", bundle: nil)
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "LocomoIDImageViewVC") as! LocomoIDImageViewVC
            newViewController.delegateOrder = self
            newViewController.imgUrl = self.locoIDData?.compIdUrl
            self.navigationController?.present(newViewController, animated: true, completion: nil)
        }
        else
        {
            self.showAlertMessage(titleStr: kAppName, messageStr: "Sorry, the image url is not correct")
        }
        
    }
    
    @IBAction func actionDownloadIDImg(_ sender: Any)
    {
        if let url = URL(string: self.locoIDData?.compIdUrl ?? ""),
            let data = try? Data(contentsOf: url),
            let image = UIImage(data: data)
        {
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
            self.showAlertMessage(titleStr: kAppName, messageStr: "Saved locomo IDCard in gallery.")
            //self.showToastSwift(alrtType: .success, msg: "Saved locomo IDCard in gallery.", title: "")
        }
        else
        {
            self.showAlertMessage(titleStr: kAppName, messageStr: "Sorry this image url is not correct for downloading")
        }
    }
}
extension LOCOMOIDVC : locomoIdDelegate{
    
    func didError(error:String)
    {
        self.showAlertMessage(titleStr: kAppName, messageStr: error)
    }
}
extension LOCOMOIDVC:LocomoIDImageDelegate
{
    func refreshView()
    {
       
    }
}
