//
//  Cell.swift
//  ABTest
//
//  Created by ripple_k on 2018/7/20.
//  Copyright © 2018 SoapVideo. All rights reserved.
//

import UIKit

import ReactorKit

class Cell: SoapTableViewCell, View {

    // MARK: - Initializing
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: reuseIdentifier)
    }
    
    // MARK: - configuring
    
    func bind(reactor: CellReactor) {
        reactor.state
            .subscribe(onNext: { [weak self] (state) in
                self?.textLabel?.text = state.text
                self?.detailTextLabel?.text = state.detailText
            })
            .disposed(by: self.disposeBag)
    }

}
