//
//  AssetCollectionViewCell.swift
//  OpenArt
//
//  Created by Иван Дурмашев on 13.06.2022.
//

import Foundation
import UIKit

final class AssetCollectionViewCell: UICollectionViewCell {
    static let id = String(describing: AssetCollectionViewCell.self)
    
    private enum Constant {
        static let profileViewLeadingOffset: CGFloat = 8
        static let profileViewTopOffset: CGFloat = 8
    }
    
//MARK: - properties
    var saveButtonTappedHandler: ((UIImage?, UIImage?) -> Void)?
    private let assetView = AssetView()
    
//MARK: - init()
    override init(frame: CGRect) {
        super.init(frame: .zero)
        self.setupLayout()
        self.assetView.saveButtonHandler = { assetImage, collectionImage in
            self.saveButtonTappedHandler?(assetImage, collectionImage)
        }
//        self.saveButtonTappedHandler = assetView.saveButtonHandler
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//MARK: - internal methods
    func set(username: String?) {
        self.assetView.set(collectionName: username)
    }
    
    func set(collectionName: String?) {
        self.assetView.set(collectionName: collectionName)
    }
    
    func set(collectionImage: UIImage?) {
        self.assetView.set(collectionImage: collectionImage)
    }
    
    func set(assetImage: UIImage?) {
        self.assetView.set(assetImage: assetImage)
    }
    
//MARK: - prepareForReuse
    override func prepareForReuse() {
        super.prepareForReuse()

        self.assetView.set(assetImage: nil)
        self.assetView.set(collectionImage: nil)
    }
}

//MARK: - private methods
private extension AssetCollectionViewCell {
    func setupLayout() {
        self.setupAssetViewLayout()
    }
    
    func setupAssetViewLayout() {
        self.contentView.addSubview(self.assetView)
        NSLayoutConstraint.activate([
            self.assetView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            self.assetView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            self.assetView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
            self.assetView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
        ])
    }
    
    
}
