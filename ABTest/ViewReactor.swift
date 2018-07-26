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
        case loadMore
    }
    
    enum Mutation {
        case setRefreshing(Bool)
        case setLoading(Bool)
        case setStars([Feed])
        case appendStars([Feed])
    }
    
    struct State {
        var isRefreshing: Bool = false
        var isLoading: Bool = false
        var canLoadMore: LoadingStatus = .endRefresh
        var page: Int = 1
        var sections: [ViewSection] = []
    }
    
    let service: ServiceType
    let disposeBag = DisposeBag()
    let initialState: State
    
    init(service: ServiceType) {
        self.initialState = State()
        self.service = service
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .refresh:
            guard !self.currentState.isRefreshing else { return .empty() }
            guard !self.currentState.isLoading else { return .empty() }
            let startRefreshing = Observable<Mutation>.just(.setRefreshing(true))
            let endRefreshing = Observable<Mutation>.just(.setRefreshing(false))
            let setStars = service
                                .getFeedList(page: 1)
                                .asObservable()
                                .map { res -> Mutation in
                                    return .setStars(res.data.feeds ?? [])
                                }
            
            return .concat([startRefreshing, setStars, endRefreshing])
            
        case .loadMore:
            guard !self.currentState.isRefreshing else { return .empty() }
            guard !self.currentState.isLoading else { return .empty() }
            let startRefreshing = Observable<Mutation>.just(.setRefreshing(true))
            let endRefreshing = Observable<Mutation>.just(.setRefreshing(false))
            let appendStars = service
                                    .getFeedList(page: self.currentState.page).debug()
                                    .asObservable()
                                    .map { res -> Mutation in
                                        return .appendStars(res.data.feeds ?? [])
                                    }
            
            return .concat([startRefreshing, appendStars, endRefreshing])
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
            state.page = 2
            state.canLoadMore = .dataReset
            return state
            
        case .appendStars(let stars):
            guard stars.count > 0 else { state.canLoadMore = .noMoreData; return state }
            var newSectionItems = stars
                                .map(CellReactor.init)
                                .map(ViewSectionItem.stars)
            newSectionItems = state.sections[0].items + newSectionItems
            state.sections = [.stars(newSectionItems)]
            state.canLoadMore = .endRefresh
            state.page += 1
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
