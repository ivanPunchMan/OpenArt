//
//  AssetCardView.swift
//  OpenArt
//
//  Created by Иван Дурмашев on 15.06.2022.
//

import Foundation
import UIKit


final class AssetCardView: UIView {
 //MARK: - private enums
    private enum Constant {
        static let cornerRadius: CGFloat = 8
        static let separatorViewAlphaComponent: CGFloat = 0.04
    }
    
    private enum Constraint {
        static let assetImageViewTopOffset: CGFloat = 27
        static let placeBidViewHorizontalInset: CGFloat = 16
        
        static let profileAndDescriptionHorizontalOffset: CGFloat = 24
        
        static let separatorViewHeight: CGFloat = 1
    }
    
//MARK: - properties
    var onLikedButtonTappedHandler: ((AssetModel.SaveAsset.Request) -> Void)?
    private let assetImageView = ResizingImageView()
    private let collectionHeaderView = CollectionHeaderView()
    private let descriptionView = AssetDescriptionView()
    private let separatorView = UIView()
    private let likedButton = LikedButton(text: "Save")
    
//MARK: - init
    init() {
        super.init(frame: .zero)
        self.backgroundColor = .white
        self.translatesAutoresizingMaskIntoConstraints = false
        self.setupLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(assetImage: UIImage?) {
        self.assetImageView.setImageAndUpdateAspectRatio(image: assetImage ?? UIImage())
    }
    
    func set(collectionName: String?) {
        self.collectionHeaderView.set(collectionName: collectionName)
    }
    
    func set(collectionImage: UIImage?) {
        self.collectionHeaderView.set(collectionImage: collectionImage)
    }
    
    func set(title: String?) {
        self.descriptionView.set(title: title)
    }
    
    func set(description: String?) {
        self.descriptionView.set(description: description)
    }
}

//MARK: - private method
extension AssetCardView {
    func setupLayout() {
        self.setupAssetImageViewLayout()
        self.setupProfileViewLayout()
        self.setupDescriptionViewLayout()
        self.setupSeparatorViewLayout()
        self.setupLikedButtonLayout()
    }
    
    func setupAssetImageViewLayout() {
        self.addSubview(self.assetImageView)
        self.configureAssetImageView()
//        let multiplier = self.assetImage?.multiplier ?? 1
        NSLayoutConstraint.activate([
            self.assetImageView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: Constraint.assetImageViewTopOffset),
            self.assetImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: Constraint.placeBidViewHorizontalInset),
            self.assetImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -Constraint.placeBidViewHorizontalInset),
        ])
    }
    
    func setupProfileViewLayout() {
        self.addSubview(self.collectionHeaderView)
        NSLayoutConstraint.activate([
            self.collectionHeaderView.topAnchor.constraint(equalTo: self.assetImageView.bottomAnchor, constant: Constraint.profileAndDescriptionHorizontalOffset),
            self.collectionHeaderView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: Constraint.placeBidViewHorizontalInset),
            self.collectionHeaderView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -Constraint.placeBidViewHorizontalInset),
        ])
        let topConstraint = self.collectionHeaderView.topAnchor.constraint(equalTo: self.assetImageView.bottomAnchor, constant: Constraint.profileAndDescriptionHorizontalOffset)
        topConstraint.priority = UILayoutPriority(250)
        topConstraint.isActive = true
    }
    
    func setupDescriptionViewLayout() {
        self.addSubview(self.descriptionView)
        NSLayoutConstraint.activate([
            self.descriptionView.topAnchor.constraint(equalTo: self.collectionHeaderView.bottomAnchor, constant: Constraint.profileAndDescriptionHorizontalOffset),
            self.descriptionView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: Constraint.placeBidViewHorizontalInset),
            self.descriptionView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -Constraint.placeBidViewHorizontalInset)
        ])
    }
    
    func setupSeparatorViewLayout() {
        self.addSubview(self.separatorView)
        self.configureSeparatorView()
        NSLayoutConstraint.activate([
            self.separatorView.topAnchor.constraint(equalTo: self.descriptionView.bottomAnchor, constant: Constraint.profileAndDescriptionHorizontalOffset),
//            self.separatorView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.separatorView.widthAnchor.constraint(equalTo: self.widthAnchor),
            self.separatorView.heightAnchor.constraint(equalToConstant: Constraint.separatorViewHeight)
        ])
    }
    
    func setupLikedButtonLayout() {
        self.addSubview(self.likedButton)
        self.configureLikedButton()
        NSLayoutConstraint.activate([
            self.likedButton.topAnchor.constraint(equalTo: self.separatorView.bottomAnchor, constant: 32),
            self.likedButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            self.likedButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -16),
            self.likedButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16)
        ])
    }
    
    func configureAssetImageView() {
        self.assetImageView.translatesAutoresizingMaskIntoConstraints = false
        self.assetImageView.layer.cornerRadius = Constant.cornerRadius
        self.assetImageView.layer.masksToBounds = true
        self.assetImageView.contentMode = .scaleAspectFit
        
        //Для теста
//        self.assetImageView.image = UIImage(named: "testImage")
    }
    
    func configureSeparatorView() {
        self.separatorView.translatesAutoresizingMaskIntoConstraints = false
        self.separatorView.backgroundColor = Color.black.tone.withAlphaComponent(Constant.separatorViewAlphaComponent)
    }
    
    func configureLikedButton() {
        self.likedButton.addTarget(self, action: #selector(onLikedButtonTapped), for: .touchUpInside)
    }
    
    @objc func onLikedButtonTapped() {
        print("Like")
        let assetName = descriptionView.assetName()
        let assetDescription = descriptionView.assetDescription()
        let assetImage = assetImageView.image
        let collectionName = collectionHeaderView.collectionName()
        let collectionImage = collectionHeaderView.collectionImage()
        
        let request = AssetModel.SaveAsset.Request.init(assetName: assetName, assetImage: assetImage, assetDescription: assetDescription, collectionName: collectionName, collectionImage: collectionImage)
        
        self.onLikedButtonTappedHandler?(request)
    }
}
