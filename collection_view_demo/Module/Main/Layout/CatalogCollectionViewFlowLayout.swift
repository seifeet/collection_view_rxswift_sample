//
//  CatalogCollectionViewFlowLayout.swift
//  collection_view_demo
//
//  Created by AT on 4/8/19.
//  Copyright © 2019 XoXo. All rights reserved.
//

import Foundation
import UIKit

class CatalogCollectionViewFlowLayout: UICollectionViewFlowLayout {

    override init() {
        super.init()

        self.minimumInteritemSpacing = Const.padding
        self.minimumLineSpacing = Const.padding
        self.sectionInset = UIEdgeInsets(top: Const.padding,
                                         left: Const.padding,
                                         bottom: Const.padding,
                                         right: Const.padding)
        estimatedItemSize = UICollectionViewFlowLayout.automaticSize
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard let layoutAttributes = super.layoutAttributesForItem(at: indexPath) else { return nil }
        guard let collectionView = collectionView else { return nil }
        if #available(iOS 11.0, *) {
            layoutAttributes.bounds.size.width = collectionView.safeAreaLayoutGuide.layoutFrame.width -
                sectionInset.left - sectionInset.right
        } else {
            // Fallback on earlier versions
            layoutAttributes.bounds.size.width = collectionView.layoutMarginsGuide.layoutFrame.width -
                sectionInset.left - sectionInset.right
        }
        return layoutAttributes
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let superLayoutAttributes = super.layoutAttributesForElements(in: rect) else { return nil }
        guard scrollDirection == .vertical else { return superLayoutAttributes }

        let computedAttributes = superLayoutAttributes.compactMap { layoutAttribute in
            return layoutAttribute.representedElementCategory == .cell ?
                layoutAttributesForItem(at: layoutAttribute.indexPath) : layoutAttribute
        }
        return computedAttributes
    }

    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }

    fileprivate struct Const {
        static let padding: CGFloat = 10.0
    }
}
