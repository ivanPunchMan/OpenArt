//
//  CustomButton.swift
//  OpenArt
//
//  Created by Иван Дурмашев on 19.06.2022.
//

import Foundation
import UIKit

class CustomButton: UIButton {
//MARK: - private enums
    private enum Constant {
        static let conrnerRadius: CGFloat = 8
    }
    
    private enum Constraint {
        static let edgesInset: CGFloat = 16
    }

//MARK: - properties
    var isActiveState = true
    private var label = UILabel()
    
//MARK: - init
    init(text: String) {
        super.init(frame: .zero)
        self.label.text = text
        self.configureView()
        self.setupLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

//MARK: - internal methods
    func stateSwitch() {
        if isActiveState {
            self.label.textColor = .white
            self.backgroundColor = Color.primary.tone
            self.isActiveState = false
        } else {
            self.label.textColor = Color.black.tone.withAlphaComponent(0.4)
            self.backgroundColor = .white
            self.isActiveState = true
        }
    }
}

//MARK: - private methods
private extension CustomButton {
    func configureView() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = Color.primary.tone
        self.layer.cornerRadius = Constant.conrnerRadius
        self.layer.borderWidth = 1
        self.layer.borderColor = Color.black.tone.withAlphaComponent(0.08).cgColor
    }
    
    func setupLayout() {
        self.addSubview(self.label)
        self.configureLabel()
        NSLayoutConstraint.activate([
            self.label.topAnchor.constraint(equalTo: self.topAnchor, constant: Constraint.edgesInset),
            self.label.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: Constraint.edgesInset),
            self.label.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -Constraint.edgesInset),
            self.label.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -Constraint.edgesInset),
        ])
    }
    
    func configureLabel() {
        self.label.translatesAutoresizingMaskIntoConstraints = false
        self.label.textAlignment = .center
        self.label.font = Typography.TextLG.medium.font
        self.label.textColor = .white
    }
}
