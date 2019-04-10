//
//  CatalogViewModel.swift
//  collection_view_demo
//
//  Created by AT on 4/8/19.
//  Copyright © 2019 XoXo. All rights reserved.
//

import Foundation

import Fakery

import RxCocoa
import RxSwift

internal final class CatalogViewModel: CatalogViewModeling {

    internal var api: RemoteData!

    internal var count = BehaviorRelay<Int>(value: 0)
    internal var catalogEntities: BehaviorRelay<[CatalogEntity]>

    internal init() {
//        let faker = Faker()
//        self.entities.append(
//            CatalogEntity(url: "https://www.hackingwithswift.com/uploads/cocoa.jpg", likes: faker.number.randomInt(min: 3, max: 100)))
//
//        self.entities.append(
//            CatalogEntity(url: "https://www.hackingwithswift.com/uploads/cocoa.jpg", likes: faker.number.randomInt(min: 3, max: 100)))
//
//        self.entities.append(
//            CatalogEntity(url: "https://www.hackingwithswift.com/uploads/cocoa.jpg", likes: faker.number.randomInt(min: 3, max: 100)))
//
//        self.entities.append(
//            CatalogEntity(url: "https://www.hackingwithswift.com/uploads/cocoa.jpg", likes: faker.number.randomInt(min: 3, max: 100)))
//
//        self.entities.append(
//            CatalogEntity(url: "https://www.hackingwithswift.com/uploads/cocoa.jpg", likes: faker.number.randomInt(min: 3, max: 100)))
//
//        self.entities.append(
//            CatalogEntity(url: "https://www.hackingwithswift.com/uploads/cocoa.jpg", likes: faker.number.randomInt(min: 3, max: 100)))
//
        self.catalogEntities =  BehaviorRelay<[CatalogEntity]>(value: self.entities)
    }

    internal func load() {
        guard !self.isLoading else {
            return
        }
        self.entities.removeAll()
        self.currentPage = 1
        self.isLoading = true
        api.getAllPhotoDataObservable(page: currentPage).observeOnUI()
            .subscribeOn(SerialDispatchQueueScheduler(qos: .background))
            .subscribe(onNext: { [weak self] result in
                guard let this = self else { return }
                this.entities = result
                this.catalogEntities.accept(this.entities)
                this.count.accept(this.entities.count)
                this.isLoading = false
            }).disposed(by: disposeBag)
    }

    internal func loadNextPage() {
        guard !self.isLoading else {
            return
        }
        self.isLoading = true
        self.currentPage += 1
        api.getAllPhotoDataObservable(page: currentPage).observeOnUI()
            .subscribeOn(SerialDispatchQueueScheduler(qos: .background))
            .subscribe(
                onNext: { [weak self] result in
                    guard let this = self else { return }
                    this.entities.append(contentsOf: result)
                    this.catalogEntities.accept(this.entities)
                    this.count.accept(this.entities.count)
                    this.isLoading = false
                }).disposed(by: disposeBag)
    }

    internal func entityFor(page: Int) -> CatalogEntity {
        return self.entities[page]
    }

    // MARK: - private stuff
    /*
     *    ____  ____  __  _  _   __  ____  ____
     *   (  _ \(  _ \(  )/ )( \ / _\(_  _)(  __)
     *    ) __/ )   / )( \ \/ //    \ )(   ) _)
     *   (__)  (__\_)(__) \__/ \_/\_/(__) (____)
     *
     */
    fileprivate var entities = [CatalogEntity]()
    fileprivate var currentPage = 0
    fileprivate var isLoading = false
    fileprivate var disposeBag = DisposeBag()
}
