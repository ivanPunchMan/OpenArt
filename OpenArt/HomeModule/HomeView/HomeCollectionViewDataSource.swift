//
//  HomeCollectionViewDataSource.swift
//  OpenArt
//
//  Created by Иван Дурмашев on 24.06.2022.
//

import Foundation
import UIKit

final class HomeCollectionViewDataSource: NSObject {
    var nextPage = ""
    var assetsViewModel = [HomeModel.FetchAssets.AssetViewModel]()
    var fetchAssetsHandler: ((HomeModel.FetchAssets.Request) -> Void)?
    var saveAssetButtonTappedHandler: ((HomeModel.SaveAsset.Request) -> Void)?
}

//MARK: - UICollectionViewDataSource
extension HomeCollectionViewDataSource: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.assetsViewModel.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeCollectionViewCell.id, for: indexPath) as? HomeCollectionViewCell,
                self.assetsViewModel.indices.contains(indexPath.row)
        else { return UICollectionViewCell() }
        
        let asset = self.assetsViewModel[indexPath.row]
        
        
        
        cell.set(collectionName: asset.collectionName)
        
        cell.saveButtonTappedHandler = { [weak self] in
            self?.saveAssetButtonTappedHandler?(.init(tokenID: asset.tokenID,
                                                      assetName: asset.assetName,
                                                      assetImage: cell.assetImage,
                                                      assetDescription: asset.assetDescription,
                                                      collectionName: asset.collectionName,
                                                      collectionImage: cell.collectionImage))
        }
        
        return cell
    }
}

//MARK: - UICollectionViewDataSourcePrefetching
extension HomeCollectionViewDataSource: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        let indexPath = indexPaths.first
        
        if (self.assetsViewModel.count - 5) == indexPath?.row {
            self.fetchAssetsHandler?(.init(nextPage: self.nextPage))
        }
    }
}
