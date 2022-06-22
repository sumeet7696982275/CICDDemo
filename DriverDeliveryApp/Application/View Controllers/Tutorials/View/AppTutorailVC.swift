//
//  AppTutorailVC.swift
//  CourierApp
//
//  Created by Mohit Sharma on 10/5/20.
//  Copyright © 2020 Cerebrum Infotech. All rights reserved.
//

import UIKit

class AppTutorailVC: UIViewController
{
    
    @IBOutlet var btnSidebar: UIButton!
    @IBOutlet var collView: UICollectionView!
    @IBOutlet var myPager: UIPageControl!
    var approach = ""
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
      //  self.setStatusBarColor(view: self.view, color: Appcolor.kThemeColorStatusBar)
        btnSidebar.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        myPager.numberOfPages = 3
        
        if(approach == "sidebar")
        {
            btnSidebar.isHidden = false
        }
        else
        {
            btnSidebar.isHidden = true
        }
        
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func cellActionStart(_ sender: Any)
    {
//        if(approach == "sidebar")
//        {
//            AppDefaults.shared.tabIndex = 3
////            let controller = Navigation.GetInstance(of: .CreateOrderStageOne) as! CreateOrderStageOne
////            self.pushToController(from_controller: self, to_Controller: controller)
//            let controller = Navigation.GetInstance(of: .CreateOrderPlaceholder)
//            self.pushToController(from_controller: self, to_Controller: controller)
//        }
//        else
//        {
            self.dismiss(animated: true, completion: nil)
      //  }
        
    }
    
    
    
}

extension AppTutorailVC : UICollectionViewDelegate,UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellClassTutorials", for:  indexPath)as! cellClassTutorials
        
        
        
        if(indexPath.row == 0)
        {
            cell.lblTitle.text = "Real Time Tracking"
            cell.lblDedc.text = "Payment made easy through debit card, credit card & more ways to pay for your food"
            //cell.viewBg.backgroundColor = Appcolor.kThemeColor
            //cell.viewUnderLIne.backgroundColor = Appcolor.kThemeColorButtons
        }
        else if(indexPath.row == 1)
        {
            cell.lblTitle.text = "Delivery On Time"
            cell.lblDedc.text = "Payment made easy through debit card, credit card & more ways to pay for your food"
            //cell.viewBg.backgroundColor = Appcolor.kThemeColorButtons
           // cell.viewUnderLIne.backgroundColor = Appcolor.kThemeColor
        }
        else if(indexPath.row == 2)
        {
            cell.lblTitle.text = "Easy Payment"
            cell.lblDedc.text = "Payment made easy through debit card, credit card & more ways to pay for your food"
           // cell.viewBg.backgroundColor = Appcolor.kThemeColor
          //  cell.viewUnderLIne.backgroundColor = Appcolor.kThemeColorButtons
          //  cell.btnStart.backgroundColor = Appcolor.kThemeColorButtons
            cell.btnStart.isHidden = false
        }
//        else if(indexPath.row == 3)
//        {
//            cell.lblTitle.text = "Delivery Service"
//            cell.lblDedc.text = "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since"
//            cell.viewBg.backgroundColor = Appcolor.kThemeColor
//            cell.viewUnderLIne.backgroundColor = Appcolor.kThemeColorButtons
//            cell.btnStart.backgroundColor = Appcolor.kThemeColorButtons
//            cell.btnStart.isHidden = false
//        }
        
      //  cell.viewBg.roundCorners_TOPLEFT_TOPRIGHT(val:30)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath)
    {
        let cell2  = cell as! cellClassTutorials
        self.myPager.currentPage = indexPath.row
        if(indexPath.row == 2)
        {
            self.myPager.isHidden = true
            cell2.ivMid.image = UIImage(named: "T3")
            cell2.ivBG.image = UIImage(named: "")
            cell2.ivLocation.isHidden = true
            
            if(approach == "tabs")
            {
                cell2.btnStart.isHidden = false
            }
        }
        else if (indexPath.row == 1)
        {
            cell2.ivLocation.isHidden = false
            self.myPager.isHidden = false//false
            cell2.btnStart.isHidden = true
            cell2.ivMid.image = UIImage(named: "T2")
            //cell2.ivBG.image = UIImage(named: "tutBG")
        }
        else
        {
            cell2.ivLocation.isHidden = false
            self.myPager.isHidden = false//false
            cell2.btnStart.isHidden = true
            cell2.ivMid.image = UIImage(named: "T1")
            //cell2.ivBG.image = UIImage(named: "tutBG")
        }
    }
}

extension AppTutorailVC : UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        let view = self.view
        return CGSize(width: view!.frame.size.width, height: view!.frame.size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout,minimumLineSpacingForSectionAt section: Int) -> CGFloat
    {
        return 0.0
    }
    
}

class cellClassTutorials:UICollectionViewCell
{
    
    @IBOutlet var viewUnderLIne: CustomUIView!
    @IBOutlet var viewBg: UIView!
    @IBOutlet var ivBG: UIImageView!
    @IBOutlet var ivLocation: UIImageView!
    @IBOutlet var ivMid: UIImageView!
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var lblDedc: UITextView!
    @IBOutlet var btnStart: CustomButton!
    
}

