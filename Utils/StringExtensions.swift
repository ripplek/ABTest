//
//  StringExtensions.swift
//  SoapVideo
//
//  Created by Carl Chen on 30/01/2018.
//  Copyright © 2018 SoapVideo. All rights reserved.
//

import Foundation

extension String: NamespaceWrappable {}
extension NamespaceWrapper where T == String {
    func indexFromStart(_ offset: Int) -> String.Index {
        return wrappedValue.index(wrappedValue.startIndex, offsetBy: offset)
    }

    func match(regex: String) -> Bool {
        let pred = NSPredicate(format: "SELF MATCHES %@", argumentArray:[regex])
        return pred.evaluate(with: wrappedValue)
    }

    subscript(range: Range<Int>) -> Substring {
        let startIndex = indexFromStart(range.lowerBound)
        let endIndex = indexFromStart(range.upperBound)
        return wrappedValue[startIndex..<endIndex]
    }

    subscript(range: CountablePartialRangeFrom<Int>) -> Substring {
        let startIndex = indexFromStart(range.lowerBound)
        let endIndex = wrappedValue.endIndex
        return wrappedValue[startIndex..<endIndex]
    }

    subscript(range: CountableClosedRange<Int>) -> Substring {
        let startIndex = indexFromStart(range.lowerBound)
        let endIndex = indexFromStart(range.upperBound)
        return wrappedValue[startIndex...endIndex]
    }
}

extension Substring: NamespaceWrappable {}
extension NamespaceWrapper where T == Substring {
    func indexFromStart(_ offset: Int) -> String.Index {
        return wrappedValue.index(wrappedValue.startIndex, offsetBy: offset)
    }
    
    func match(regex: String) -> Bool {
        let pred = NSPredicate(format: "SELF MATCHES %@", argumentArray:[regex])
        return pred.evaluate(with: wrappedValue)
    }

    subscript(range: CountableRange<Int>) -> Substring {
        let startIndex = indexFromStart(range.lowerBound)
        let endIndex = indexFromStart(range.upperBound)
        return wrappedValue[startIndex..<endIndex]
    }

    subscript(range: CountableClosedRange<Int>) -> Substring {
        let startIndex = indexFromStart(range.lowerBound)
        let endIndex = indexFromStart(range.upperBound)
        return wrappedValue[startIndex...endIndex]
    }
}

