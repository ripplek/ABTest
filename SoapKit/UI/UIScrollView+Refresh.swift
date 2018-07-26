//
//  UIScrollView+Refresh.swift
//  ABTest
//
//  Created by ripple_k on 2018/7/23.
//  Copyright © 2018 SoapVideo. All rights reserved.
//

import UIKit

import RxSwift
import RxCocoa
import MJRefresh

enum LoadingStatus {
    case endRefresh
    case noMoreData
    case dataReset
}

class RxTarget: NSObject, Disposable {  // RxTarget 是 Rxswift 源码
    private var retainSelf: RxTarget?
    override init() {
        super.init()
        self.retainSelf = self
    }
    func dispose() {
        self.retainSelf = nil
    }
}

final class RefreshTarget<Component:MJRefreshComponent>: RxTarget {
    typealias Callback = MJRefreshComponentRefreshingBlock
    var callback: Callback?
    weak var component:Component?
    
    let selector = #selector(RefreshTarget.eventHandler)
    
    init(_ component: Component,callback:@escaping Callback) {
        self.callback = callback
        self.component = component
        super.init()
        component.setRefreshingTarget(self, refreshingAction: selector)
    }
    @objc func eventHandler() {
        if let callback = self.callback {
            callback()
        }
    }
    override func dispose() {
        super.dispose()
        self.component?.refreshingBlock = nil
        self.callback = nil
    }
}

extension Reactive where Base: MJRefreshComponent {
    var event: ControlEvent<Base> {
        let source: Observable<Base> = Observable.create { [weak control = self.base] observer  in
            MainScheduler.ensureExecutingOnScheduler()
            guard let control = control else {
                observer.on(.completed)
                return Disposables.create()
            }
            let observer = RefreshTarget(control) {
                observer.on(.next(control))
            }
            return observer
            }.takeUntil(deallocated)
        return ControlEvent(events: source)
    }
}

extension MJRefreshHeader {
    var endRefresh: Binder<Bool> {
        return Binder.init(self, binding: { (refresher, isRefreshing) in
            if !isRefreshing {
                refresher.endRefreshing()
            }
        })
    }
}

extension MJRefreshFooter {
    var loadMoreStatus: Binder<LoadingStatus> {
        return Binder.init(self, binding: { (refresher, status) in
            log.info(status)
            switch status {
            case .dataReset:
                refresher.resetNoMoreData()
                
            case .endRefresh:
                refresher.endRefreshing()
                
            case .noMoreData:
                refresher.endRefreshingWithNoMoreData()
            }
        })
    }
}

