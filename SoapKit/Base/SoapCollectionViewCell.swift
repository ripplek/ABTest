//
//  SoapCollectionViewCell.swift
//  SoapVideo
//
//  Created by ripple_k on 2018/7/9.
//  Copyright © 2018 SoapVideo. All rights reserved.
//

import UIKit

import RxSwift

class SoapCollectionViewCell: UICollectionViewCell {
    var disposeBag = DisposeBag()
    
    
    // MARK: Initializing
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        self.init(frame: .zero)
    }
}
