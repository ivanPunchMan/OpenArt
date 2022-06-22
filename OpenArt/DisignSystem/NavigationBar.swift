//
//  NavigationBar.swift
//  OpenArt
//
//  Created by Иван Дурмашев on 22.06.2022.
//

import Foundation
import UIKit

class NavigationBar: UIView {
    
    let newButton = LikedButton(text: "New")
    let savedButton = LikedButton(text: "Saved")
    
    init() {
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.setupLayout()
        
        if newButton.isActiveState {
            savedButton.stateSwitch()
        } else {
            newButton.stateSwitch()
        }
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension NavigationBar {
    
    func setupLayout() {
        self.setupNewButtonLayout()
        self.setupSavedButtonLayout()
    }
    
    func setupNewButtonLayout() {
        self.addSubview(self.newButton)
        NSLayoutConstraint.activate([
            self.newButton.topAnchor.constraint(equalTo: self.topAnchor),
            self.newButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 2),
            self.newButton.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    func setupSavedButtonLayout() {
        self.addSubview(self.savedButton)
        NSLayoutConstraint.activate([
            self.savedButton.topAnchor.constraint(equalTo: self.topAnchor),
            self.savedButton.leadingAnchor.constraint(equalTo: self.newButton.trailingAnchor, constant: 8),
            self.savedButton.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.savedButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -2),
            self.savedButton.widthAnchor.constraint(equalTo: self.newButton.widthAnchor)
        ])
    }
}
