//
//  NotificationModel.swift
//  DriverDeliveryApp
//
//  Created by Navaldeep Kaur on 07/05/20.
//  Copyright © 2020 Navaldeep Kaur. All rights reserved.
//

import Foundation


// MARK: - NotificationModel
struct NotificationModel: Codable {
    let code: Int?
    let message: String?
    let body: [Body18]?
}

// MARK: - Body
struct Body18: Codable {
    let id, notificationTitle, notificationDescription, userID: String?
    let role, readStatus, status: Int?
    let createdAt, updatedAt: String?

}
