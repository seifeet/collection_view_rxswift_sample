//
//  CatalogViewControllerLayout.swift
//  collection_view_demo
//
//  Created by AT on 4/8/19.
//  Copyright © 2019 XoXo. All rights reserved.
//

import UIKit
import SwifterSwift

class CatalogViewControllerLayout: CatalogViewControllerLayouting {
    internal func addViews(to view: UIView) {
        view.addSubview(self.catalogCV)

        self.addLayout(to: view)
    }
    /*
     *
     *   ____   ____.________________      __  _________
     *   \   \ /   /|   \_   _____/  \    /  \/   _____/
     *    \   Y   / |   ||    __)_\   \/\/   /\_____  \
     *     \     /  |   ||        \\        / /        \
     *      \___/   |___/_______  / \__/\  / /_______  /
     *                          \/       \/          \/
     *
     *
     */
    internal let catalogCV: UICollectionView = {
        let collectionView = UICollectionView(frame: CGRect.zero,
                                              collectionViewLayout: CatalogCollectionViewFlowLayout())

        collectionView.translatesAutoresizingMaskIntoConstraints = false

        return collectionView
    }()

    // MARK: - private stuff
    /*
     *    ____  ____  __  _  _   __  ____  ____
     *   (  _ \(  _ \(  )/ )( \ / _\(_  _)(  __)
     *    ) __/ )   / )( \ \/ //    \ )(   ) _)
     *   (__)  (__\_)(__) \__/ \_/\_/(__) (____)
     *
     */

    private func addLayout(to view: UIView) {
        NSLayoutConstraint.activate([
            self.catalogCV
                .topAnchor
                .constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            self.catalogCV
                .leftAnchor
                .constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 0),
            self.catalogCV
                .rightAnchor
                .constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: 0),
            self.catalogCV
                .bottomAnchor
                .constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0)
            ])
    }

    fileprivate struct Const {
        static let padding: CGFloat = 0.0
    }
}
