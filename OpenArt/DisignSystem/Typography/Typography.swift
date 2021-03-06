//
//  Typography.swift
//  OpenArt
//
//  Created by Иван Дурмашев on 13.06.2022.
//

import UIKit

enum Typography {
//MARK: - DisplayXS
    enum DisplayXS {
        case semiBold
        
        var font: UIFont? {
            switch self {
            case .semiBold:
                return UIFont(name: "Archivo-SemiBold", size: 24)
            }
        }
    }
//MARK: - TextLG
    enum TextLG {
        case medium
        
        var font: UIFont? {
            switch self {
            case .medium:
                return UIFont(name: "Archivo-Medium", size: 18)
            }
        }
    }
//MARK: - TextMD
    enum TextMD {
        case regular
        
        var font: UIFont? {
            switch self {
            case .regular:
                return UIFont(name: "Archivo-Regular", size: 16)
            }
        }
    }
}
