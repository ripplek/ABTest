//
//  CellReactor.swift
//  ABTest
//
//  Created by ripple_k on 2018/7/20.
//  Copyright © 2018 SoapVideo. All rights reserved.
//

import ReactorKit
import RxCocoa
import RxSwift

final class CellReactor: Reactor {
    typealias Action = NoAction
    struct State {
        var text: String?
        var detailText: String?
    }
    
    let star: Persion
    let initialState: State
    
    init(star: Persion) {
        self.star = star
        self.initialState = State(text: star.name, detailText: star.picknum)
        _ = self.state
    }
}
