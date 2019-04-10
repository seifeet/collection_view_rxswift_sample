//
//  CatalogCollectionViewCell.swift
//  collection_view_demo
//
//  Created by AT on 4/8/19.
//  Copyright © 2019 XoXo. All rights reserved.
//

import Foundation
import UIKit
import SwifterSwift
import RxSwift

class CatalogCollectionViewCell: UICollectionViewCell {
    /// Cell re-use identifier
    public var identifier: String { return CatalogCollectionViewCell.className }

    /// Called on a more button tap
    public var likeTapped: (() -> Void)?

    public func configure(with entity: CatalogEntity, api: RemoteData) {
        self.likeLabel.text = "\(entity.likes) likes"
        self.itemIcon.image = nil
        api.getImageObservable(url: entity.url)
            .observeOnUI()
            .subscribeOn(SerialDispatchQueueScheduler(qos: .background))
            .subscribe(
                onNext: { [weak self] image in
                    guard let this = self else { return }
                    this.itemIcon.image = image
                }).disposed(by: disposeBag)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func awakeFromNib() {
        super.awakeFromNib()

        fatalError("Interface Builder is not supported!")
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        self.likeLabel.text = nil
        self.itemIcon.image = nil
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.addViews()
    }

    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes)
        -> UICollectionViewLayoutAttributes {
            layoutIfNeeded()
            let layoutAttributes = super.preferredLayoutAttributesFitting(layoutAttributes)
            layoutAttributes.bounds.size = systemLayoutSizeFitting(UIView.layoutFittingCompressedSize,
                                                                   withHorizontalFittingPriority: .required,
                                                                   verticalFittingPriority: .defaultLow)
            return layoutAttributes
    }
    // MARK: - views
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

    internal let verSV: UIStackView = {
        let stackView = UIStackView()

        stackView.axis  = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 20.0

        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    internal let itemIcon: UIImageView = {
        let imageView = UIImageView(image: nil)

        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false

        return imageView
    }()

    internal let likeLabel: PaddingLabel = {
        let label = PaddingLabel(padding: UIEdgeInsets(top: 0.0, left: 10.0, bottom: 0.0, right: 0.0))

        label.font = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.headline)
        label.textColor = Color.Material.grey600
        label.numberOfLines = 0
        label.minimumScaleFactor = 0.5
        label.text = "--"
        label.textAlignment = .left

        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // MARK: - private stuff
    /*
     *    ____  ____  __  _  _   __  ____  ____
     *   (  _ \(  _ \(  )/ )( \ / _\(_  _)(  __)
     *    ) __/ )   / )( \ \/ //    \ )(   ) _)
     *   (__)  (__\_)(__) \__/ \_/\_/(__) (____)
     *
     */

    fileprivate func addViews() {
        self.contentView.addSubview(self.verSV)

        self.verSV.addArrangedSubview(self.itemIcon)
        self.verSV.addArrangedSubview(self.likeLabel)

        self.addLayout(to: self.contentView)
    }

    private func addLayout(to view: UIView) {
        let itemIconHeightConstraint = self.itemIcon
            .heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height / 2.5)
        itemIconHeightConstraint.priority = 999

        NSLayoutConstraint.activate([
            itemIconHeightConstraint,
            // vertical stack view
            self.verSV
                .topAnchor
                .constraint(equalTo: view.topAnchor, constant: Const.padding),
            self.verSV
                .leftAnchor
                .constraint(equalTo: view.leftAnchor, constant: Const.padding),
            self.verSV
                .rightAnchor
                .constraint(equalTo: view.rightAnchor, constant: -Const.padding),
            self.verSV
                .bottomAnchor
                .constraint(equalTo: view.bottomAnchor, constant: 0)
            ])
    }

    fileprivate struct Const {
        static let padding: CGFloat = 10.0
    }

    fileprivate var disposeBag = DisposeBag()
}
