//
//  OrderDetailModel.swift
//  DriverDeliveryApp
//
//  Created by Navaldeep Kaur on 05/05/20.
//  Copyright © 2020 Navaldeep Kaur. All rights reserved.
//

import Foundation



// MARK: - Welcome
struct OrderDetailModel: Codable {
    let code: Int?
    let message: String?
    let body: Body13?
}

// MARK: - Body
struct Body13: Codable {
    let orderNo, id, serviceDateTime, orderPrice: String?
    let promoCode, offerPrice, serviceCharges, usedLPoints: String?
    let lPointsPrice, deliveryType, totalOrderPrice, addressID: String?
    let companyId, userId,walletBalanceUsed: String?
    let progressStatus, trackStatus,paymentType,priority: Int?
    //let trackingLatitude, trackingLongitude: JSONNull?
    let cancellationReason, pickupInstructions, cookingInstructions: String?
    let tip, createdAt, updatedAt: String?
    let address: Address1?
    let user: User2?
    let orderStatus : OrderStatus?
    let company: Company1?
    let suborders: [Suborder]?
    let assignedEmployees: [AssignedEmployee1]?
    let currency: String?
    let deliveryInstructions: [String]?
    let delay : String?
}
struct OrderStatus : Codable{
    let status : Int?
    let statusName:String?
}
// MARK: - Address
struct Address1: Codable {
    let id, addressName, addressType, houseNo: String?
    let latitude, longitude, town, landmark: String?
    let city: String?
}

// MARK: - AssignedEmployee
struct AssignedEmployee1: Codable {
    let id: String?
    let jobStatus: Int?
    let employee: User2?
}

// MARK: - User
struct User2: Codable {
    let image: String?
    let id, firstName, lastName, countryCode: String?
    let phoneNumber: String?
}

// MARK: - Company
struct Company1: Codable {
    let logo1: String?
    let id, companyName, address1: String?
    let latitude, longitude: Double?
    let rating: String?
}

//// MARK: - Suborder
//struct Suborder: Codable {
//    let id, serviceID, quantity: String
//    let service: Service
//
//}
//
//// MARK: - Service
//struct Service: Codable {
//    let icon, thumbnail: String
//    let id, name, serviceDescription: String
//    let price: Int
//    let type, duration, rating: String
//
//}
