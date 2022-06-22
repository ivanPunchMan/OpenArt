//
//  LikedAssetCell.swift
//  OpenArt
//
//  Created by Иван Дурмашев on 20.06.2022.
//

import Foundation
import UIKit

final class LikedAssetCell: UICollectionViewCell {
    static let id = String(describing: LikedAssetCell.self)
    
    private enum Constant {
        static let cornerRadius: CGFloat = 8
        static let borderAlphaComponent: CGFloat = 0.08
        static let borderWidth: CGFloat = 1
    }
    
    private enum Constraint {
        static let cellHorizontalInset: CGFloat = 7
        
        static let assetImageViewTopOffset: CGFloat = 8
        
        static let assetNameLabelVerticalOffset: CGFloat = 11
        
        static let deleteAssetButtonSize: CGFloat = 24
    }
    
//MARK: - properties
    var onDeleteButtonTappedHandler: (() -> Void)?
    private let containerView = UIView()
    private let assetImageView = ResizingImageView()
    private let assetNameLabel = UILabel()
    private let deleteAssetButton = UIButton()
    private var uniqueID = ""
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
    
//MARK: - internal methods
    
    func set(assetModel: LikedModel.LoadAssets.AssetModel?) {
        let assetImageData = assetModel?.assetImage ?? Data()
        let assetImage = UIImage(data: assetImageData) ?? UIImage()
        
//        self.uniqueID = assetModel?.uniqueID
        self.assetImageView.setImageAndUpdateAspectRatio(image: assetImage)
        self.assetNameLabel.text = assetModel?.assetName
    }
    
    func set(assetImage: UIImage?) {
        self.assetImageView.setImageAndUpdateAspectRatio(image: assetImage ?? UIImage())
    }
    
    func set(assetName: String?) {
        self.assetNameLabel.text = assetName
    }
}

//MARK: - private methods
private extension LikedAssetCell {
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
    
    func setupAssetNameLabelLayout() {
        self.containerView.addSubview(self.assetNameLabel)
        self.configureAssetNameLabel()
        let topConstraint = self.assetNameLabel.topAnchor.constraint(equalTo: self.assetImageView.bottomAnchor, constant: Constraint.assetNameLabelVerticalOffset)
        topConstraint.priority = UILayoutPriority(1000)
        topConstraint.isActive = true
        NSLayoutConstraint.activate([
            self.assetNameLabel.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor, constant: Constraint.cellHorizontalInset),
            self.assetNameLabel.bottomAnchor.constraint(equalTo: self.containerView.bottomAnchor, constant: -Constraint.assetNameLabelVerticalOffset),
//            self.assetNameLabel.trailingAnchor.constraint(equalTo: self.containerView.trailingAnchor, constant: -Constraint.cellHorizontalInset)
        ])
    }
    
    func setupDislikeButtonLayout() {
        self.containerView.addSubview(self.deleteAssetButton)
        self.configureDeleteAssetButton()
        deleteAssetButton.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        NSLayoutConstraint.activate([
            self.deleteAssetButton.centerYAnchor.constraint(equalTo: self.assetNameLabel.centerYAnchor),
            self.deleteAssetButton.leadingAnchor.constraint(equalTo: self.assetNameLabel.trailingAnchor),
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
    
    func configureAssetImageView() {
        self.assetImageView.translatesAutoresizingMaskIntoConstraints = false
        self.assetImageView.layer.cornerRadius = Constant.cornerRadius
        self.assetImageView.layer.masksToBounds = true
        self.assetImageView.contentMode = .scaleAspectFill

//        self.assetImageView.setImageAndUpdateAspectRatio(image: UIImage(named: "testImage")!)
    }
    
    func configureAssetNameLabel() {
        self.assetNameLabel.translatesAutoresizingMaskIntoConstraints = false
        self.assetNameLabel.font = Typography.TextLG.medium.font
        self.assetNameLabel.text = "Blabla bla-bla"
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
