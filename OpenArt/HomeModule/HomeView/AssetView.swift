//
//  AssetView.swift
//  OpenArt
//
//  Created by Иван Дурмашев on 15.06.2022.
//

import Foundation
import UIKit

final class AssetView: UIView {
//MARK: - private enums
    private enum Constant {
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
    private let assetImage = UIImage(named: "testImage")
    private var collectionHeaderView = CollectionHeaderView()
    private var kebabMenuButton = UIButton(type: .system)
    private var assetImageView = ResizingImageView()
    private var multiplier: CGFloat?
    private let likedButton = UIButton()

//MARK: - init
    init() {
        super.init(frame: .zero)
        self.configureView()
        self.setupLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//MARK: - internal methods
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
}

//MARK: - private methods
private extension AssetView {
    func configureView() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.layer.cornerRadius = Constant.cornerRadius
        self.layer.borderColor = Color.black.tone.withAlphaComponent(Constant.borderAlphaComponent).cgColor
        self.layer.borderWidth = Constant.borderWidth
    }
    
    func setupLayout() {
        self.setupProfileViewLayout()
        self.setupAssetImageViewLayout()
        self.setupLikedButtonLayout()
    }
    
    func setupProfileViewLayout() {
        self.addSubview(self.collectionHeaderView)
        NSLayoutConstraint.activate([
            self.collectionHeaderView.topAnchor.constraint(equalTo: self.topAnchor, constant: Constraint.profileViewTopOffset),
            self.collectionHeaderView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: Constraint.assetViewHorizontalInset),
            self.collectionHeaderView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -Constraint.assetViewHorizontalInset),
        ])
    }
    
    func setupAssetImageViewLayout() {
        self.addSubview(self.assetImageView)
        self.configureAssetImageView()
        NSLayoutConstraint.activate([
            self.assetImageView.topAnchor.constraint(equalTo: self.collectionHeaderView.bottomAnchor, constant: Constraint.assetImageViewTopOffset),
            self.assetImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: Constraint.assetViewHorizontalInset),
            self.assetImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -Constraint.assetViewHorizontalInset),
        ])
    }
    
    func setupLikedButtonLayout() {
        self.addSubview(self.likedButton)
        self.configureLikedButton()
        let topConstraint = self.likedButton.topAnchor.constraint(equalTo: self.assetImageView.bottomAnchor, constant: 10)
        topConstraint.priority = UILayoutPriority(500)
        topConstraint.isActive = true
        NSLayoutConstraint.activate([
            self.likedButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            self.likedButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10)
        ])
    }
    
    func configureAssetImageView() {
        self.assetImageView.translatesAutoresizingMaskIntoConstraints = false
        self.assetImageView.layer.cornerRadius = Constant.cornerRadius
        self.assetImageView.layer.masksToBounds = true
        self.assetImageView.contentMode = .scaleAspectFit
        
        //Для теста
//        self.assetImageView.collectionImage = UIImage(named: "testImage")
    }
    
    func configureLikedButton() {
        self.likedButton.translatesAutoresizingMaskIntoConstraints = false
        self.likedButton.setImage(UIImage(systemName: "heart"), for: .normal)
        self.likedButton.addTarget(self, action: #selector(self.onLikedButtonTapped), for: .touchUpInside)
    }
    
    @objc func onLikedButtonTapped() {
        print("Like")
    }
}
