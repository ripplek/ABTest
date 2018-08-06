//
//  Moya+Rx.swift
//  ABTest
//
//  Created by ripple_k on 2018/8/2.
//  Copyright © 2018 SoapVideo. All rights reserved.
//

import Moya
import RxSwift

extension PrimitiveSequence where TraitType == SingleTrait, Element == Moya.Response {
    func map<T: ModelType>(_ type: T.Type) -> PrimitiveSequence<TraitType, T> {
        return self.map(T.self, using: T.decoder)
    }
    
    func map<T: ModelType>(_ listType: List<T>.Type) -> PrimitiveSequence<TraitType, List<T>> {
        return self
            .map { response -> List<T> in
                let items = try response.map([T].self, using: T.decoder)
                let nextURL = response.response?
                    .findLink(relation: "next")
                    .flatMap { URL(string: $0.uri) }
                return List<T>(items: items, nextURL: nextURL)
            }
            .do(onError: { error in
                if case let MoyaError.objectMapping(decodingError, _) = error {
                    log.error(decodingError)
                }
            })
    }
}
