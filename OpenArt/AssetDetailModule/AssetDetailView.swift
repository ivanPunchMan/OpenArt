//
//  AssetView.swift
//  OpenArt
//
//  Created by Иван Дурмашев on 15.06.2022.
//

import Foundation
import UIKit

protocol IAssetDetailView: AnyObject {
    
}

final class AssetDetailView: UIView {
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
    private let scrollView = UIScrollView()
    private let containerView = UIView()
    private let assetDetailView = AssetCardView()
//    private let likedButton = LikedButton()
    
//MARK: - init
    init() {
        super.init(frame: .zero)
        self.backgroundColor = .white
        self.setupLayout()
        
        self.assetDetailView.onLikedButtonTappedHandler = { [weak self] request in
            self?.onLikedButtonTappedHandler?(request)
        }
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(assetImage: UIImage?) {
        self.assetDetailView.set(assetImage: assetImage)
    }
    
    func set(colletionImage: UIImage?) {
        self.assetDetailView.set(collectionImage: colletionImage)
    }
    
    func set(collectionName: String?) {
        self.assetDetailView.set(collectionName: collectionName)
    }
    
    func set(title: String?) {
        self.assetDetailView.set(title: title)
    }
    
    func set(description: String?) {
        self.assetDetailView.set(description: description)
    }
}

//MARK: - private method
extension AssetDetailView: IAssetDetailView {
    func setupLayout() {
        self.setupScrollViewLayout()
        self.setupContainerViewLayout()
        self.setupAssetDetailView()
    }
    
    func setupScrollViewLayout() {
        self.addSubview(self.scrollView)
        self.scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.scrollView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            self.scrollView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            self.scrollView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor),
            self.scrollView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor)
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
    
    func setupAssetDetailView() {
        self.containerView.addSubview(self.assetDetailView)
        NSLayoutConstraint.activate([
            self.assetDetailView.topAnchor.constraint(equalTo: self.containerView.topAnchor),
            self.assetDetailView.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor),
            self.assetDetailView.bottomAnchor.constraint(equalTo: self.containerView.bottomAnchor, constant: -300),
            self.assetDetailView.trailingAnchor.constraint(equalTo: self.containerView.trailingAnchor)
        ])
    }
}
