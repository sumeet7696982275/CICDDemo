//
//  FeedbackModel.swift
//  DriverDeliveryApp
//
//  Created by Navaldeep Kaur on 04/05/20.
//  Copyright © 2020 Navaldeep Kaur. All rights reserved.
//

import Foundation

// MARK: - FeedbackModel
struct FeedbackModel: Codable {
        let code: Int?
        let message: String?
        let body: Body12?
    }

    // MARK: - Body
    struct Body12: Codable {
        let ratings: [Rating]?
        let avgRating: Double?
       // let avgRating: String?
        let totalOrders: Int?
        let totalRating: Int?
    }

    // MARK: - Rating
    struct Rating: Codable {
      //  let id, rating, review, ratingOn: String?
       // let order: Order?
        
        let id, rating, review, createdAt: String?
        let orderID: String?
        let order: Order?
        let user: User?

        enum CodingKeys: String, CodingKey {
            case id, rating, review, createdAt
            case orderID = "orderId"
            case order, user
        }
    }

    // MARK: - Order
    struct Order: Codable {
       // let id, serviceDateTime: String?
       // let user: User?
        let orderNo, id, serviceDateTime: String?
    }

    // MARK: - User
    struct User: Codable {
        let image: String?
        let id, firstName, lastName: String?
    }
