//
//  ABTestAPI.swift
//  ABTest
//
//  Created by ripple_k on 2018/7/25.
//  Copyright © 2018 SoapVideo. All rights reserved.
//

import Moya
import Foundation

enum ABTestAPI {
    case getPicklist(v: Int)
    case getFeedList(feedPage: Int)
}

extension ABTestAPI: TargetType {
    
    var baseURL: URL {
//        guard let url = URL(string: "https://startpick.feizaotai.com") else {
//            fatalError("baseURL could not be configured")
//        }
//        return url
        guard let url = URL(string: "https://app.kangzubin.com/iostips/api") else {
            fatalError("baseURL could not be configured")
        }
        return url
    }
    
    var path: String {
        switch self {
        case .getPicklist:
            return "picklist"
        case .getFeedList:
            return "feed/list"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getPicklist:
            return .get
        case .getFeedList:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case let .getPicklist(v):
//            return .requestJSONEncodable(["v": v])
            return .requestParameters(parameters: ["v": v], encoding: URLEncoding.default)
        case let .getFeedList(feedPage):
            return .requestParameters(parameters: ["page": feedPage], encoding: URLEncoding.default)
//            return .requestJSONEncodable(["page": feedPage])
            
        }
    }
    
    var headers: [String : String]? {
        return ["Content-Type": "application/json"]
//        return ["Accept": "application/json"]
//        return nil
    }
    
    var sampleData: Data {
        return Data()
    }
    
//    var validationType: ValidationType {
//        return .none
//    }
}
