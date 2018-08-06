//
//  ModelType.swift
//  ABTest
//
//  Created by ripple_k on 2018/8/2.
//  Copyright © 2018 SoapVideo. All rights reserved.
//

import Foundation

protocol ModelType: Codable, Then {
    associatedtype Event
    
    static var dateDecodingStrategy: JSONDecoder.DateDecodingStrategy { get }
}

extension ModelType {
    static var dateDecodingStrategy: JSONDecoder.DateDecodingStrategy {
        return .iso8601
    }
    
    static var decoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = self.dateDecodingStrategy
        return decoder
    }
}
