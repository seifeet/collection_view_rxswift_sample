//
//  CatalogViewModeling.swift
//  collection_view_demo
//
//  Created by AT on 4/8/19.
//  Copyright © 2019 XoXo. All rights reserved.
//

import Foundation

import RxCocoa
import RxSwift

internal protocol CatalogViewModeling {

    var count: BehaviorRelay<Int> { get }
    var catalogEntities: BehaviorRelay<[CatalogEntity]> { get }

    func entityFor(page: Int) -> CatalogEntity
    func load()
    func loadNextPage()
}
