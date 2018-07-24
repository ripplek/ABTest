//
//  SoapTableViewCell.swift
//  SoapVideo
//
//  Created by ripple_k on 2018/7/9.
//  Copyright © 2018 SoapVideo. All rights reserved.
//

import UIKit

import RxSwift

class SoapTableViewCell: UITableViewCell {

    var disposeBag = DisposeBag()
    
    
    // MARK: Initializing
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        self.init(style: .default, reuseIdentifier: nil)
    }

}
