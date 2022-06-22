//
//  PolygonRegionModel.swift
//  DriverDeliveryApp
//
//  Created by Navaldeep Kaur on 02/07/21.
//  Copyright © 2021 Navaldeep Kaur. All rights reserved.
//

import Foundation

// MARK: - Welcome
struct PolygonRegionModel: Codable {
    let code: Int?
    let message: String?
    let body: PolygonRegionBody?
}

// MARK: - Body
struct PolygonRegionBody: Codable {
    let id: String?
    let polygon: [[Polygon]]?
}

// MARK: - Polygon
struct Polygon: Codable {
    let lat, long: Double?
}
