//
//  PaymentDetailVC.swift
//  DriverDeliveryApp
//
//  Created by Navaldeep Kaur on 19/03/21.
//  Copyright © 2021 Navaldeep Kaur. All rights reserved.
//

import UIKit



class PaymentDetailVC: UIViewController {
    
    //MARK:- outlet and variable
    @IBOutlet weak var txtBranchNAme: UITextField!
    @IBOutlet weak var txtBnkName: UITextField!
    @IBOutlet weak var txtAcHolderName: UITextField!
    @IBOutlet weak var txtBranchIFSC: UITextField!
    @IBOutlet weak var txtAccNo: UITextField!
    @IBOutlet weak var btnUpdate: CustomButton!
    
    var viewModel : PaymentDetailViewModel?
    var accountId : String?
    
    let validString = NSCharacterSet(charactersIn: "!₹@#$%^&*()_+{}[]|\"<>,.~`/:;?-=\\¥'£•¢.")
    
    //MARK:- lifeCycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = PaymentDetailViewModel.init(Delegate: self, view: self)
        setView()
    }
    
    func setView(){
        viewModel?.getBankDetail(completion: { (data) in
            if let detail = data.body{
                self.accountId = detail.empID ?? ""
                self.txtAccNo.text = detail.accountNo ?? ""
                self.txtBnkName.text = detail.branchName ?? ""
                self.txtBranchIFSC.text = detail.branchIFSC ?? ""
                self.txtBranchNAme.text = detail.branchName ?? ""
                self.txtAcHolderName.text = detail.acHolderName ?? ""
            }
        })
    }
    
    //MARK:- Actions
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: false)
    }
   
    @IBAction func btnUpdateAction(_ sender: Any) {
        
        let obj : [String:Any] = ["accountId":accountId ?? "","accountNo":txtAccNo.text ?? "","acHolderName":txtAcHolderName.text ?? "","bankName": txtBnkName.text ?? "","branchIFSC":txtBranchIFSC.text ?? "","branchName": txtBranchNAme.text ?? ""]
        viewModel?.Validations(obj: obj)
    }
}


extension PaymentDetailVC:PaymentDetailDelegate{
    func Show_results(msg: String) {
         showAlertMessage(titleStr: kAppName, messageStr: msg)
    }
    
    
    func didError(error: String) {
        showAlertMessage(titleStr: kAppName, messageStr: error)
    }
    
    
}

//MARK:- TextFeild Delegate
extension PaymentDetailVC:UITextFieldDelegate
{
    func textFieldShouldClear(_ textField: UITextField) -> Bool
    {
        return true;
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool
    {
        return true;
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//          if textField == txtAccNo{
//                 self.txtAcHolderName.becomeFirstResponder()
//
//              }
//              else if textField == txtAcHolderName{
//                  self.txtBnkName.becomeFirstResponder()
//              }
//              else if textField == txtBnkName{
//                self.txtBranchIFSC.becomeFirstResponder()
//              }
//              else if textField == txtBranchIFSC{
//                self.txtBranchNAme.becomeFirstResponder()
//              }
//              else{
//                self.txtBranchNAme.resignFirstResponder()
//              }
        self.view
            .endEditing(true)
          return true;
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        if (string == " ") && (textField.text?.count)! == 0
        {
            return false
        }
       
        if let range = string.rangeOfCharacter(from: validString as CharacterSet)//rangeOfCharacterFromSet(validString)
            {
                print(range)
                return false
            }
        
        return true
    }
}
