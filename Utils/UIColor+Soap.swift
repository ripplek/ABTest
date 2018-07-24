//
//  UIColor+Soap.swift
//  SoapVideo
//
//  Created by ripple_k on 2018/7/18.
//  Copyright © 2018 SoapVideo. All rights reserved.
//

import UIKit

extension UIColor {
    class var db_charcoal: UIColor { return 0x333333.color }
    class var db_slate: UIColor { return 0x9DA3A5.color }
    class var db_pink: UIColor { return 0xEA4C89.color }
    class var db_darkPink: UIColor { return 0xDF3E7B.color }
    class var db_linkBlue: UIColor { return 0x3A8BBB.color }
    class var db_darkLinkBlue: UIColor { return 0x17374A.color }
    
    class var db_background: UIColor { return 0xF4F4F4.color }
    class var db_border: UIColor { return 0xE5E5E5.color }
}

public extension IntegerLiteralType {
    public var f: CGFloat {
        return CGFloat(self)
    }
}

public extension FloatLiteralType {
    public var f: CGFloat {
        return CGFloat(self)
    }
}
