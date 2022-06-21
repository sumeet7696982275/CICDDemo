//
//  OrderDelayAlert.swift
//  DriverDeliveryApp
//
//  Created by Navaldeep Kaur on 17/03/21.
//  Copyright © 2021 Navaldeep Kaur. All rights reserved.
//

import UIKit
import DropDown

class OrderDelayAlert: UIViewController,UITextViewDelegate {

    //MARK:- outlet and variables
    
    @IBOutlet weak var btnUpdate: CustomButton!
    @IBOutlet weak var txtView: CustomUITextView!
    @IBOutlet weak var txtDelayType: UITextField!
    
    var viewModel : OrderDetailViewModel?
    var delayTypeArray = ["15 mins","30 mins","45 mins","60 mins"]
    let dropDown = DropDown()
    var orderId:String?
     var tap: UITapGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setView()
    }
    
    //MARK:-other functions
    
    func setView(){
        viewModel = OrderDetailViewModel.init(Delegate: self, view: self)
        tap = UITapGestureRecognizer(target: self, action: #selector(dismissView))
        view.addGestureRecognizer(tap)
        dropDown.dataSource = delayTypeArray
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            print("Selected item: \(item) at index: \(index)")
            self.txtDelayType.text = item
                }
        // dropDown.selectionBackgroundColor = Appcolor.kTheme_Color
        DropDown.startListeningToKeyboard()
    }
    
    @objc func dismissView() {
           self.dismiss(animated: false, completion: nil)
              self.view.removeGestureRecognizer(tap)
          }
    
    @IBAction func selectType(_ sender: UIButton) {
        dropDown.anchorView = sender
        dropDown.show()
    }
    
    @IBAction func updateAction(_ sender: Any)
    {
        guard let delayType = txtDelayType.text,!delayType.isEmpty, !delayType.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else
               {
                self.showAlertMessage(titleStr: kAppName, messageStr: "Select delay type")
                   return
               }
        guard let delayComment = txtView.text,!delayComment.isEmpty, !delayComment.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else
                      {
                       self.showAlertMessage(titleStr: kAppName, messageStr: "Select delay comment")
                          return
                      }
        viewModel?.DelayOrderApi(Id: orderId ?? "", time: txtDelayType.text, delayReason: txtView.text, completion: { (data) in
            self.AlertMessageWithOkAction(titleStr: kAppName, messageStr: data.message ?? "", Target: self) {
                self.dismiss(animated: false, completion: nil)
            }
        })
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool
    {
        if(text == "\n")
        {
            self.view.endEditing(true)
        }
        
        return true
    }
    
    
}


//MARK:- ViewDelegate
extension OrderDelayAlert : OrderDetailDelegate{
    func Show(msg: String) {
        
    }
    
    func didError(error: String) {
        showAlertMessage(titleStr: kAppName, messageStr: error)
    }
    
    
}
