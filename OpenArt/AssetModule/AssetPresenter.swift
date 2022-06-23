//
//  AssetPresenter.swift
//  OpenArt
//
//  Created by Иван Дурмашев on 15.06.2022.
//

import UIKit

protocol IAssetPresenter: AnyObject {
    func presentAssetData(response: AssetModel.FetchAssetData.Response)
}

final class AssetPresenter {
    weak var vc: IAssetViewController?
}

//MARK: - IAssetPresenter
extension AssetPresenter: IAssetPresenter {
    func presentAssetData(response: AssetModel.FetchAssetData.Response) {
        let assetImage = UIImage(data: response.assetImageData ?? Data())
        let collectionImage = UIImage(data: response.collectionImageData ?? Data())
        
        self.vc?.displayAssetData(viewModel: .init(assetImage: assetImage,
                                                   collectionImage: collectionImage,
                                                   assetName: response.assetName,
                                                   assetDescription: response.assetDescription,
                                                   collectionName: response.collectionName))
    }
}
