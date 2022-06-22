//
//  Enums.swift
//  UnionGoods
//
//  Created by Rakesh Kumar on 11/22/19.
//  Copyright © 2019 Seasia infotech. All rights reserved.
//

import Foundation
import UIKit

class Navigation
{
    enum type
    {
        case root
        case push
        case present
        case pop
    }
    
    enum Controller
    {
        //AUTH
        case CheckOTPVC
        case LoginWithPhoneVC
      //  case SignUPVC
        case SignInVC
        case ResetPasswordVC
        case ChangePasswdVC
        case ServicesListVC
        case HistoryServicesVC
        case UpComingServicesVC
        case ServiceDetailsVC
        case NotificationVC
        case SignupVC
        
        //HOME
        case HomeScreenVC
        case EditProfileVC
        case MapVC
        case AlertCanacelJobVC
        case FeedBackVC
        case JobHistoryVC
        case OrderDetailVC
        case TermsAndConditionsVc
        case ChangeStatusVC
        case WalletHistoryVC
        case LOCOMOIDVC
        case AlertVC
        case OrderDelayAlert
        case TransferMoneyAlert
        case PaymentDetailVC
        case AppTutorailVC
        case MyEarningsVC
        case ChargesInfoVC
        case GeoFenceAreaVC
        
        //JOBS
        case HomeVC
        case JobListVC
        case NewJobsVC
        case JobsHistoryVC
        
        //FUEL
        case AddFuelDetailVC
        case FuelListVC
        
        
        
        var obj: UIViewController?
        {
            switch self
            {
                
            //AUTH
            case .CheckOTPVC:
                return StoryBoards.Main.obj?.instantiateViewController(withIdentifier: "CheckOTPVC")
            case .LoginWithPhoneVC:
                return StoryBoards.Main.obj?.instantiateViewController(withIdentifier: "LoginWithPhoneVC")
                
          //  case .SignUPVC:
               // return StoryBoards.Main.obj?.instantiateViewController(withIdentifier: "SignUPVC")
            
            case .SignupVC:
                return StoryBoards.Main.obj?.instantiateViewController(withIdentifier: "SignupVC")
                
            case .SignInVC:
                return StoryBoards.Main.obj?.instantiateViewController(withIdentifier: "SignInVC")
                
            case .ResetPasswordVC:
                return StoryBoards.Main.obj?.instantiateViewController(withIdentifier: "ResetPasswordVC")
            case .ChangePasswdVC:
                return StoryBoards.Main.obj?.instantiateViewController(withIdentifier: "ChangePasswdVC")
            case .EditProfileVC:
                return StoryBoards.Home.obj?.instantiateViewController(withIdentifier: "EditProfileVC")
            case .ServicesListVC:
                return StoryBoards.Main.obj?.instantiateViewController(withIdentifier: "ServicesListVC")
            case .HistoryServicesVC:
                return StoryBoards.Main.obj?.instantiateViewController(withIdentifier: "HistoryServicesVC")
            case .UpComingServicesVC:
                return StoryBoards.Main.obj?.instantiateViewController(withIdentifier: "UpComingServicesVC")
            case .ServiceDetailsVC:
                return StoryBoards.Main.obj?.instantiateViewController(withIdentifier: "ServiceDetailsVC")
            case .NotificationVC:
                return StoryBoards.Home.obj?.instantiateViewController(withIdentifier: "NotificationVC")
            case .AlertVC:
                return StoryBoards.Home.obj?.instantiateViewController(withIdentifier: "AlertVC")
            case .PaymentDetailVC:
                               return StoryBoards.Home.obj?.instantiateViewController(withIdentifier: "PaymentDetailVC")

                
            //HOME
            case .HomeScreenVC:
                return StoryBoards.Home.obj?.instantiateViewController(withIdentifier: "HomeScreenVC")
                
            case .MapVC:
                return StoryBoards.Home.obj?.instantiateViewController(withIdentifier: "MapVC")
            case .HomeVC:
                return StoryBoards.Home.obj?.instantiateViewController(withIdentifier: "HomeVC")
            case .JobListVC:
                return StoryBoards.Home.obj?.instantiateViewController(withIdentifier: "JobListVC")
            case .NewJobsVC:
                return StoryBoards.Home.obj?.instantiateViewController(withIdentifier: "NewJobsVC")
            case .JobsHistoryVC:
                return StoryBoards.Home.obj?.instantiateViewController(withIdentifier: "JobsHistoryVC")
            case .TransferMoneyAlert:
                return StoryBoards.Home.obj?.instantiateViewController(withIdentifier: "TransferMoneyAlert")
                
                
            //FUEL
            case .FuelListVC:
                return StoryBoards.Home.obj?.instantiateViewController(withIdentifier: "FuelListVC")
            case .AddFuelDetailVC:
                return StoryBoards.Home.obj?.instantiateViewController(withIdentifier: "AddFuelDetailVC")
            case .AlertCanacelJobVC:
                return StoryBoards.Home.obj?.instantiateViewController(withIdentifier: "AlertCanacelJobVC")
            case .FeedBackVC:
                return StoryBoards.Home.obj?.instantiateViewController(withIdentifier: "FeedBackVC")
            case .JobHistoryVC:
                return StoryBoards.Home.obj?.instantiateViewController(withIdentifier: "JobHistoryVC")
            case .OrderDetailVC:
                return StoryBoards.Home.obj?.instantiateViewController(withIdentifier: "OrderDetailVC")
            case .TermsAndConditionsVc:
                return StoryBoards.Home.obj?.instantiateViewController(withIdentifier: "TermsAndConditionsVc")
            case .ChangeStatusVC:
                return StoryBoards.Home.obj?.instantiateViewController(withIdentifier: "ChangeStatusVC")
            case .WalletHistoryVC:
                return StoryBoards.Home.obj?.instantiateViewController(withIdentifier: "WalletHistoryVC")
                
            case .LOCOMOIDVC:
                return StoryBoards.Home.obj?.instantiateViewController(withIdentifier: "LOCOMOIDVC")
            case .OrderDelayAlert:
                return StoryBoards.Home.obj?.instantiateViewController(withIdentifier: "OrderDelayAlert")
                
            case .AppTutorailVC:
                  return StoryBoards.Home.obj?.instantiateViewController(withIdentifier: "AppTutorailVC")
                
            case .MyEarningsVC:
                  return StoryBoards.Home.obj?.instantiateViewController(withIdentifier: "MyEarningsVC")
                
            case .ChargesInfoVC:
                  return StoryBoards.Home.obj?.instantiateViewController(withIdentifier: "ChargesInfoVC")
                
                
                
            case .GeoFenceAreaVC:
                return StoryBoards.Home.obj?.instantiateViewController(withIdentifier: "GeoFenceAreaVC")
            }
        }
    }
    enum StoryBoards
    {
        case Main
        case Home
        
        var obj: UIStoryboard?
        {
            switch self
            {
            case .Main:
                return UIStoryboard(name: "Main", bundle: nil)
            case .Home:
                return UIStoryboard(name: "Home", bundle: nil)
                
            }
        }
        
    }
    
    static func GetInstance(of controller : Controller) -> UIViewController
    {
        return controller.obj!
    }
    
}

