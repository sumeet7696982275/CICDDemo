// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let homeJobModel = try? newJSONDecoder().decode(HomeJobModel.self, from: jsonData)

import Foundation

// MARK: - HomeJobModel
struct HomeJobModel: Codable {
    let body: BodyModel?//[Body1]?
    let code: Int?
    let message: String?
}

// MARK: - Body
struct BodyModel: Codable {
    let orders: [Body1]?
    let verified: Int?
    let verificationReason: String?
    let penalityAfterAcceptance: String?
    let jobInProgress: Bool?
}
// MARK: - Body
struct Body1: Codable {
    let address: Address?
    let addressID: String?
    let assignedEmployees: [AssignedEmployee]?
    let cancellationReason, LPointsPrice: String?
    let company: CompanyAddress?
    let companyID, createdAt, currency, id: String?
    let offerPrice: String?
    let orderNo, orderPrice,penalityAfterAcceptance: String?
    let progressStatus : Int?
    let cancellable : Bool?
    let promoCode: String?
    let serviceCharges: String?
    let paymentType:Int?
    let serviceDateTime,deliveryType: String?
    let suborders: [Suborder]?
    let totalOrderPrice : String?
    let trackStatus,priority  : Int?
    let trackingLatitude, trackingLongitude, updatedAt: String?
    let user: User1?
    let userID: String?
    let jobInProgress :Bool?
    let orderStatus : OrderStatus?
//    let company : [company]?

    
}

// MARK: - Address
struct Address: Codable {
    let addressName, addressType, city, houseNo: String?
    let id, landmark, latitude, longitude: String?
    let town: String?
}
// MARK: - company
struct company: Codable {
    let address1, companyName, id: String?
    let logo1, rating: String?
    let latitude, longitude: Double
}

// MARK: - AssignedEmployee
struct AssignedEmployee: Codable {
    let id: String?
    let jobStatus: Int?
}

// MARK: - CompanyAddress
struct CompanyAddress: Codable {
    let address1, address2, companyName: String?
    let logo1, logo2: String?
    let latitude,longitude:RelaxedString?
}

// MARK: - Suborder
struct Suborder: Codable {
    let id: String?
    let quantity: String?
    let service: Service?
    let serviceID: String?

   
}

// MARK: - Service
struct Service: Codable {
    let serviceDescription, duration: String?
    let icon: String?
    let id, name: String?
    let price: Double?
    let thumbnail: String?
    let type: String?

}

// MARK: - User
struct User1: Codable {
    let countryCode, firstName, id: String?
    let image: String?
    let lastName: String?
    let phoneNumber: String?
}
// MARK: - ChangeStatus
struct ChangeStatusModel: Codable {
    let code: Int?
    let message: String?
    let body: [StatusBody]?
}

// MARK: - Body
struct StatusBody: Codable {
    let id, statusName, companyID: String?
    let status: Int?
    let parentStatus: String?
    let createdAt, updatedAt: String?

}
// MARK: - CancelOrderModel
struct CancelOrderModel: Codable {
    let code: Int?
    let message: String?
}


//MARK:- GeofenceArea
struct CoordinatesObject {
    let latitude: Double?
    let longitude: Double?
    
    init(latitude : Double,longitude:Double) {
        self.latitude = latitude
        self.longitude = longitude
    }
  
}



//struct RelaxedString: Codable {
//    let value: String
//
//    init(_ value: String) {
//        self.value = value
//    }
//
//    init(from decoder: Decoder) throws {
//        let container = try decoder.singleValueContainer()
//        // attempt to decode from all JSON primitives
//        if let str = try? container.decode(String.self) {
//            value = str
//        } else if let int = try? container.decode(Int.self) {
//            value = int.description
//        } else if let double = try? container.decode(Double.self) {
//            value = double.description
//        } else if let bool = try? container.decode(Bool.self) {
//            value = bool.description
//        } else {
//            throw DecodingError.typeMismatch(String.self, .init(codingPath: decoder.codingPath, debugDescription: ""))
//        }
//    }
//
//    func encode(to encoder: Encoder) throws {
//        var container = encoder.singleValueContainer()
//        try container.encode(value)
//    }
//}
