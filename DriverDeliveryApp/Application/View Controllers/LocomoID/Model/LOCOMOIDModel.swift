//
//  LOCOMOIDModel.swift
//  DriverApp
//
//  Created by Poonam  on 18/11/20.
//  Copyright © 2020 Seasia. All rights reserved.
//

import Foundation
// MARK: - PaymentModel
struct LOCOMOIDModel: Codable {
    let code: Int?
    let message: String?
    let body: BodyID?
}

// MARK: - Body
struct BodyID: Codable {
    let employeeId, userName, address, phoneNumber, image: String?
    let compNo, compEmail, compIdUrl,compLogo: String?

}
