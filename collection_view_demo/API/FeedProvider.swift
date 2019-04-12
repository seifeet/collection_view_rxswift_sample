//
//  RemoteData.swift
//  collection_view_demo
//
//  Created by AT on 4/9/19.
//  Copyright © 2019 XoXo. All rights reserved.
//

import Foundation

import Alamofire

import RxSwift
import RxCocoa

import Fakery

internal class FeedProvider {

    public func fetchPage(atIndex index: Int) -> Single<FeedPage> {
        return Observable<FeedPage>.create { (observer) -> Disposable in
            let url = String(format: Const.dataUrl, index)
            let requestReference = AF.request(url, method: .get)
                .validate()
                .responseJSON { [weak self] response in
                    guard let this = self else { return }

                    switch response.result {
                    case .success:
                        var items = [FeedEntity]()

                        if let data = response.data {
                            let json = try? JSONSerialization.jsonObject(with: data, options: [])
                            if let arr = json as? [[String: Any]] {
                                for dict in arr {
                                    guard let urlString = dict["url"] as? String else {
                                        continue
                                    }
                                    guard let url = URL(string: urlString) else {
                                        continue
                                    }
                                    let likeCount = this.faker.number.randomInt(min: 3, max: 100)
                                    let item = FeedEntity(id: this.faker.number.increasingUniqueId(), image: url, likeCount: likeCount, liked: false)
                                    items.append(item)
                                }
                            }
                        }
                        let result = FeedPage(count: items.count, results: items, nextPageIndex: index+1, previousPageIndex: index-1)
                        observer.onNext(result)
                        observer.onCompleted()
                    case .failure(let error):
                        observer.onError(error)
                    }
            }
            return Disposables.create(with: {
                requestReference.cancel()
            })
        }.asSingle()
    }

    public func getImageObservable(url: URL) -> Observable<UIImage?> {
        return Observable<UIImage?>.create { (observer) -> Disposable in
            let requestReference = AF.request(url, method: .get)
                .validate()
                .response { response in
                    switch response.result {
                    case .success:
                        if let data = response.data {
                            let image = UIImage(data: data, scale:1)
                            observer.onNext(image)
                            observer.onCompleted()
                        }
                    case .failure(let error):
                        observer.onError(error)
                    }
            }
            return Disposables.create(with: {
                requestReference.cancel()
            })
        }
    }

    fileprivate struct Const {
        static let dataUrl = "https://jsonplaceholder.typicode.com/photos?_page=%d"
    }

    private let faker: Faker = Faker(locale: "en-US")
}
