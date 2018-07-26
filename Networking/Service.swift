//
//  Service.swift
//  ABTest
//
//  Created by ripple_k on 2018/7/25.
//  Copyright © 2018 SoapVideo. All rights reserved.
//

import RxSwift
import Moya

protocol ServiceType {
    func getPicklist(v: Int) -> Single<Customer>
    func getFeedList(page: Int) -> Single<Res<Feeds>>
}

final class Service: ServiceType {
    private let networking: ABTestNetworking
    
    init(networking: ABTestNetworking) {
        self.networking = networking
    }
    
    func getPicklist(v: Int) -> Single<Customer> {
        return self.networking.request(.getPicklist(v: v)).map(Customer.self)
    }
    
    func getFeedList(page: Int) -> Single<Res<Feeds>> {
        return self.networking.request(.getFeedList(feedPage: page)).map(Res<Feeds>.self)
    }
}
