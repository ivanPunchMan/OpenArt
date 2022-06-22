//
//  SavedCollectionViewCell.swift
//  OpenArt
//
//  Created by Иван Дурмашев on 20.06.2022.
//

import Foundation
import UIKit

final class SavedCollectionViewCell: UICollectionViewCell {
    static let id = String(describing: SavedCollectionViewCell.self)

//MARK: - private enums
    private enum Constant {
        static let cornerRadius: CGFloat = 8
        static let borderAlphaComponent: CGFloat = 0.08
        static let borderWidth: CGFloat = 1
    }
    
    private enum Constraint {
        static let cellHorizontalInset: CGFloat = 7
        
        static let assetImageViewTopOffset: CGFloat = 8
        
        static let assetNameLabelVerticalOffset: CGFloat = 5
        
        static let deleteAssetButtonSize: CGFloat = 24
        static let deleteAssetButtonTopOffset: CGFloat = 4
        static let deleteAssetButtonLeadingOffset: CGFloat = 5
        static let deleteAssetButtonBottomOffset: CGFloat = 5
    }
    
//MARK: - properties
    var onDeleteButtonTappedHandler: (() -> Void)?
    private let containerView = UIView()
    private let assetImageView = UIImageView()
    private let assetNameLabel = UILabel()
    private let deleteAssetButton = UIButton()
//MARK: - init()
    override init(frame: CGRect) {
        super.init(frame: .zero)
        self.setupLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//MARK: - prepareForReuse
    override func prepareForReuse() {
        super.prepareForReuse()
        self.assetImageView.image = nil
    }
    
//MARK: - internal method
    func set(assetModel: SavedModel.LoadAssets.AssetModel?) {
        let assetImageData = assetModel?.assetImage ?? Data()
        let assetImage = UIImage(data: assetImageData) ?? UIImage()
        
        self.assetImageView.image = assetImage
        self.assetNameLabel.text = assetModel?.assetName
    }
}

//MARK: - private methods
private extension SavedCollectionViewCell {
    func setupLayout() {
        self.setupContainerViewLayout()
        self.setupAssetImageViewLayout()
        self.setupAssetNameLabelLayout()
        self.setupDislikeButtonLayout()
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
    
    func setupAssetImageViewLayout() {
        self.containerView.addSubview(self.assetImageView)
        self.configureAssetImageView()
        NSLayoutConstraint.activate([
            self.assetImageView.topAnchor.constraint(equalTo: self.containerView.topAnchor, constant: Constraint.assetImageViewTopOffset),
            self.assetImageView.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor, constant: Constraint.cellHorizontalInset),
            self.assetImageView.trailingAnchor.constraint(equalTo: self.containerView.trailingAnchor, constant: -Constraint.cellHorizontalInset),
        ])
    }
    
    func configureAssetImageView() {
        self.assetImageView.setContentHuggingPriority(.defaultLow, for: .vertical)
        self.assetImageView.translatesAutoresizingMaskIntoConstraints = false
        self.assetImageView.layer.cornerRadius = Constant.cornerRadius
        self.assetImageView.layer.masksToBounds = true
        self.assetImageView.contentMode = .scaleAspectFill
    }
    
    func setupAssetNameLabelLayout() {
        self.containerView.addSubview(self.assetNameLabel)
        self.configureAssetNameLabel()
        NSLayoutConstraint.activate([
            self.assetNameLabel.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor, constant: Constraint.cellHorizontalInset),
            self.assetNameLabel.bottomAnchor.constraint(equalTo: self.containerView.bottomAnchor, constant: -Constraint.assetNameLabelVerticalOffset),
        ])
    }
    
    func configureAssetNameLabel() {
        self.assetNameLabel.translatesAutoresizingMaskIntoConstraints = false
        self.assetNameLabel.font = Typography.TextLG.medium.font
        self.assetNameLabel.adjustsFontSizeToFitWidth = true
        self.assetNameLabel.minimumScaleFactor = 0.4
    }
    
    func setupDislikeButtonLayout() {
        self.containerView.addSubview(self.deleteAssetButton)
        self.configureDeleteAssetButton()
        deleteAssetButton.setContentHuggingPriority(.defaultHigh, for: .vertical)
        NSLayoutConstraint.activate([
            self.deleteAssetButton.topAnchor.constraint(equalTo: assetImageView.bottomAnchor, constant: Constraint.deleteAssetButtonTopOffset),
            self.deleteAssetButton.leadingAnchor.constraint(equalTo: self.assetNameLabel.trailingAnchor, constant: Constraint.deleteAssetButtonLeadingOffset),
            self.deleteAssetButton.bottomAnchor.constraint(equalTo: self.containerView.bottomAnchor, constant: -Constraint.deleteAssetButtonBottomOffset),
            self.deleteAssetButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -Constraint.cellHorizontalInset),
            self.deleteAssetButton.widthAnchor.constraint(equalToConstant: Constraint.deleteAssetButtonSize),
            self.deleteAssetButton.heightAnchor.constraint(equalToConstant: Constraint.deleteAssetButtonSize)
        ])
    }
    
    func configureContainerView() {
        self.containerView.translatesAutoresizingMaskIntoConstraints = false
        self.containerView.layer.cornerRadius = Constant.cornerRadius
        self.containerView.layer.borderColor = Color.black.tone.withAlphaComponent(Constant.borderAlphaComponent).cgColor
        self.containerView.layer.borderWidth = Constant.borderWidth
    }
    
    func configureDeleteAssetButton() {
        self.deleteAssetButton.translatesAutoresizingMaskIntoConstraints = false
        let blackImage = UIImage(named: "trash.circle")?.withTintColor(Color.black.tone)
        let grayImage = UIImage(named: "trash.circle")?.withTintColor(Color.gray.tone)

        self.deleteAssetButton.setImage(blackImage, for: .normal)
        self.deleteAssetButton.setImage(grayImage, for: .highlighted)
        
        self.deleteAssetButton.addTarget(self, action: #selector(deleteAsset), for: .touchUpInside)
    }
    
    @objc func deleteAsset() {
        self.onDeleteButtonTappedHandler?()
    }
}
