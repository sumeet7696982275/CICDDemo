//
//  TransferMoneyAlert.swift
//  DriverDeliveryApp
//
//  Created by Navaldeep Kaur on 19/03/21.
//  Copyright © 2021 Navaldeep Kaur. All rights reserved.
//

import UIKit

protocol transferDelegate:class {
    func transferAction()
}

class TransferMoneyAlert: UIViewController {
    
    //MARK:- Outlet and variables
    @IBOutlet weak var txtAmount: UITextField!
    var currentBalance = 0
    var tap: UITapGestureRecognizer!
    var viewModel : WalletHistoryViewModel?
    var delegate : transferDelegate?
    
    //MARK:- lifeCycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = WalletHistoryViewModel.init(Delegate: self, view: self)
        tap = UITapGestureRecognizer(target: self, action: #selector(dismissView))
        view.addGestureRecognizer(tap)
        txtAmount.addDoneButtonToKeyboard(target:self,myAction:  #selector(self.doneButtonAction), Title: kDone)
    }
    
    //MARK:-Actions
    @objc func doneButtonAction()
    {
        self.txtAmount.resignFirstResponder()
    }
    
    @objc func dismissView() {
        self.dismiss(animated: false, completion: nil)
        self.view.removeGestureRecognizer(tap)
    }
    
    
    @IBAction func doneAction(_ sender: Any)
    {
        let amnt = Int(txtAmount.text ?? "")
        guard let amount = txtAmount.text,!amount.isEmpty, !amount.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,amnt ?? 0 > 0 else
        {
            self.showAlertMessage(titleStr: kAppName, messageStr: "Enter amount")
            return
        }
        
        
        
        let enterAmount = Int(txtAmount.text ?? "") ?? 0
        if enterAmount > currentBalance{
            self.showAlertMessage(titleStr: kAppName, messageStr: "You cannot enter more than wallet amount")
        }else{
            viewModel?.transferMoneyApi(amount: txtAmount.text ?? "", completion: { (data) in
                self.AlertMessageWithOkAction(titleStr: kAppName, messageStr: data.message ?? "", Target: self) {
                    self.dismiss(animated: false, completion: nil)
                    self.delegate?.transferAction()
                }
            })
        }
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
}


//MARK:- delegate

extension  TransferMoneyAlert : WalletHistoryDelegate{
    func Show(msg: String) {
    }
    
    func didError(error: String) {
    }
    
}

//MARK:- TextFeild Delegate
extension TransferMoneyAlert:UITextFieldDelegate
{
    func textFieldShouldClear(_ textField: UITextField) -> Bool
    {
        return true;
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool
    {
        if textField == txtAmount{
            self.txtAmount.resignFirstResponder()
        }
        return true;
    }
    
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        if (string == " ") && (textField.text?.count)! == 0
        {
            return false
        }
        return true
    }
}
