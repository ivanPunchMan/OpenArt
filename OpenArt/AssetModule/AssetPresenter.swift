//
//  AssetPresenter.swift
//  OpenArt
//
//  Created by Иван Дурмашев on 15.06.2022.
//

import UIKit

protocol IAssetPresenter: AnyObject {
    func presentAssetInfo(response: AssetModel.FetchAssetInfo.Response)
    func presentAssetImage(response: AssetModel.FetchAssetImage.Response)
    func presentCollectionImage(response: AssetModel.FetchCollectionImage.Response)
}

final class AssetPresenter {
    weak var vc: IAssetViewController?
}

//MARK: - IAssetPresenter
extension AssetPresenter: IAssetPresenter {
    func presentAssetInfo(response: AssetModel.FetchAssetInfo.Response) {
        self.vc?.displayAssetInfo(viewModel: .init(assetName: response.assetName,
                                              assetDescription: response.assetDescription,
                                              collectionName: response.collectionName))
    }
    
    func presentAssetImage(response: AssetModel.FetchAssetImage.Response) {
        let assetImage = UIImage(data: response.assetImageData ?? Data())
        self.vc?.displayAssetImage(viewModel: .init(assetImage: assetImage))
    }
    
    func presentCollectionImage(response: AssetModel.FetchCollectionImage.Response) {
        let collectionImage = UIImage(data: response.collectionImageData ?? Data())
        self.vc?.displayCollectionImage(viewModel: .init(collectionImage: collectionImage))
    }
}
