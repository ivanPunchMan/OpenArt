//
//  HomeCollectionViewDelegate.swift
//  OpenArt
//
//  Created by Иван Дурмашев on 24.06.2022.
//

import Foundation
import UIKit

final class HomeCollectionViewDelegate: NSObject {
    var assetAt: ((IndexPath) -> HomeModel.FetchAssets.AssetViewModel?)?
    var didSelectItem: ((AssetDataStoreModel) -> Void)?
    var fetchImagesForCellHandler: ((HomeModel.FetchAssetImage.Request) -> Void)?
}

extension HomeCollectionViewDelegate: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let asset = assetAt?(indexPath)
        let cell = collectionView.cellForItem(at: indexPath) as? HomeCollectionViewCell
        
        self.didSelectItem?(.init(tokenID: asset?.tokenID,
                                  assetName: asset?.assetName,
                                  assetImageData: cell?.assetImage?.pngData(),
                                  assetDescription: asset?.assetDescription,
                                  collectionName: asset?.collectionName,
                                  collectionImageData: cell?.collectionImage?.pngData()))
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        self.fetchImagesForCellHandler?(.init(indexPath: indexPath))
    }
}
