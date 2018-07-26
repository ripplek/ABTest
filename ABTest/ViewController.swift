//
//  ViewController.swift
//  ABTest
//
//  Created by ripple_k on 2018/7/19.
//  Copyright © 2018 SoapVideo. All rights reserved.
//

import UIKit

import ReactorKit
import ReusableKit
import RxDataSources
import RxViewController
import MJRefresh

class ViewController: SoapViewController, View {
    
    // MARK: - Constants
    
    private struct Reusable {
        static let cell = ReusableCell<Cell>()
    }
    
    // MARK: - Properties
    
    private let dataSource = RxTableViewSectionedReloadDataSource<ViewSection>(configureCell: { (dataSource, tableView, indexPath, sectionItem) -> UITableViewCell in
        switch sectionItem {
        case .stars(let reactor):
            let cell = tableView.dequeue(Reusable.cell, for: indexPath)
            cell.reactor = reactor
            return cell
        }
    })
    
    // MARK: - UI
    
    let tableView = UITableView(
            frame: .zero,
            style: .grouped
        ).then {
            $0.register(Reusable.cell)
            $0.mj_header = MJRefreshGifHeader()
            $0.mj_footer = MJRefreshBackStateFooter()
        }
    
    // MARK: - Initializing
    
    init(reactor: ViewReactor) {
        defer { self.reactor = reactor }
        super.init()
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "View Controller"
        view.backgroundColor = .white
        tableView.soap
            .adhere(toSuperView: view)
            .soap
            .layout { (make) in
                make.edges.equalToSuperview()
            }
        
    }

    // MARK: - Configuring
    
    func bind(reactor: ViewReactor) {
        // Action
        self.rx.viewDidLoad
            .map { Reactor.Action.refresh }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        self.tableView.mj_header.rx.event
            .map { _ in Reactor.Action.refresh }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        self.tableView.mj_footer.rx.event
            .map { _ in Reactor.Action.loadMore }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // State
        
        reactor.state.map { $0.isRefreshing }
            .distinctUntilChanged()
            .bind(to: self.tableView.mj_header.endRefresh)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.canLoadMore }
            .bind(to: self.tableView.mj_footer.loadMoreStatus)
            .disposed(by: disposeBag)
        
        reactor.state.map{ $0.sections }
            .bind(to: self.tableView.rx.items(dataSource: self.dataSource))
            .disposed(by: disposeBag)
    }

}

