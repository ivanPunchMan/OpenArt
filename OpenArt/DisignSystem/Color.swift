//
//  Color.swift
//  OpenArt
//
//  Created by Иван Дурмашев on 13.06.2022.
//

import UIKit

enum Color {
    case white
    case black
    case primary
    case gray
    
    var tone: UIColor {
        switch self {
        case .white:
            return UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        case .black:
            return UIColor(red: 0.067, green: 0.075, blue: 0.082, alpha: 1)
        case .primary:
            return UIColor(red: 0.133, green: 0.204, blue: 0.812, alpha: 1)
        case .gray:
            return UIColor(red: 0.596, green: 0.635, blue: 0.702, alpha: 1)
        }
    }
}
