// The MIT License (MIT)
//
// Copyright (c) 2017 Alexander Grebenyuk (github.com/kean).

import Foundation
import RxSwift

// MARK: Defining Endpoints

enum API {}

extension API {
    static func getPicklist(v: Int) -> Endpoint<Customer> {
        return Endpoint(path: "picklist", parameters: ["v": v])
    }
    
    static func uploadAvatar(avatar: Data) -> Endpoint<UploadResult> {
        return Endpoint(path: "avatar", parameters: ["avatar": avatar])
    }
}

struct Customer: Decodable {
    var data: [Persion] = []
    var select: Int
}

struct Persion: Decodable {
    var id: Int
    var name: String
    var picknum: String
}

struct UploadResult: Decodable {
    var avatar_md5: String
}

// MARK: Using Endpoints

let client = Client(accessToken: "")

