//
//  HomeCollectionViewCell.swift
//  OpenArt
//
//  Created by Иван Дурмашев on 13.06.2022.
//

import Foundation
import UIKit

final class HomeCollectionViewCell: UICollectionViewCell {
    static let id = String(describing: HomeCollectionViewCell.self)
    
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
        static let collectionHeaderTopOffset: CGFloat = 8
        
        static let saveAssetTopOffset: CGFloat = 32
        static let saveAssetButtonSize: CGFloat = 30
        
        static let assetImageViewTopOffset: CGFloat = 16
        static let assetImageViewBottomOffset: CGFloat = 13
    }
    
//MARK: - properties
    var assetImage: UIImage? {
        self.assetImageView.image
    }
    var collectionImage: UIImage? {
        self.collectionHeaderView.collectionImage()
    }
    
    var saveButtonTappedHandler: ((UIImage?, UIImage?) -> Void)?
    
    private var containerView = UIView()
    private var collectionHeaderView = CollectionHeaderView()
    private var saveAssetButton = UIButton(type: .system)
    private var assetImageView = ResizingImageView()
    
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
        self.collectionHeaderView.set(collectionImage: collectionImage)
    }
    
    func set(assetImage: UIImage?) {
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
private extension HomeCollectionViewCell {
    func setupLayout() {
        self.setupContainerViewLayout()
        self.collectionHeaderViewLayout()
        self.setupSaveAssetButtonLayout()
        self.setupAssetImageViewLayout()
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
    
    func collectionHeaderViewLayout() {
        self.containerView.addSubview(self.collectionHeaderView)
        NSLayoutConstraint.activate([
            self.collectionHeaderView.topAnchor.constraint(equalTo: self.containerView.topAnchor, constant: Constraint.collectionHeaderTopOffset),
            self.collectionHeaderView.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor, constant: Constraint.assetViewHorizontalInset),
        ])
    }
    
    func setupSaveAssetButtonLayout() {
        self.containerView.addSubview(self.saveAssetButton)
        self.configureSaveAssetButton()
        NSLayoutConstraint.activate([
//            self.saveAssetButton.topAnchor.constraint(equalTo: self.containerView.topAnchor, constant: Constraint.saveAssetTopOffset),
            self.saveAssetButton.centerYAnchor.constraint(equalTo: self.collectionHeaderView.centerYAnchor),
            self.saveAssetButton.leadingAnchor.constraint(equalTo: self.collectionHeaderView.trailingAnchor, constant: 5),
            self.saveAssetButton.trailingAnchor.constraint(equalTo: self.containerView.trailingAnchor, constant: -Constraint.assetViewHorizontalInset),
            self.saveAssetButton.widthAnchor.constraint(equalToConstant: Constraint.saveAssetButtonSize),
            self.saveAssetButton.heightAnchor.constraint(equalToConstant: Constraint.saveAssetButtonSize),
        ])
    }
    
    func configureSaveAssetButton() {
        self.saveAssetButton.translatesAutoresizingMaskIntoConstraints = false
        self.saveAssetButton.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        let addToSavedImage = UIImage(named: "addMenu")
        self.saveAssetButton.setImage(addToSavedImage, for: .normal)
        self.saveAssetButton.tintColor = Color.black.tone
        self.saveAssetButton.addTarget(self, action: #selector(onSaveButtonTapped), for: .touchUpInside)
    }
    
    @objc func onSaveButtonTapped() {
        self.saveButtonTappedHandler?(self.assetImage, self.collectionImage)
    }
    
    func setupAssetImageViewLayout() {
        self.containerView.addSubview(self.assetImageView)
        self.configureAssetImageView()
        NSLayoutConstraint.activate([
            self.assetImageView.topAnchor.constraint(equalTo: self.collectionHeaderView.bottomAnchor, constant: Constraint.assetImageViewTopOffset),
            self.assetImageView.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor, constant: Constraint.assetViewHorizontalInset),
            self.assetImageView.trailingAnchor.constraint(equalTo: self.containerView.trailingAnchor, constant: -Constraint.assetViewHorizontalInset),
            self.assetImageView.bottomAnchor.constraint(equalTo: self.containerView.bottomAnchor, constant: -Constraint.assetImageViewBottomOffset)
        ])
    }
    
    func configureAssetImageView() {
        self.assetImageView.translatesAutoresizingMaskIntoConstraints = false
        self.assetImageView.layer.cornerRadius = Constant.cornerRadius
        self.assetImageView.layer.masksToBounds = true
        self.assetImageView.contentMode = .scaleAspectFit
    }
}
