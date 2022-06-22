//
//  WalletHistoryVC.swift
//  DriverDeliveryApp
//
//  Created by Navaldeep Kaur on 02/11/20.
//  Copyright © 2020 Navaldeep Kaur. All rights reserved.
//

import UIKit

class WalletHistoryVC: UIViewController {
    
    //MARK:- outlet and variables
    @IBOutlet weak var lblBalanceId: UILabel!
    @IBOutlet weak var txtStartDate: UITextField!
    @IBOutlet weak var btnSbumit: CustomButton!
    @IBOutlet weak var txtEndDate: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    var viewModel : WalletHistoryViewModel?
    var page = 1
    var selectedTextFeildTag : Int?
    let datePicker = UIDatePicker()
    var walletList = [WalletBody]()
    var isFetching:Bool = false
    var isScroll = false
    var balance:Double?
    
    //MARK:- lifecycle methods
    override func viewDidLoad()
    {
        super.viewDidLoad()
        if #available(iOS 13.4, *) {
            self.datePicker.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }
        setView()
        
    }
    //MARK:- Other functions
    
    func setView(){
        viewModel = WalletHistoryViewModel.init(Delegate: self, view: self)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
        tableView.layer.cornerRadius = 28
        
        //delegate
        txtStartDate.delegate = self
        txtEndDate.delegate = self
        showDatePicker()
        walletHistory(toDate: txtEndDate.text ?? "", fromDate: txtStartDate.text ?? "", page: "\(page)")
    }
    
    func walletHistory(toDate:String,fromDate:String,page:String){
        viewModel?.walletHistoryApi(fromDate: fromDate, toDate: toDate, page: page, payType: "", completion: { (response) in
            self.lblBalanceId.text = "Your wallet balance is: " + AppDefaults.shared.currency + "\(response.body.balance?.value ?? "0")"
            
            self.balance = Double(response.body.balance?.value ?? "0")
            if let data = response.body.data{
                if data.count > 0{
                    // self.walletList += data
                    for post in data {
                        if !self.walletList.contains(where: {$0.id == post.id }) {
                            self.walletList.append(post)
                        }
                        
                    }
                    self.isFetching = true
                    self.tableView.setEmptyMessage("")
                    self.tableView.reloadData()
                }
                else{
                    if self.isScroll == true{
                    }
                    else{
                        self.isFetching = false
                        self.tableView.setEmptyMessage("No record Found")
                        self.tableView.reloadData()
                    }
                }
            }
        })
    }
    
    //MARK: DATE PICKER SETUP
    func showDatePicker()
    {
        datePicker.datePickerMode = .date
        // datePicker.minimumDate = Calendar.current.date(byAdding: .day, value: +1, to: Date())
        
        //ToolBar
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatePicker));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));
        
        toolbar.setItems([cancelButton,spaceButton,doneButton], animated: false)
        self.txtStartDate.inputAccessoryView = toolbar
        self.txtStartDate.inputView = datePicker
        
        self.txtEndDate.inputAccessoryView = toolbar
        self.txtEndDate.inputView = datePicker
        
    }
    
    //MARK: DATE PICKER DONE BUTTON
    @objc func donedatePicker()
    {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-dd-yyyy"
        switch self.selectedTextFeildTag {
        case 0:
            self.txtStartDate.text = formatter.string(from: datePicker.date)
            break
        case 1:
            self.txtEndDate.text = formatter.string(from: datePicker.date)
            break
        default:
            break
        }
        self.view.endEditing(true)
    }
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: false)
    }
    
    //MARK: DATE PICKER CANCEL BUTTON
    @objc func cancelDatePicker()
    {
        self.view.endEditing(true)
    }
    
    //MARK:- EndDateValidations
    func endDateValidation(date:String?){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat =   "MM-dd-yyyy"
        //  let currentDate = dateFormatter.string(from: Date())
        //  let time = (currentDate) + " "  + (date ?? "")
        // dateFormatter.dateFormat =  "mm-dd-yyyy"
        let minDate = dateFormatter.date(from: date ?? "")
        datePicker.minimumDate = minDate
    }
    
    
    //MARK:-Actions
    @IBAction func submitAction(_ sender: Any) {
     
        if txtStartDate.text == ""{
            AlertMessageWithOkAction(titleStr: kAppName, messageStr: "Enter start date", Target: self) {
            }
        }else if txtEndDate.text == ""{
            AlertMessageWithOkAction(titleStr: kAppName, messageStr: "Enter end date", Target: self) {
            }
        }else{
            self.walletList.removeAll()
            walletHistory(toDate: txtEndDate.text ?? "", fromDate: txtStartDate.text ?? "", page: "\(page)")
        }
      
    }
    
    @IBAction func transferMoneyAction(_ sender: Any) {
        let controller = Navigation.GetInstance(of: .TransferMoneyAlert) as! TransferMoneyAlert
        controller.currentBalance = Int(self.balance ?? 0.0)
        controller.delegate = self
        self.navigationController?.present(controller, animated: false, completion: nil)
    }
}

//MARK:- TableViewDelegateAndDataSource

extension WalletHistoryVC : UITableViewDelegate, UITableViewDataSource
{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return walletList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WalletHistoryCell")as! WalletHistoryCell
        
        cell.setData(data:walletList[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    
}

//MARK:- delegate

extension  WalletHistoryVC : WalletHistoryDelegate{
    func Show(msg: String) {
        
    }
    
    func didError(error: String) {
        
    }
    
    
}

//MARK:- TextFeild Delegate
extension WalletHistoryVC:UITextFieldDelegate
{
    func textFieldShouldClear(_ textField: UITextField) -> Bool
    {
        return true;
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool
    {
        self.selectedTextFeildTag = textField.tag
        
        switch self.selectedTextFeildTag {
        case 0:
            page = 1
            datePicker.minimumDate = nil
            txtEndDate.text = ""
            break
        case 1:
            if txtStartDate.text == ""
            {
                self.showAlertMessage(titleStr: kAppName, messageStr: "Select start date")
                return false
                
            }else{
                self.endDateValidation(date:txtStartDate.text ?? "")
            }
            break
            
        default:
            break
        }
        
        return true;
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        self.selectedTextFeildTag = textField.tag
        
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

extension WalletHistoryVC : UIScrollViewDelegate{
    //Pagination
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        if scrollView == tableView{
            if ((tableView.contentOffset.y + tableView.frame.size.height) >= tableView.contentSize.height)
            {
                if isFetching == true
                {
                    isScroll = true
                    isFetching = false
                    self.page = self.page+1
                    walletHistory(toDate: txtStartDate.text ?? "", fromDate: txtEndDate.text ?? "", page: "\(self.page)")
                }
                else{
                    isScroll = false
                }
            }
        }
    }
}

extension WalletHistoryVC:transferDelegate{
    func transferAction() {
        isScroll = false
        page = 1
        self.walletList.removeAll()
         walletHistory(toDate: txtStartDate.text ?? "", fromDate: txtEndDate.text ?? "", page: "\(self.page)")
    }
    
    
}
