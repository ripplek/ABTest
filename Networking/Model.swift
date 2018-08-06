//
//  Model.swift
//  ABTest
//
//  Created by ripple_k on 2018/7/25.
//  Copyright © 2018 SoapVideo. All rights reserved.
//

import Foundation

struct Res<T: Codable>: Codable {
    typealias Data = T
    
    var code: Int
    var msg: String
    var data: Data
}

struct Feeds: Codable {
    var feeds: [Feed]?
}

struct Feed: ModelType {
    enum Event {
        
    }
    
    var fid: String
    var author: String
    var title: String
    var url: String
    var platform: String
    var postdate: String
}

struct Customer: Codable {
    var data: [Persion]
    var select: Int
}

struct Persion: Codable {
    var name: String
    var picknum: String
    var id: Int
}
