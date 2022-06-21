//
//  CancelListModel.swift
//  DriverDeliveryApp
//
//  Created by Navaldeep Kaur on 04/05/20.
//  Copyright © 2020 Navaldeep Kaur. All rights reserved.
//

import Foundation


// MARK: - CancelListModel
struct CancelListModel: Codable {
    let code: Int?
    let message: String?
    let body: [Body11]?
}

// MARK: - Body
struct Body11: Codable {
    let id, reason: String?
    let status: Int?
    let companyID, createdAt: String?

}

// MARK: - CancelListModel
struct CancelList {
   
        let code: Int?
        let message: String?
        var body =  [CancelListData]()
    
        init(dict: [String:Any])
        {
         self.code = dict["code"] as? Int
         self.message = dict["message"] as? String
         if let arrjobList = dict["body"] as? [[String:Any]]{
             self.body.removeAll()
             _ = arrjobList.map({ (dict) in
                let model = CancelListData.init(id: dict["id"] as? String, reason: dict["reason"] as? String, isCellSelected: dict["isCellSelected"] as? Bool)
                 self.body.append(model)
             })
         }
         }
    
}

// MARK: - Body
struct CancelListData{
    let id, reason: String?
    var isCellSelected:Bool?
    init(id:String?,reason:String?,isCellSelected:Bool?)
    {
        self.id  = id
        self.reason = reason
        self.isCellSelected = isCellSelected
    }
}

