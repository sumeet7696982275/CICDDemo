//
//  MyEarningsVC.swift
//  DriverDeliveryApp
//
//  Created by Mohit's MAC on 24/05/21.
//  Copyright © 2021 Navaldeep Kaur. All rights reserved.
//

import UIKit

class MyEarningsVC: UIViewController
{
    
    @IBOutlet weak var earningViewHeight: NSLayoutConstraint!
    @IBOutlet weak var lblTotalEarnings: UILabel!
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var txtStartDate: UITextField!
    @IBOutlet weak var btnSbumit: CustomButton!
    @IBOutlet weak var txtEndDate: UITextField!
    var apiDATA: [Earning]?
    var selectedTextFeildTag : Int?
    let datePicker = UIDatePicker()
    let crrncy = AppDefaults.shared.currency
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.earningViewHeight.constant = 0
        self.tblView.separatorStyle = .none
        self.tblView.setEmptyMessage("Earnings not found!")
        setView()
    }
    
    //MARK:- Actions
    @IBAction func submitAction(_ sender: Any)
    {
        if txtStartDate.text == ""{
            AlertMessageWithOkAction(titleStr: kAppName, messageStr: "Enter start date", Target: self) {
            }
        }else if txtEndDate.text == ""{
            AlertMessageWithOkAction(titleStr: kAppName, messageStr: "Enter end date", Target: self) {
            }
        }else{
            self.getInfo(startDate: txtStartDate.text ?? "", endDate: txtEndDate.text ?? "")
        }
        
    }
    @IBAction func acnMoveback(_ sender: Any)
    {
        self.moveBACK(controller: self)
    }
    
    //MARK:- Other functions
    func setView(){
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-dd-yyyy"
        let now = Date()
        let dateString = formatter.string(from:now)
        if #available(iOS 13.4, *) {
            self.datePicker.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }
        txtStartDate.text = dateString
        txtEndDate.text = dateString
        self.set_statusBar_color(view: self.view)
        self.tblView.separatorStyle = .none
        txtStartDate.delegate = self
        txtEndDate.delegate = self
        showDatePicker()
        
       // self.getInfo(startDate: txtStartDate.text ?? "", endDate: txtEndDate.text ?? "")
        self.getInfo(startDate: "", endDate: "")
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
    
    func getInfo(startDate:String,endDate:String)
    {
        let url =  APIAddress.GET_EARNINGSINFO + startDate + "&endDate=" + endDate
        WebService.Shared.GetApi(url: url, Target: self, showLoader: true)
        { (result) in
            
            do
                   {
                    let jsonData = try JSONSerialization.data(withJSONObject: result, options: .prettyPrinted)
                    let data = try JSONDecoder().decode(EarningModel.self, from: jsonData)
                    self.apiDATA = data.body?.earnings
                    
                    
                 //   self.lblTotalEarnings.text = "Security Amount: \(crrncy)\(data.body?.securityCOD ?? "0")"
                    
                    if self.apiDATA?.count ?? 0 > 0
                    {
                        self.tblView.restore()
                        self.tblView.reloadData()
                      //  self.earningViewHeight.constant = 110
                    }
                    else
                    {
                        self.tblView.setEmptyMessage("Earnings not found!")
                        self.tblView.reloadData()
                        self.earningViewHeight.constant = 0
                    }
                    
                   }
            catch
            {
                self.tblView.setEmptyMessage("Earnings not found!")
                self.earningViewHeight.constant = 0
                self.showAlertMessage(titleStr: "Error", messageStr: error.localizedDescription)
            }
            
        } completionnilResponse: { (err) in
            self.tblView.setEmptyMessage("Earnings not found!")
            self.earningViewHeight.constant = 0
            self.showAlertMessage(titleStr: "Error", messageStr: err)
        }
        
    }
}

class MyEarningsCell: UITableViewCell
{
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblOrderNum: UILabel!
    @IBOutlet weak var ivVendor: UIImageView!
    @IBOutlet weak var lblAmount: UILabel!
    @IBOutlet weak var lblDate: UILabel!
}

extension MyEarningsVC:UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.apiDATA?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyEarningsCell", for: indexPath) as! MyEarningsCell
        
        let obj = self.apiDATA![indexPath.row]
        
        
        cell.lblOrderNum.text = "Order ID: \(obj.order?.orderNo ?? "N/A")"
        let date = obj.createdAt ?? ""
        let str = self.UTCtoLocal(dateToConvert:date)
        cell.lblDate.text = str
        
        cell.lblTitle.text = obj.description ?? "Earned"
        cell.lblAmount.textColor = .green
        cell.lblAmount.text = "+\(crrncy)\(obj.amount ?? 0)"
        
//        if(obj.paidType == "1")
//        {
//            cell.lblTitle.text = "Earned"
//            cell.lblAmount.textColor = .green
//            cell.lblAmount.text = "+\(crrncy)\(obj.amount ?? 0)"
//        }
//        else
//        {
//            cell.lblTitle.text = "Deducted"
//            cell.lblAmount.textColor = .red
//            cell.lblAmount.text = "-\(crrncy)\(obj.amount ?? 0)"
//        }
        
        cell.ivVendor.layer.cornerRadius = 35
        cell.ivVendor.layer.masksToBounds = true
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
       return 130
    }
}

//MARK:- TextFeild Delegate
extension MyEarningsVC:UITextFieldDelegate
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
    
    func UTCtoLocal(dateToConvert:String) -> String
    {
        // create dateFormatter with UTC time format
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
        let date = dateFormatter.date(from: dateToConvert)// create   date from string
        
        // change to a readable time format and change to local time zone
        dateFormatter.dateFormat = "EEE MMM d, yyyy h:mm a"
        dateFormatter.timeZone = NSTimeZone.local
        
        if (date != nil)
        {
            let timeStamp = dateFormatter.string(from: date!)
            return timeStamp
        }
        else
        {
            return "N/A"
        }
    }
}
