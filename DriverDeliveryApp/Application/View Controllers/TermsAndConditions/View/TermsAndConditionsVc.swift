//
//  TermsAndConditionsVc.swift
//  DriverDeliveryApp
//
//  Created by Navaldeep Kaur on 06/05/20.
//  Copyright © 2020 Navaldeep Kaur. All rights reserved.
//

import UIKit

class TermsAndConditionsVc: CustomController
{
    @IBOutlet weak var viewWeb: UIWebView!
    @IBOutlet weak var btnMenu: UIBarButtonItem!
    @IBOutlet weak var lblTitle: UILabel!
    
    var isFromTermCondition:Bool?
    var viewModel:Terms_Conditions_View_Model?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.hideNAV_BAR(controller: self)
        self.viewModel = Terms_Conditions_View_Model.init(Delegate: self, view: self)
        self.hit_Service_Terms_Condition_Api()
    }
    
    
    func hit_Service_Terms_Condition_Api() {
        self.viewModel?.getTermsConditionsListApi(completion: { (data) in
            if(self.isFromTermCondition == true){
                self.lblTitle.text = "Terms & Conditions"
                self.openWebView(url: data.body?.termsLink ?? "")
            }
            else{
                self.lblTitle.text = "Privacy & Policy"
                self.openWebView(url: data.body?.privacyLink ?? "")
            }
        })
    }
    
    func openWebView(url: String)
    {
        let url = URL (string: url)
        let request = URLRequest(url: url!)
        viewWeb.loadRequest(request)
    }
    
    @IBAction func backAction(_ sender: Any) {
         self.navigationController?.popViewController(animated: false)
    }
    
}


extension TermsAndConditionsVc: TermsConditionsDelegate{
    func Show(msg: String) {
        print(msg)
    }
    
    func didError(error: String) {
        print(error)
    }
    
    
}
