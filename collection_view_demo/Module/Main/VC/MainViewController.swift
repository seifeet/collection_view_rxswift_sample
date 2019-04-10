//
//  MainViewController.swift
//  collection_view_demo
//
//  Created by AT on 4/8/19.
//  Copyright © 2019 XoXo. All rights reserved.
//

import UIKit

import RxCocoa
import RxSwift

class MainViewController: BaseViewController {

    internal var catalogVM: CatalogViewModeling!
    internal var layout: CatalogViewControllerLayouting!
    internal var api: RemoteData!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.configureView()
    }

    override func loadView() {
        self.view = UIView()
        self.layout.addViews(to: self.view)
    }

    // MARK: - private stuff
    /*
     *    ____  ____  __  _  _   __  ____  ____
     *   (  _ \(  _ \(  )/ )( \ / _\(_  _)(  __)
     *    ) __/ )   / )( \ \/ //    \ )(   ) _)
     *   (__)  (__\_)(__) \__/ \_/\_/(__) (____)
     *
     */

    fileprivate func configureView() {
        self.title = "👥"
        self.layout.catalogCV.delegate = self

        self.registerCells()

        // not a great way of doing it
        // should be inserting individual cells instead
        self.catalogVM.catalogEntities
            .bind(to: self.layout.catalogCV.rx
                .items(cellIdentifier: CatalogCollectionViewCell.className, cellType: CatalogCollectionViewCell.self)) {
                    [weak self] row, data, cell in
                    guard let this = self else { return }
                    cell.configure(with: data, api: this.api)
            }.disposed(by: disposeBag)

        self.catalogVM.load()
    }

    fileprivate func registerCells() {
        // cells
        self.layout.catalogCV.register(CatalogCollectionViewCell.self, forCellWithReuseIdentifier: CatalogCollectionViewCell.className)
    }

}

// MARK: - UICollectionViewDelegate
extension MainViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView.bounds.height > 0 else {
            return
        }

        // convert y-position to downward pull progress (percentage)
        let verticalMovement = scrollView.contentOffset.y / scrollView.bounds.height

        guard verticalMovement > 0 else {
            return
        }

        let downwardMovement = fmaxf(Float(abs(verticalMovement)), 0.0)
        let downwardMovementPercent = fminf(downwardMovement, 1.0)

        if downwardMovementPercent >= 1.0 {
            let bottomEdge = scrollView.contentOffset.y + scrollView.frame.size.height;
            if (bottomEdge + 200 >= scrollView.contentSize.height) {
                self.catalogVM.loadNextPage()
            }
        }
    }
}
