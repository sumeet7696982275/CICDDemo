//
//  MyEarningsVC.swift
//  DriverDeliveryApp
//
//  Created by Mohit's MAC on 31/05/21.
//  Copyright © 2021 Navaldeep Kaur. All rights reserved.
//

import Foundation

// MARK: - Welcome
struct EarningModel: Codable
{
    let code: Int?
    let message: String?
    let body: EarningsBody?
}

// MARK: - Body
struct EarningsBody: Codable
{
    let earnings: [Earning]?
   // let targets: [Target]?
}

// MARK: - Earning
struct Earning: Codable {
    let id: String?
        let amount: Double?
        let paidType: String?
        let wagesType: Int?
        let charges, extraEarnings, orderAmount, totalOrders,description: String?
        let orderID, empID, companyID, createdAt: String?
        let updatedAt: String?
        let order: OrderDec?

        enum CodingKeys: String, CodingKey {
            case id, amount, paidType, wagesType, charges, extraEarnings, orderAmount, totalOrders,description
            case orderID = "orderId"
            case empID = "empId"
            case companyID = "companyId"
            case createdAt, updatedAt, order
        }
}

// MARK: - Order
struct OrderDec: Codable
{
    let orderNo, id: String
}

// MARK: - Target
struct Target: Codable {
    let id: String
    let amount: Int
    let paidType: String
    let earningScenario: Int
    let totalOrderCount, totalOrderSum, targetOrder, orderExtra: String
    let targetDistance, distanceExtra: String
    let orderTargetAchieved, distanceTargetAchieved: Int
    let empID, companyID, createdAt, updatedAt: String

    enum CodingKeys: String, CodingKey {
        case id, amount, paidType, earningScenario, totalOrderCount, totalOrderSum, targetOrder, orderExtra, targetDistance, distanceExtra, orderTargetAchieved, distanceTargetAchieved
        case empID = "empId"
        case companyID = "companyId"
        case createdAt, updatedAt
    }
}
