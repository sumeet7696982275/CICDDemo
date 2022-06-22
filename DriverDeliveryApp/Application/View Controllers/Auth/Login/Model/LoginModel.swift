//
//  LoginModel.swift
//  DriverDeliveryApp
//
//  Created by Navaldeep Kaur on 30/04/20.
//  Copyright © 2020 Navaldeep Kaur. All rights reserved.
//

import Foundation
import ObjectMapper

// MARK: - SignIn_ResponseModel
   struct SignIn_ResponseModel: Decodable {
       let code: Int?
       let message: String?
       let body: data1?
   }
// MARK: - Body
       struct data1: Decodable {
           let image: String?
           let assignedServices: [String]?
           let id, companyId, firstName, lastName: String?
           let email, phoneNumber, countryCode, password: String?
           let dob, address, deviceToken, sessionToken: String?
           let platform: String?
           let status, createdAt, updatedAt: Int?
        
      
       }
