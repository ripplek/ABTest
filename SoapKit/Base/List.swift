//
//  List.swift
//  ABTest
//
//  Created by ripple_k on 2018/8/2.
//  Copyright © 2018 SoapVideo. All rights reserved.
//

import Foundation

struct List<Element> {
    var items: [Element]
    var nextURL: URL?
    
    init(items: [Element], nextURL: URL? = nil) {
        self.items = items
        self.nextURL = nextURL
    }
}
