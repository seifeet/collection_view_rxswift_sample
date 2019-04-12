//
//  AppDependencies.swift
//  collection_view_demo
//
//  Created by AT on 4/8/19.
//  Copyright © 2019 XoXo. All rights reserved.
//

import Foundation
import Swinject

class AppDependencies {

    let container = Container { container in

        // models

        // view controllers
        // Main VC
        container.register(MainViewController.self) { res in

            let viewController = MainViewController()
            viewController.layout = res.resolve(CatalogViewControllerLayouting.self)!
            viewController.api = res.resolve(FeedProvider.self)!
            return viewController
        }

        // layout
        // CatalogViewControllerLayouting
        container.register(CatalogViewControllerLayouting.self) { _ in
            return CatalogViewControllerLayout()
        }

        // API
        container.register(FeedProvider.self) { _ in
            return FeedProvider()
            }.inObjectScope(.container)
    }
}
