//
//  EditProfile_Model.swift
//  Fleet Management
//
//  Created by Mohit Sharma on 2/26/20.
//  Copyright © 2020 Seasia Infotech. All rights reserved.
//

import Foundation

   // MARK: - EditProfile_ResponseModel
    struct EditProfile_ResponseModel: Codable {
        let code: Int?
        let message: String?
        let body: Body?
    }

    // MARK: - Body
    struct Body: Codable {
        let image: String?
        let assignedServices: [String]?
        let id, companyId, firstName, lastName: String?
        let email, phoneNumber, countryCode, password: String?
        let dob, address, deviceToken, sessionToken: String?
        let platform: String?
        let status, createdAt, updatedAt: Int?
        let idProof,licenseBack,licenseFront :String?
        let idProofName : String?
        let coverImage :String?

    }
