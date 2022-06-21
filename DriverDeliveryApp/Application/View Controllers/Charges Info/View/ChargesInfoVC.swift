//
//  ChargesInfoVC.swift
//  DriverDeliveryApp
//
//  Created by Mohit's MAC on 24/05/21.
//  Copyright © 2021 Navaldeep Kaur. All rights reserved.
//

import UIKit

class ChargesInfoVC: UIViewController
{
    
    @IBOutlet weak var lblSecurityAmnt: UILabel!
    @IBOutlet weak var lblSecurityDesc: UILabel!
    @IBOutlet weak var lblOrderPenalty: UILabel!
    @IBOutlet weak var lblPenaltyDesc: UILabel!
    
    @IBOutlet weak var viewTargets: CustomUIView!
    @IBOutlet weak var targetViewHeught: NSLayoutConstraint!
    @IBOutlet weak var PlanViewHeight: NSLayoutConstraint!
    @IBOutlet weak var lblCurrentPlan: UILabel!
    @IBOutlet weak var lblPlanAmnt: UILabel!
    @IBOutlet weak var lblPlanCredit: UILabel!
    
    @IBOutlet weak var lblOrderTarget: UILabel!
    @IBOutlet weak var lblOrdertargetEarning: UILabel!
    
    @IBOutlet weak var lblDistanceOrderTarget: UILabel!
    @IBOutlet weak var lblDistanceOrderRNING: UILabel!
    
    
    
    var apiDATA: chargesBody?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.set_statusBar_color(view: self.view)
        self.getInfo()
        
        // Do any additional setup after loading the view.
    }
    
    
    
    
    @IBAction func acnMoveback(_ sender: Any)
    {
        self.moveBACK(controller: self)
    }
    
    func getInfo()
    {
        WebService.Shared.GetApi(url: APIAddress.GET_SETTINGSINFO, Target: self, showLoader: true)
        { (result) in
            
            do
                   {
                    let jsonData = try JSONSerialization.data(withJSONObject: result, options: .prettyPrinted)
                    let data = try JSONDecoder().decode(chargesModel.self, from: jsonData)
                    self.apiDATA = data.body
                    let crrncy = AppDefaults.shared.currency
                    
                    self.lblSecurityAmnt.text = "Security Amount: \(crrncy)\(data.body?.securityCOD ?? "0")"
                    self.lblSecurityDesc.text = "Security amount should be available in your wallet to receive the Cash On Delivery orders."
                    self.lblOrderPenalty.text = "Cancel Order Penalty: \(crrncy)\(data.body?.penalityAfterAcceptance ?? "0")"
                    self.lblPenaltyDesc.text = "You need to pay the penalty charges for accepted orders. A sum of \(crrncy)\(data.body?.penalityAfterAcceptance ?? "0") will be deducted from your earnings."
                    
                    
                    
                    //Earnings
                    if data.body?.currentPlan?.wagesType == "0"//commission based
                    {
                        let cmmssn = data.body?.currentPlan?.commissionPercentage ?? "0"
                        self.lblCurrentPlan.text = "Current Plan: Commission Based"
                        self.lblPlanAmnt.text = "Commission: \(cmmssn)%"
                        self.lblPlanCredit.text = ""
                        self.PlanViewHeight.constant = 80
                    }
                    else//fixed plan
                    {
                        var creditType = data.body?.currentPlan?.installments ?? "0"
                        let amnt = data.body?.currentPlan?.wagesAmount ?? "0"
                        self.lblCurrentPlan.text = "Current Plan: Fixed Salary"
                        self.lblPlanAmnt.text = "Amount: \(crrncy)\(amnt)"
                        
                        if(creditType == "0")
                        {
                            creditType = "Daily"
                        }
                        else if(creditType == "1")
                        {
                            creditType = "Weekly"
                        }
                        else if(creditType == "2")
                        {
                            creditType = "Monthly"
                        }
                        
                        self.lblPlanCredit.text = "Amount credit in your wallet: \(creditType) basis"
                        self.PlanViewHeight.constant = 130
                    }
                    
                    
                    let orderTarget = data.body?.earningOrderTarget ?? ""
                    let orderTargetAmnt = data.body?.earningOnOrder ?? ""
                    let orderTargetDistance = data.body?.earningdistanceTarget ?? ""
                    let orderTargetDistancAmnt = data.body?.earningOnDistance ?? ""
                    
                    //Targets
                    if(data.body?.earningScenario == "0")//No targets
                    {
                        self.targetViewHeught.constant = 0
                        self.viewTargets.isHidden = true
                    }
                    else if(data.body?.earningScenario == "1")//order basis targets
                    {
                        self.targetViewHeught.constant = 135
                        self.viewTargets.isHidden = false
                        
                        self.lblOrderTarget.text = "Order Target: \(orderTarget)"
                        self.lblOrdertargetEarning.text = "Order Earning: \(crrncy)\(orderTargetAmnt)"
                        
                        self.lblDistanceOrderTarget.text = ""
                        self.lblDistanceOrderRNING.text = ""
                       
                    }
                    else if(data.body?.earningScenario == "2")//distance basis targets
                    {
                        self.targetViewHeught.constant = 135
                        self.viewTargets.isHidden = false
                        
                        self.lblOrderTarget.text = "Distance Target: \(orderTargetDistance)KM"
                        self.lblOrdertargetEarning.text = "Distance Earning Per KM: \(crrncy)\(orderTargetDistancAmnt)"
                        
                        self.lblDistanceOrderTarget.text = ""
                        self.lblDistanceOrderRNING.text = ""
                    }
                    else if(data.body?.earningScenario == "3")//both
                    {
                        self.targetViewHeught.constant = 206
                        self.viewTargets.isHidden = false
                        
                        self.lblOrderTarget.text = "Order Target: \(orderTarget)"
                        self.lblOrdertargetEarning.text = "Order Earning: \(crrncy)\(orderTargetAmnt)"
                        
                        self.lblDistanceOrderTarget.text = "Distance Target: \(orderTargetDistance)KM"
                        self.lblDistanceOrderRNING.text = "Distance Earning Per KM: \(crrncy)\(orderTargetDistancAmnt)"
                    }
                    
                    
                   }
            catch
            {
                self.showAlertMessage(titleStr: "Error", messageStr: error.localizedDescription)
            }
            
        } completionnilResponse: { (err) in
            self.showAlertMessage(titleStr: "Error", messageStr: err)
        }
        
    }
}


