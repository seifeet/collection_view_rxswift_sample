//
//  BaseViewController.swift
//  collection_view_demo
//
//  Created by AT on 4/8/19.
//  Copyright © 2019 XoXo. All rights reserved.
//

import UIKit
import RxSwift

class BaseViewController: UIViewController {
    #if DEBUG
    private let startResourceCount = Resources.total
    #endif

    lazy var disposeBag = DisposeBag()

    deinit {
        #if DEBUG
            print("View controller disposed with \(Resources.total) resources")

            let numberOfResourcesThatShouldRemain = startResourceCount
            let mainQueue = DispatchQueue.main
            // `dispatch_async` is here to compensate for CoreAnimation delay after
            // changing view controller hierarchy. This time is usually ~100ms on simulator and less on device.
            let when = DispatchTime.now() + DispatchTimeInterval.milliseconds(100)

            mainQueue.asyncAfter (deadline: when) {
                // If this fails for you while testing, and you've been clicking fast, it's ok, just click slower,
                // this is a debug build with resource tracing turned on.
                if Resources.total > numberOfResourcesThatShouldRemain {
                    // There is some leakage on iPhone X simulator
                    log.error("Resources weren't cleaned properly, \(Resources.total) " +
                        "remained, \(numberOfResourcesThatShouldRemain) expected")
                }
            }
        #endif
    }
}
