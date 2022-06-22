//
//  JobHistoryVC.swift
//  DriverDeliveryApp
//
//  Created by Navaldeep Kaur on 04/05/20.
//  Copyright © 2020 Navaldeep Kaur. All rights reserved.
//

import UIKit
protocol JobHistory_Delegate:class {
    func jobDetail(index:Int?)
}

class JobHistoryVC: CustomController {
    //MARK:- Outlet and Variables
    @IBOutlet weak var lblNoRecord: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btnMenuBar: UIBarButtonItem!
    
    var viewModel:JobHistoryViewModel?
    var jobList = [Body1]()
    var page = 1
    var isFetching:Bool = false
    var isScroll = false
    var jobStatus = "3"
    //MARK:- LifeCycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        
        // Do any additional setup after loading the view.
    }
    //MARK:- Othere funtions
    func setUI()
    {
        self.viewModel = JobHistoryViewModel.init(Delegate: self, view: self)
        btnMenuBar.target = self.revealViewController()
        btnMenuBar.action = #selector(SWRevealViewController.revealToggle(_:))
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        self.setTapGestureOnSWRevealontroller(view: self.view, controller: self)
        
        //TableView
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
        JobList(status:"", page: page)
    }
    
    //MARK:- HitApis
    func JobList(status:String?,page:Int?){
        self.viewModel?.getJobListApi(status: status, page: page, jobStatus: jobStatus, completion: { (response) in
            print(response)
            if let data = response.body?.orders{
                if (data.count > 0){
                    self.jobList = data
                    self.tableView.reloadData()
                    self.tableView.isHidden = false
                    self.lblNoRecord.isHidden = true
                    self.isFetching = true
                }
                else{
                    self.isFetching = false
                    if self.isScroll == true{
                        
                    }
                    else{
                        self.tableView.isHidden = true
                        self.lblNoRecord.isHidden = false
                        
                    }
                }
            }
            else{
                self.isFetching = false
                if self.isScroll == true{
                    
                }
                else{
                    self.tableView.isHidden = true
                    self.lblNoRecord.isHidden = false
                    
                }
            }
        })
    }
    
}

//MARK:- TableViewDelegateAndDataSource

extension JobHistoryVC : UITableViewDelegate, UITableViewDataSource
{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return jobList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "JobHistoryCell")as! JobHistoryCell
        cell.viewDelegate = self
        cell.btnDetail.tag = indexPath.row
        cell.setData(data:jobList[indexPath.row])
        cell.setUI()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    
}

//MARK:- ViewModelDelegate
extension JobHistoryVC:JobHistoryDelegate{
    func Show(msg: String) {
        
    }
    
    func didError(error: String) {
        if isScroll == true{
        }
        else{
            showAlertMessage(titleStr: kAppName, messageStr: error)
        }
    }
}

//MARK:- ViewDelegate

extension JobHistoryVC : JobHistory_Delegate
{
    func jobDetail(index: Int?) {
        let controller = Navigation.GetInstance(of: .OrderDetailVC) as! OrderDetailVC
        controller.orderId = jobList[index ?? 0].id ?? ""
        controller.isFromFeedBack = true
        self.push_To_Controller(from_controller: self, to_Controller: controller)
    }
    
}

extension JobHistoryVC : UIScrollViewDelegate{
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
                    JobList(status: "", page: self.page)
                }
                else{
                    isScroll = false
                }
            }
        }
    }
}
