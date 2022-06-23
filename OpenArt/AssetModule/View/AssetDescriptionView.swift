//
//  AssetDescriptionView.swift
//  OpenArt
//
//  Created by Иван Дурмашев on 15.06.2022.
//

import Foundation
import UIKit

final class AssetDescriptionView: UIView {
//MARK: - private enums
    private enum Constant {
        static let descriptionLabelTextColorAlphaComponent: CGFloat = 0.5
        static let descriptionLabelLineHeightMultiple: CGFloat = 1.26
    }
    
    private enum Constraint {
        static let descriptionLabelTopOffset: CGFloat = 16
    }
    
//MARK: - properties
    private let assetNameLabel = UILabel()
    private let assetDescriptionLabel = UILabel()
    
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
    func set(title: String?) {
        self.assetNameLabel.text = title
    }
    
    func set(description: String?) {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = Constant.descriptionLabelLineHeightMultiple
        self.assetDescriptionLabel.attributedText = NSAttributedString(string: description ?? "",
                                                                       attributes: [NSAttributedString.Key.paragraphStyle : paragraphStyle])
    }
    
    func assetName() -> String? {
        self.assetNameLabel.text
    }
    
    func assetDescription() -> String? {
        self.assetDescriptionLabel.text
    }
}

//MARK: - private methods
private extension AssetDescriptionView {
    func setupLayout() {
        self.setupTitleLabelLayout()
        self.setupDescriptionLabelLayout()
    }
    
    func setupTitleLabelLayout() {
        self.addSubview(self.assetNameLabel)
        self.configureTitleLabel()
        NSLayoutConstraint.activate([
            self.assetNameLabel.topAnchor.constraint(equalTo: self.topAnchor),
            self.assetNameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.assetNameLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
    }
    
    func configureTitleLabel() {
        self.assetNameLabel.translatesAutoresizingMaskIntoConstraints = false
        self.assetNameLabel.font = Typography.TextLG.medium.font
        self.assetNameLabel.textAlignment = .left
        self.assetNameLabel.textColor = Color.black.tone
        self.assetNameLabel.adjustsFontSizeToFitWidth = true
        self.assetNameLabel.minimumScaleFactor = 0.4
    }
    
    func setupDescriptionLabelLayout() {
        self.addSubview(self.assetDescriptionLabel)
        self.configureDescriptionLabel()
        NSLayoutConstraint.activate([
            self.assetDescriptionLabel.topAnchor.constraint(equalTo: self.assetNameLabel.bottomAnchor, constant: Constraint.descriptionLabelTopOffset),
            self.assetDescriptionLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.assetDescriptionLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.assetDescriptionLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
    }
    
    func configureDescriptionLabel() {
        self.assetDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        self.assetDescriptionLabel.numberOfLines = 0
        self.assetDescriptionLabel.font = Typography.TextMD.regular.font
        self.assetDescriptionLabel.textColor = Color.black.tone.withAlphaComponent(Constant.descriptionLabelTextColorAlphaComponent)
        self.assetDescriptionLabel.lineBreakMode = .byWordWrapping
    }
}
