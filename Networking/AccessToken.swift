//
//  Token.swift
//  ABTest
//
//  Created by ripple_k on 2018/7/25.
//  Copyright © 2018 SoapVideo. All rights reserved.
//

import Foundation

struct AccessToken: Codable {
    let refreshToken: String
    let expiresIn: TimeInterval
    let accessToken: String
    
    var isValid: Bool {
        if self.accessToken.count > 0,
            self.refreshToken.count > 0,
            Date.timeIntervalSinceReferenceDate < expiresIn {
            return true
        }
        return false
    }
    
    enum CodingKeys: String, CodingKey {
        case refreshToken = "refresh_token"
        case expiresIn = "expires_in"
        case accessToken = "access_token"
    }
}
