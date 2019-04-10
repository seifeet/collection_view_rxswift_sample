//
//  ObservableType+Additions.swift
//  collection_view_demo
//
//  Created by AT on 4/8/19.
//  Copyright © 2019 XoXo. All rights reserved.
//

import RxSwift

extension ObservableType {
    /// Observe on the main thread
    ///
    /// - Returns: An observable sequence observed on the main thread
    public func observeOnUI() -> Observable<Self.E> {
        return self.observeOn(MainScheduler.instance)
    }

    /// https://github.com/RxSwiftCommunity/RxSwiftExt/blob/master/Source/RxSwift/unwrap.swift
    /// Takes a sequence of optional elements and returns a sequence
    /// of non-optional elements, filtering out any nil values.
    ///
    /// - Returns:  An observable sequence of non-optional elements
    public func ignoreNil<T>() -> Observable<T> where Self.E == T? {
        return self.filter { $0 != nil }.map { $0! }
    }
}
