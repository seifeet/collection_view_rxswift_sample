//
//  NSObject+Additions.swift
//  collection_view_demo
//
//  Created by AT on 4/8/19.
//  Copyright © 2019 XoXo. All rights reserved.
//

import Foundation

extension NSObject {
    var className: String {
        return String(describing: type(of: self))
    }

    class var className: String {
        return String(describing: self)
    }
}
