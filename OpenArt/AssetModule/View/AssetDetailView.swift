//
//  AssetDetailView.swift
//  OpenArt
//
//  Created by Иван Дурмашев on 15.06.2022.
//

import Foundation
import UIKit

final class AssetDetailView: UIView {
 //MARK: - private enums
    private enum Constant {
        static let cornerRadius: CGFloat = 8
        static let separatorViewAlphaComponent: CGFloat = 0.04
    }
    
    private enum Constraint {
        static let assetImageViewTopOffset: CGFloat = 15
        static let placeBidViewHorizontalInset: CGFloat = 16
        
        static let collectionAndDescriptionHorizontalOffset: CGFloat = 24
        
        static let separatorViewHeight: CGFloat = 1
        static let separatorViewBottomOffset: CGFloat = 5
    }
    
//MARK: - properties
    private let scrollView = UIScrollView()
    private let containerView = UIView()
    private let assetImageView = ResizingImageView()
    private let collectionHeaderView = CollectionHeaderView()
    private let descriptionView = AssetDescriptionView()
    private let separatorView = UIView()
    
//MARK: - init
    init() {
        super.init(frame: .zero)
        self.backgroundColor = .white
        self.setupLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//MARK: - internal methods
    func set(assetInfo viewModel: AssetModel.FetchAssetData.ViewModel) {
        self.assetImageView.setImageAndUpdateAspectRatio(image: viewModel.assetImage ?? UIImage())
        self.collectionHeaderView.set(collectionImage: viewModel.collectionImage)
        self.collectionHeaderView.set(collectionName: viewModel.collectionName)
        self.descriptionView.set(title: viewModel.assetName)
        self.descriptionView.set(description: viewModel.assetDescription)
    }
}

//MARK: - private methods
private extension AssetDetailView {
    func setupLayout() {
        self.setupScrollViewLayout()
        self.setupContainerViewLayout()        
        self.setupAssetImageViewLayout()
        self.setupCollectionHeaderViewLayout()
        self.setupDescriptionViewLayout()
        self.setupSeparatorViewLayout()
    }
    
    func setupScrollViewLayout() {
        self.addSubview(self.scrollView)
        self.scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.scrollView.topAnchor.constraint(equalTo: self.topAnchor),
            self.scrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.scrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.scrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
    }
    
    func setupContainerViewLayout() {
        self.scrollView.addSubview(self.containerView)
        self.containerView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.containerView.topAnchor.constraint(equalTo: self.scrollView.topAnchor),
            self.containerView.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor),
            self.containerView.bottomAnchor.constraint(equalTo: self.scrollView.bottomAnchor),
            self.containerView.trailingAnchor.constraint(equalTo: self.scrollView.trailingAnchor),
            self.containerView.widthAnchor.constraint(equalTo: self.scrollView.widthAnchor)
        ])
    }
    
    func setupAssetImageViewLayout() {
        self.containerView.addSubview(self.assetImageView)
        self.configureAssetImageView()
        
        NSLayoutConstraint.activate([
            self.assetImageView.topAnchor.constraint(equalTo: self.containerView.topAnchor, constant: Constraint.assetImageViewTopOffset),
            self.assetImageView.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor, constant: Constraint.placeBidViewHorizontalInset),
            self.assetImageView.trailingAnchor.constraint(equalTo: self.containerView.trailingAnchor, constant: -Constraint.placeBidViewHorizontalInset),
        ])
    }
    
    func configureAssetImageView() {
        self.assetImageView.translatesAutoresizingMaskIntoConstraints = false
        self.assetImageView.layer.cornerRadius = Constant.cornerRadius
        self.assetImageView.layer.masksToBounds = true
        self.assetImageView.contentMode = .scaleAspectFit
    }
    
    func setupCollectionHeaderViewLayout() {
        self.containerView.addSubview(self.collectionHeaderView)
        
        NSLayoutConstraint.activate([
            self.collectionHeaderView.topAnchor.constraint(equalTo: self.assetImageView.bottomAnchor, constant: Constraint.collectionAndDescriptionHorizontalOffset),
            self.collectionHeaderView.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor, constant: Constraint.placeBidViewHorizontalInset),
            self.collectionHeaderView.trailingAnchor.constraint(equalTo: self.containerView.trailingAnchor, constant: -Constraint.placeBidViewHorizontalInset),
        ])
    }
    
    func setupDescriptionViewLayout() {
        self.containerView.addSubview(self.descriptionView)
        
        NSLayoutConstraint.activate([
            self.descriptionView.topAnchor.constraint(equalTo: self.collectionHeaderView.bottomAnchor, constant: Constraint.collectionAndDescriptionHorizontalOffset),
            self.descriptionView.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor, constant: Constraint.placeBidViewHorizontalInset),
            self.descriptionView.trailingAnchor.constraint(equalTo: self.containerView.trailingAnchor, constant: -Constraint.placeBidViewHorizontalInset)
        ])
    }
    
    func setupSeparatorViewLayout() {
        self.containerView.addSubview(self.separatorView)
        self.configureSeparatorView()
        
        NSLayoutConstraint.activate([
            self.separatorView.topAnchor.constraint(equalTo: self.descriptionView.bottomAnchor, constant: Constraint.collectionAndDescriptionHorizontalOffset),
            self.separatorView.bottomAnchor.constraint(equalTo: self.containerView.bottomAnchor, constant: -Constraint.separatorViewBottomOffset),
            self.separatorView.widthAnchor.constraint(equalTo: self.containerView.widthAnchor),
            self.separatorView.heightAnchor.constraint(equalToConstant: Constraint.separatorViewHeight)
        ])
    }
    
    func configureSeparatorView() {
        self.separatorView.translatesAutoresizingMaskIntoConstraints = false
        self.separatorView.backgroundColor = Color.black.tone.withAlphaComponent(Constant.separatorViewAlphaComponent)
    }
}
