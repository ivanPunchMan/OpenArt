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
    
//MARK: - private enums
    private enum Constant {
        static let profileViewLeadingOffset: CGFloat = 8
        static let profileViewTopOffset: CGFloat = 8
        
        static let cornerRadius: CGFloat = 8
        static let borderAlphaComponent: CGFloat = 0.08
        static let borderWidth: CGFloat = 1
    }
    
    private enum Constraint {
        static let assetViewHorizontalInset: CGFloat = 8
        static let profileViewTopOffset: CGFloat = 8
        
        static let kebabMenuTopOffset: CGFloat = 32
        static let kebabMenuSize: CGFloat = 24
        
        static let assetImageViewTopOffset: CGFloat = 16
    }
    
//MARK: - properties
    var saveButtonTappedHandler: ((UIImage?, UIImage?) -> Void)?
    
    private var containerView = UIView()
    private var collectionHeaderView = CollectionHeaderView()
    private var kebabMenuButton = UIButton(type: .system)
    private var assetImageView = ResizingImageView()
    private let likedButton = UIButton()
    private var assetImage: UIImage?
    private var collectionImage: UIImage?
    
//MARK: - init()
    override init(frame: CGRect) {
        super.init(frame: .zero)
        self.setupLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//MARK: - internal methods
    func set(username: String?) {
        self.collectionHeaderView.set(collectionName: username)
    }
    
    func set(collectionName: String?) {
        self.collectionHeaderView.set(collectionName: collectionName)
    }
    
    func set(collectionImage: UIImage?) {
        self.collectionImage = collectionImage
        self.collectionHeaderView.set(collectionImage: collectionImage)
    }
    
    func set(assetImage: UIImage?) {
        self.assetImage = assetImage
        self.assetImageView.setImageAndUpdateAspectRatio(image: assetImage ?? UIImage())
        self.assetImageView.image = assetImage
    }
    
//MARK: - prepareForReuse
    override func prepareForReuse() {
        super.prepareForReuse()
        self.set(assetImage: nil)
        self.collectionHeaderView.set(collectionImage: nil)
    }
}

//MARK: - private methods
private extension AssetCollectionViewCell {
    func setupLayout() {
        self.setupContainerViewLayout()
        self.setupProfileViewLayout()
        self.setupAssetImageViewLayout()
        self.setupLikedButtonLayout()
    }
    
    func setupContainerViewLayout() {
        self.contentView.addSubview(self.containerView)
        self.configureContainerView()
        NSLayoutConstraint.activate([
            self.containerView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            self.containerView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            self.containerView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
            self.containerView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
        ])
    }
    
    func configureContainerView() {
        self.containerView.translatesAutoresizingMaskIntoConstraints = false
        self.containerView.layer.cornerRadius = Constant.cornerRadius
        self.containerView.layer.borderColor = Color.black.tone.withAlphaComponent(Constant.borderAlphaComponent).cgColor
        self.containerView.layer.borderWidth = Constant.borderWidth
    }
    
    func setupProfileViewLayout() {
        self.containerView.addSubview(self.collectionHeaderView)
        NSLayoutConstraint.activate([
            self.collectionHeaderView.topAnchor.constraint(equalTo: self.containerView.topAnchor, constant: Constraint.profileViewTopOffset),
            self.collectionHeaderView.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor, constant: Constraint.assetViewHorizontalInset),
            self.collectionHeaderView.trailingAnchor.constraint(equalTo: self.containerView.trailingAnchor, constant: -Constraint.assetViewHorizontalInset),
        ])
    }
    
    func setupAssetImageViewLayout() {
        self.containerView.addSubview(self.assetImageView)
        self.configureAssetImageView()
        NSLayoutConstraint.activate([
            self.assetImageView.topAnchor.constraint(equalTo: self.collectionHeaderView.bottomAnchor, constant: Constraint.assetImageViewTopOffset),
            self.assetImageView.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor, constant: Constraint.assetViewHorizontalInset),
            self.assetImageView.trailingAnchor.constraint(equalTo: self.containerView.trailingAnchor, constant: -Constraint.assetViewHorizontalInset),
        ])
    }
    
    func configureAssetImageView() {
        self.assetImageView.translatesAutoresizingMaskIntoConstraints = false
        self.assetImageView.layer.cornerRadius = Constant.cornerRadius
        self.assetImageView.layer.masksToBounds = true
        self.assetImageView.contentMode = .scaleAspectFit
    }
    
    func setupLikedButtonLayout() {
        self.containerView.addSubview(self.likedButton)
        self.configureLikedButton()
        let topConstraint = self.likedButton.topAnchor.constraint(equalTo: self.assetImageView.bottomAnchor, constant: 10)
        topConstraint.priority = UILayoutPriority(500)
        topConstraint.isActive = true
        NSLayoutConstraint.activate([
            self.likedButton.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor, constant: 10),
            self.likedButton.bottomAnchor.constraint(equalTo: self.containerView.bottomAnchor, constant: -10)
        ])
    }

    func configureLikedButton() {
        self.likedButton.translatesAutoresizingMaskIntoConstraints = false
        self.likedButton.setImage(UIImage(systemName: "heart"), for: .normal)
        self.likedButton.addTarget(self, action: #selector(self.onSaveButtonTapped), for: .touchUpInside)
    }
    
    @objc func onSaveButtonTapped() {
        self.saveButtonTappedHandler?(self.assetImage, self.collectionImage)
    }
}
