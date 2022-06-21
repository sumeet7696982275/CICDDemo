//
//  ChargesModel.swift
//  DriverDeliveryApp
//
//  Created by Mohit's MAC on 28/05/21.
//  Copyright © 2021 Navaldeep Kaur. All rights reserved.
//

import Foundation

// MARK: - Welcome
struct chargesModel: Codable
{
    let code: Int?
    let message: String?
    let body: chargesBody?
}

// MARK: - Body
struct chargesBody: Codable
{
    let id, penalityAfterAcceptance, earningScenario, earningOrderTarget: String?
        let earningdistanceTarget, earningOnOrder, earningOnDistance, securityCOD: String?
        let companyID, createdAt, updatedAt: String?
        let currentPlan: CurrentPlan?

        enum CodingKeys: String, CodingKey {
            case id, penalityAfterAcceptance, earningScenario, earningOrderTarget, earningdistanceTarget, earningOnOrder, earningOnDistance, securityCOD
            case companyID = "companyId"
            case createdAt, updatedAt, currentPlan
        }
}

// MARK: - CurrentPlan
struct CurrentPlan: Codable {
    let id, wagesType, installments, commissionPercentage: String?
    let wagesAmount, empID, companyID, createdAt: String?
    let updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id, wagesType, installments, commissionPercentage, wagesAmount
        case empID = "empId"
        case companyID = "companyId"
        case createdAt, updatedAt
    }
}
