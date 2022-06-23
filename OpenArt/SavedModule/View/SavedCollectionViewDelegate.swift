//
//  SavedCollectionViewDelegate.swift
//  OpenArt
//
//  Created by Иван Дурмашев on 24.06.2022.
//

import Foundation
import UIKit

final class SavedCollectionViewDelegate: NSObject {
    var didSelectItemAt: ((IndexPath) -> Void)?
}

//MARK: - UICollectionViewDelegate
extension SavedCollectionViewDelegate: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.didSelectItemAt?(indexPath)
    }
}
