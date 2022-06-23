//
//  CollectionHeaderView.swift
//  OpenArt
//
//  Created by Иван Дурмашев on 15.06.2022.
//

import Foundation
import UIKit

final class CollectionHeaderView: UIView {
//MARK: - private enums
    private enum Constant {
        static let collectionImageViewSize: CGFloat = 64
        static let collectionImageViewCornerRadius: CGFloat = collectionImageViewSize / 2
    }
    
    private enum Constraint {
        static let collectionNameLabelLeadingOffset: CGFloat = 16
        static let collectionNameLabelHeight: CGFloat = 20
    }

//MARK: - properties
    var collectionName: String? {
        self.collectionNameLabel.text
    }
    
    var collectionImage: UIImage? {
        self.collectionImageView.image
    }
    
    private let containerView = UIView()
    private lazy var collectionImageView = UIImageView()
    private var collectionNameLabel = UILabel()

//MARK: - init
    init() {
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.setupLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

//MARK: - internal methods
    func set(collectionName: String?) {
        self.collectionNameLabel.text = collectionName
    }
    
    func set(collectionImage: UIImage?) {
        self.collectionImageView.image = collectionImage
    }
}

//MARK: - private methods
private extension CollectionHeaderView {
    func setupLayout() {
        self.setupLayoutAvatarImageView()
        self.setupCollectionNameLabel()
    }
    
    func setupLayoutAvatarImageView() {
        self.addSubview(self.collectionImageView)
        self.configureCollectionImageView()
        
        NSLayoutConstraint.activate([
            self.collectionImageView.topAnchor.constraint(equalTo: self.topAnchor),
            self.collectionImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.collectionImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.collectionImageView.widthAnchor.constraint(equalToConstant: Constant.collectionImageViewSize),
        ])
        let constraint = self.collectionImageView.heightAnchor.constraint(equalToConstant: Constant.collectionImageViewSize)
        constraint.priority = UILayoutPriority(999)
        constraint.isActive = true
    }
    
    func configureCollectionImageView() {
        self.collectionImageView.translatesAutoresizingMaskIntoConstraints = false
        self.collectionImageView.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        self.collectionImageView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        self.collectionImageView.backgroundColor = .clear
        self.collectionImageView.layer.cornerRadius = Constant.collectionImageViewCornerRadius
        self.collectionImageView.layer.masksToBounds = true
        self.collectionImageView.contentMode = .scaleAspectFill
    }
    
    func setupCollectionNameLabel() {
        self.addSubview(self.collectionNameLabel)
        self.configureCollectionNameLabel()
        
        NSLayoutConstraint.activate([
            self.collectionNameLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            self.collectionNameLabel.leadingAnchor.constraint(equalTo: self.collectionImageView.trailingAnchor, constant: Constraint.collectionNameLabelLeadingOffset),
            self.collectionNameLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.collectionNameLabel.heightAnchor.constraint(equalToConstant: Constraint.collectionNameLabelHeight),
        ])
    }
    
    func configureCollectionNameLabel() {
        self.collectionNameLabel.translatesAutoresizingMaskIntoConstraints = false
        self.collectionNameLabel.font = Typography.TextLG.medium.font
        self.collectionNameLabel.textAlignment = .left
        self.collectionNameLabel.adjustsFontSizeToFitWidth = true
        self.collectionNameLabel.minimumScaleFactor = 0.4
    }
}
