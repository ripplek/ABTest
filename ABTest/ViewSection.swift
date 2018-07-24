//
//  ViewSection.swift
//  ABTest
//
//  Created by ripple_k on 2018/7/20.
//  Copyright © 2018 SoapVideo. All rights reserved.
//

import RxDataSources

enum ViewSection {
    case stars([ViewSectionItem])
}

extension ViewSection: SectionModelType {
    var items: [ViewSectionItem] {
        switch self {
        case .stars(let items): return items
        }
    }
    
    init(original: ViewSection, items: [ViewSectionItem]) {
        switch original {
        case .stars: self = .stars(items)
        }
    }
}

enum ViewSectionItem {
    case stars(CellReactor)
}
