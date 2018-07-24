//
//  ViewReactor.swift
//  ABTest
//
//  Created by ripple_k on 2018/7/19.
//  Copyright © 2018 SoapVideo. All rights reserved.
//

import ReactorKit
import RxSwift
import RxCocoa

final class ViewReactor: Reactor {
    enum Action {
        case refresh
    }
    
    enum Mutation {
        case setRefreshing(Bool)
        case setLoading(Bool)
        case setStars([Persion])
    }
    
    struct State {
        var isRefreshing: Bool = false
        var isLoading: Bool = false
        var sections: [ViewSection] = []
    }
    
    let client: Client
    let disposeBag = DisposeBag()
    let initialState: State
    
    init(client: Client) {
        self.initialState = State()
        self.client = client
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .refresh:
            guard !self.currentState.isRefreshing else { return .empty() }
            guard !self.currentState.isLoading else { return .empty() }
            let startRefreshing = Observable<Mutation>.just(.setRefreshing(true))
            let endRefreshing = Observable<Mutation>.just(.setRefreshing(false))
            let setStars = client
                            .request(API.getPicklist(v: 120))
                            .asObservable()
                            .map { (list) -> Mutation in
                                return .setStars(list.data)
                            }
            return .concat([startRefreshing, setStars, endRefreshing])
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case .setStars(let stars):
            let sectionItems = stars
                            .map(CellReactor.init)
                            .map(ViewSectionItem.stars)
            state.sections = [.stars(sectionItems)]
            return state
            
        case .setRefreshing(let isRefreshing):
            state.isRefreshing = isRefreshing
            return state
            
        case .setLoading(let isLoading):
            state.isLoading = isLoading
            return state
        }
    }
}
