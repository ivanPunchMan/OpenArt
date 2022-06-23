//
//  SavedCollectionViewDataSource.swift
//  OpenArt
//
//  Created by Иван Дурмашев on 24.06.2022.
//

import Foundation
import UIKit

final class SavedCollectionViewDataSource: NSObject {
    var assetsViewModel = [SavedModel.LoadAssets.AssetModel]() {
        didSet {
            self.reloadDataHandler?()
        }
    }
    var deleleAssetHandler: ((String) -> Void)?
    var reloadDataHandler: (() -> Void)?
}

//MARK: - UICollectionViewDataSource
extension SavedCollectionViewDataSource: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.assetsViewModel.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SavedCollectionViewCell.id, for: indexPath) as? SavedCollectionViewCell, assetsViewModel.indices.contains(indexPath.row)
        else { return UICollectionViewCell() }
        
        let asset = assetsViewModel[indexPath.row]

        cell.set(assetModel: asset)
        
        cell.onDeleteButtonTappedHandler = { [weak self] in
            if let tokenID = asset.tokenID {
                self?.deleleAssetHandler?(tokenID)
                self?.assetsViewModel.remove(at: indexPath.row)
            }
        }
        
        return cell
    }
}
