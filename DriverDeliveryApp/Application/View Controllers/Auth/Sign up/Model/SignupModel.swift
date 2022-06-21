 //
//  SignupModel.swift
//  CourierApp
//
//  Created by Mohit Sharma on 9/29/20.
//  Copyright © 2020 Cerebrum Infotech. All rights reserved.
//

import Foundation


// MARK: - Welcome
struct SignupModel: Codable
{
    let code: Int
    let message: String
    let body: SignupBody
}

// MARK: - Body
struct SignupBody: Codable
{
    let email, firstName, lastName, image: String?
    let sessionToken, refreshToken,referralCode, id,termsLink,privacyLink,aboutUsLink: String?
    let licenseBack,licenseFront,experience,cover: String?
}
