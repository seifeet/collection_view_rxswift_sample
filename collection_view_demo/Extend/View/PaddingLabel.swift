//
//  PaddingLabel.swift
//  collection_view_demo
//
//  Created by AT on 4/8/19.
//  Copyright © 2019 XoXo. All rights reserved.
//

import UIKit

class PaddingLabel: UILabel {

    let padding: UIEdgeInsets

    // Create a new PaddingLabel instance programamtically with the desired insets
    required init(padding: UIEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)) {
        self.padding = padding
        super.init(frame: CGRect.zero)
    }

    // Create a new PaddingLabel instance programamtically with default insets
    override init(frame: CGRect) {
        padding = UIEdgeInsets.zero // set desired insets value according to your needs
        super.init(frame: frame)
    }

    // Create a new PaddingLabel instance from Storyboard with default insets
    required init?(coder aDecoder: NSCoder) {
        padding = UIEdgeInsets.zero // set desired insets value according to your needs
        super.init(coder: aDecoder)
    }

    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: padding))
    }

    override func textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
        let insetRect = bounds.inset(by: self.padding)
        let textRect = super.textRect(forBounds: insetRect, limitedToNumberOfLines: numberOfLines)
        let invertedInsets = UIEdgeInsets(top: -self.padding.top,
                                          left: -self.padding.left,
                                          bottom: -self.padding.bottom,
                                          right: -self.padding.right)
        return textRect.inset(by: invertedInsets)
    }
}
