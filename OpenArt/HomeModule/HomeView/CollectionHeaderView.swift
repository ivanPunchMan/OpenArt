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
        static let avatarImageViewSize: CGFloat = 64
        static let avatarImageViewCornerRadius: CGFloat = avatarImageViewSize / 2
    }
    
    private enum Constraint {
        static let usernameLabelVerticalyOffset: CGFloat = 22
        static let usernameLabelLeadingOffset: CGFloat = 16
        
        static let kebabMenuVerticalOffset: CGFloat = 20
        static let kebabMenuSize: CGFloat = 24
    }

//MARK: - private properties
    private let containerView = UIView()
    private lazy var collectionImageView = UIImageView()
    private var collectionNameLabel = UILabel()
    private var kebabMenuButton = UIButton(type: .system)

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
    
    func collectionName() -> String? {
        self.collectionNameLabel.text
    }
    
    func collectionImage() -> UIImage? {
        self.collectionImageView.image
    }
}

//MARK: - private methods
private extension CollectionHeaderView {
    func setupLayout() {
        self.setupLayoutAvatarImageView()
        self.setupLayoutUsernameLabel()
        self.setupKebabMenuButtonLayout()
    }
    
    func setupLayoutAvatarImageView() {
        self.addSubview(self.collectionImageView)
        self.configureAvatarImageView()
        NSLayoutConstraint.activate([
            self.collectionImageView.topAnchor.constraint(equalTo: self.topAnchor),
            self.collectionImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.collectionImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.collectionImageView.widthAnchor.constraint(equalToConstant: Constant.avatarImageViewSize),
        ])
        let constraint = self.collectionImageView.heightAnchor.constraint(equalToConstant: Constant.avatarImageViewSize)
        constraint.priority = UILayoutPriority(999)
        constraint.isActive = true
    }
    
    func setupLayoutUsernameLabel() {
        self.addSubview(self.collectionNameLabel)
        self.configureUsernameLabel()
        NSLayoutConstraint.activate([
            self.collectionNameLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            self.collectionNameLabel.leadingAnchor.constraint(equalTo: self.collectionImageView.trailingAnchor, constant: Constraint.usernameLabelLeadingOffset),
            self.collectionNameLabel.heightAnchor.constraint(equalToConstant: 20),
        ])
    }
    
    func setupKebabMenuButtonLayout() {
        self.addSubview(self.kebabMenuButton)
        self.configureKebabMenuButton()
        NSLayoutConstraint.activate([
            self.kebabMenuButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            self.kebabMenuButton.leadingAnchor.constraint(equalTo: self.collectionNameLabel.trailingAnchor),
            self.kebabMenuButton.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.kebabMenuButton.widthAnchor.constraint(equalToConstant: Constraint.kebabMenuSize),
            self.kebabMenuButton.heightAnchor.constraint(equalToConstant: Constraint.kebabMenuSize),
        ])
    }
    
    func configureAvatarImageView() {
        self.collectionImageView.translatesAutoresizingMaskIntoConstraints = false
        self.collectionImageView.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        self.collectionImageView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        self.collectionImageView.backgroundColor = .clear
        self.collectionImageView.layer.cornerRadius = Constant.avatarImageViewCornerRadius
        self.collectionImageView.layer.masksToBounds = true
        self.collectionImageView.contentMode = .scaleAspectFill
        
        //test
//        self.collectionImageView.image = UIImage(named: "collectionImage")
    }
    
    func configureUsernameLabel() {
        self.collectionNameLabel.translatesAutoresizingMaskIntoConstraints = false
        self.collectionNameLabel.font = Typography.TextLG.medium.font
        self.collectionNameLabel.textAlignment = .left
        self.collectionNameLabel.adjustsFontSizeToFitWidth = true
        self.collectionNameLabel.minimumScaleFactor = 0.4
        
        //для теста
//        self.collectionNameLabel.text = "ivanPunchMan"
    }
    
    func configureKebabMenuButton() {
        self.kebabMenuButton.translatesAutoresizingMaskIntoConstraints = false
        self.kebabMenuButton.setContentHuggingPriority(.defaultHigh, for: .vertical)
        let kebabMenuImage = UIImage(named: "kebabMenu")
        self.kebabMenuButton.setImage(kebabMenuImage, for: .normal)
        self.kebabMenuButton.tintColor = Color.black.tone
    }
}
