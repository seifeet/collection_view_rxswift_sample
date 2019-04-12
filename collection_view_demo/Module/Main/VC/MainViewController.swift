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
import RxDataSources
import RxFeedback

class MainViewController: BaseViewController {

    internal var layout: CatalogViewControllerLayouting!
    internal var api: FeedProvider!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.configureView()
        self.setUpFeedbackLoop()
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

        self.registerCells()
    }

    fileprivate func registerCells() {
        // cells
        self.layout.catalogCV.register(CatalogCollectionViewCell.self, forCellWithReuseIdentifier: CatalogCollectionViewCell.className)
    }

    private func setUpFeedbackLoop() {
        let uiFeedback: FeedState.Feedback = bind(self) { me, state in
            let subscriptions: [Disposable] = [
                me.bindDataSource(state: state, to: me.layout.catalogCV)
            ]

            let mutations: [Signal<FeedMutation>] = [
                me.nextPageMutation(state: state, in: me.layout.catalogCV),
                me.mutations.asSignal()
            ]


            return Bindings(subscriptions: subscriptions, mutations: mutations)
        }

        let loadPageFeedback: FeedState.Feedback = react(
            query: { $0.loadPageIndex },
            effects: { [weak self] index -> Signal<FeedMutation> in
                guard let this = self else { return Signal.empty() }
                return this.api
                    .fetchPage(atIndex: index)
                    .map { .pageLoaded(page: $0) }
                    .asSignal(onErrorJustReturn: .error)
            }
        )

        Driver.system(
            initialState: FeedState(),
            reduce: FeedState.reduce,
            feedback: uiFeedback, loadPageFeedback
            )
            .drive(state)
            .disposed(by: disposeBag)
    }

    private func bindDataSource(state: Driver<FeedState>, to collectionView: UICollectionView) -> Disposable {
        let dataSource = RxCollectionViewSectionedAnimatedDataSource<AnimatableSectionModel<String, FeedEntity>>(
            configureCell: { [weak self] (_, collectionView, indexPath, item: FeedEntity) in
                guard let this = self else { return UICollectionViewCell() }
                
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CatalogCollectionViewCell.className, for: indexPath)

                if let catalogCell = cell as? CatalogCollectionViewCell {
                    catalogCell.configure(with: item, api: this.api)
                    catalogCell.likeButton.rx.tap
                        .map { .like(id: item.id) }
                        .bind(to: this.mutations)
                        .disposed(by: catalogCell.disposeBag)
                }

                return cell

            },
            configureSupplementaryView: { _, _, _, _ in UICollectionReusableView(frame: .zero) }
        )

        return state
            .map { $0.items }
            .map { [AnimatableSectionModel(model: "section", items: $0)] }
            .drive(collectionView.rx.items(dataSource: dataSource))
    }

    private func nextPageMutation(state: Driver<FeedState>,
                                  in collectionView: UICollectionView) -> Signal<FeedMutation> {
        return state.flatMapLatest { state in
            guard !state.shouldLoadNext else {
                return Signal.empty()
            }

            return collectionView.rx.willDisplayCell
                .asSignal()
                .filter { $0.at.item == state.items.count - 1 }
                .map { _ in .loadNextPage }
        }
    }

    private let state: BehaviorRelay<FeedState?> = BehaviorRelay(value: nil)
    private let mutations: PublishRelay<FeedMutation> = PublishRelay()
}
