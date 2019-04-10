//
// CatalogViewControllerLayouting.swift
//  collection_view_demo
//
//  Created by AT on 4/8/19.
//  Copyright © 2019 XoXo. All rights reserved.
//

import UIKit

internal protocol CatalogViewControllerLayouting {
    var catalogCV: UICollectionView { get }

    func addViews(to view: UIView)
}
