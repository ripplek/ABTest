//
//  AuthPlugin.swift
//  ABTest
//
//  Created by ripple_k on 2018/7/25.
//  Copyright © 2018 SoapVideo. All rights reserved.
//

import Moya
import RxSwift

protocol AuthServiceType {
    var currentAccessToken: AccessToken? { get }
    
    /// Start OAuth authorization process.
    ///
    /// - returns: An Observable of `AccessToken` instance.
    func authorize() -> Observable<Void>
    
    /// Call this method when redirected from OAuth process to request access token.
    ///
    /// - parameter code: `code` from redirected url.
    func callback(code: String)
    
    func logout()
}

struct AuthPlugin: PluginType {
    fileprivate let authService: AuthServiceType
    
    init(authService: AuthServiceType) {
        self.authService = authService
    }
    
    func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
        var request = request
        if let accessToken = self.authService.currentAccessToken?.accessToken {
            request.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        }
        return request
    }
}

