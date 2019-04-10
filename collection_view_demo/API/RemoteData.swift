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

internal class RemoteData {

    public func getAllPhotoDataObservable(page: Int) -> Observable<[CatalogEntity]> {
        return Observable<[CatalogEntity]>.create { (observer) -> Disposable in
            let url = String(format: Const.dataUrl, page)
            let requestReference = AF.request(url, method: .get)
                .validate()
                .responseJSON { response in
                    switch response.result {
                    case .success:
                        var result = [CatalogEntity]()
                        let faker = Faker()
                        
                        if let data = response.data {
                            let json = try? JSONSerialization.jsonObject(with: data, options: [])
                            if let arr = json as? [[String: Any]] {
                                for dict in arr {
                                    if let url = dict["url"] as? String {
                                        let likes = faker.number.randomInt(min: 3, max: 100)
                                        let entity = CatalogEntity(url: url, likes: likes)
                                        result.append(entity)
                                    }
                                }
                            }
                        }
                        observer.onNext(result)
                        observer.onCompleted()
                    case .failure(let error):
                        observer.onError(error)
                    }
            }
            return Disposables.create(with: {
                requestReference.cancel()
            })
        }
    }

    public func getImageObservable(url: String) -> Observable<UIImage?> {
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
}
