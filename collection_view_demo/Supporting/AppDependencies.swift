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
        // Catalog ViewModeling
        container.register(CatalogViewModeling.self) { res in
            let viewModel = CatalogViewModel()
            viewModel.api = res.resolve(RemoteData.self)!
            return viewModel
            }.inObjectScope(.transient)

        // view controllers
        // Main VC
        container.register(MainViewController.self) { res in

            let viewController = MainViewController()
            viewController.catalogVM = res.resolve(CatalogViewModeling.self)!
            viewController.layout = res.resolve(CatalogViewControllerLayouting.self)!
            viewController.api = res.resolve(RemoteData.self)!
            return viewController
        }

        // layout
        // CatalogViewControllerLayouting
        container.register(CatalogViewControllerLayouting.self) { _ in
            return CatalogViewControllerLayout()
        }

        // API
        container.register(RemoteData.self) { _ in
            return RemoteData()
            }.inObjectScope(.container)
    }
}
