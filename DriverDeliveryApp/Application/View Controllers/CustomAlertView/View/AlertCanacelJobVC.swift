//
//  AlertCanacelJobVC.swift
//  DriverDeliveryApp
//
//  Created by Navaldeep Kaur on 02/05/20.
//  Copyright © 2020 Navaldeep Kaur. All rights reserved.
//

import UIKit

protocol AlertCanacelDelegate {
    func selectedComment(id:String?,otherResason:String?)
    func otherSelected(index:Int?,message:String?)
}
class AlertCanacelJobVC: UIViewController {
    
    //MARK:- Outlet and Variables 
    @IBOutlet weak var labNorecord: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var viewTop: UIView!
    @IBOutlet weak var lblCancellationCharges: UILabel!
    @IBOutlet weak var btnCancelOrderCharges: UIButton!
    @IBOutlet weak var lblCancellationDesc: UILabel!
    
    @IBOutlet var CancellationDetailView: UIVisualEffectView!
    var arrList = [CancelListData]()
    var cancelList : CancelListData?
    
    var viewDelegate : AlertCanacelDelegate?
    var isOtherSelected = false
    var viewModel : CancelAlertViewModel?
    
    var cancellationPenalty = ""
    var cancellationPenaltyDesc = ""
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        let str = "Cancel order with penalty of \(AppDefaults.shared.currency)\(cancellationPenalty)"
        self.btnCancelOrderCharges.setTitle(str, for: .normal)
        self.lblCancellationDesc.text = "The order is accepted by you! A fine will be charged for canceling the order. The cancellation charges will be adjusted in your wallet"
        self.lblCancellationCharges.text = "\(AppDefaults.shared.currency)\(cancellationPenalty) for the cancellation"
        
        
        if(cancellationPenalty == "0" || cancellationPenalty == "")
        {
            self.CancellationDetailView.isHidden = true
        }
        else
        {
            self.CancellationDetailView.isHidden = false
        }
        
        setView()
        
    }
    
    @IBAction func btnCrossAction(_ sender: Any)
    {
     self.dismiss(animated: true, completion: nil)
        
    }
    //MARK:- Other functions
    func setView(){
        
        self.viewModel = CancelAlertViewModel.init(Delegate: self, view: self)
        self.viewModel?.cancelReasonListApi(completion: { (response) in
            print(response)
            if let data = response.body{
                print(data)
                if data.count > 0{
                    // self.arrList = data
                    for list in data{
                        self.cancelList = CancelListData.init(id: list.id ?? "", reason: list.reason ?? "", isCellSelected: false)
                        self.arrList.append(self.cancelList!)
                    }
                    self.arrList.insert(CancelListData.init(id:"0", reason: "Other", isCellSelected: false), at: self.arrList.count)
                    print(self.arrList)
                    self.tableView.reloadData()
                }
                else{
                    
                }
            }
        })
        
        viewTop.backgroundColor = Appcolor.kThemeColor
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .singleLine
        tableView.tableFooterView = UIView()
    }
    
    
    @IBAction func cencelViewActionOk(_ sender: Any)
    {
        self.CancellationDetailView.isHidden = true
    }
    @IBAction func cancelViewActionBack(_ sender: Any)
    {
        self.dismiss(animated: true, completion: nil)
    }
    
}

//MARK:- TableViewDelegateAndDataSource

extension AlertCanacelJobVC : UITableViewDelegate, UITableViewDataSource
{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return arrList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AlertCancelCell")as! AlertCancelCell
        cell.lblTitle.text = arrList[indexPath.row].reason
        cell.btnSubmit.tag = indexPath.row
        cell.btnRadio.tag = indexPath.row
        cell.viewDelegate = self
        if isOtherSelected == true && cell.lblTitle.text == "Other"{
            cell.ktextViewHeight.constant = 140
            cell.kButtonHight.constant = 48
            cell.btnSubmit.isHidden = false
        }
        else{
            cell.ktextViewHeight.constant = 0
            cell.kButtonHight.constant = 0
            cell.btnSubmit.isHidden = true
        }
        if arrList[indexPath.row].isCellSelected == true{
           cell.btnRadio.isSelected = true
        }else{
         cell.btnRadio.isSelected = false
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
        let cell = tableView.cellForRow(at: indexPath) as! AlertCancelCell
        var index = 0
        for isSeleceted in arrList
        {
           arrList[index].isCellSelected = false
            index = index + 1
        }
        arrList[indexPath.row].isCellSelected = true
      //  cell.btnRadio.isSelected = true
        cell.btnSubmit.backgroundColor = Appcolor.kOrangeThemeColor
        cell.btnSubmit.setTitleColor(Appcolor.kTextColorWhite, for: .normal)
        
        if cell.lblTitle.text == "Other"
        {
            isOtherSelected = true
            tableView.reloadData()
        }
        else
        {
            cell.ktextViewHeight.constant = 0
            cell.kButtonHight.constant = 0
            cell.btnSubmit.isHidden = true
            isOtherSelected = false
            tableView.reloadData()
            self.AlertMessageWithOkCancelAction(titleStr: kAppName, messageStr: "Are you sure you want to cancel this job?", Target: self) { (alert) in
                if alert == "Yes"
                {
                    self.viewDelegate?.selectedComment(id: self.arrList[indexPath.row].id ?? "", otherResason: "")
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
        
        tableView.deselectRow(at: indexPath, animated: false)
        
    }
    
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath)
    {
        let cell = tableView.cellForRow(at: indexPath) as! AlertCancelCell
        cell.btnRadio.isSelected = false
    }
}

extension AlertCanacelJobVC:AlertCanacelDelegate
{
    func selectedComment(id: String?, otherResason: String?) {
        
    }
    
    func otherSelected(index: Int?, message: String?) {
        if message == "Enter here..." || message == ""
        {
            self.showAlertMessage(titleStr: kAppName, messageStr:"Please enter cancellation reason.")
        }
        else{
            
            self.AlertMessageWithOkCancelAction(titleStr: kAppName, messageStr: "Are you sure you want to cancel this job?", Target: self) { (alert) in
                if alert == "Yes"
                {
                    self.viewDelegate?.selectedComment(id:  self.arrList[index ?? 0].id ?? "",otherResason:message)
                    self.dismiss(animated: true, completion: nil)
                }}
        }
    }
    
}

//MARK:- View Delegate

extension AlertCanacelJobVC: CancelAlertDelegate{
    func Show(msg: String) {
        
    }
    
    func didError(error: String) {
        showAlertMessage(titleStr: kAppName, messageStr: error)
    }
    
    
}
