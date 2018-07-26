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
    
    let feed: Feed
    let initialState: State
    
    init(feed: Feed) {
        self.feed = feed
        self.initialState = State(text: feed.title, detailText: feed.author)
        _ = self.state
    }
}
