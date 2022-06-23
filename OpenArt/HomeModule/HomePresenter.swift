//
//  HomePresenter.swift
//  OpenArt
//
//  Created by Иван Дурмашев on 13.06.2022.
//

import Foundation
import UIKit

protocol IHomePresenter: AnyObject {
    func presentAssets(_ response: HomeModel.FetchAssets.Response)
    func presentAssetImage(response: HomeModel.FetchAssetImage.Response)
    func presentCollectionImage(response: HomeModel.FetchCollectionImage.Response)
}

final class HomePresenter {
    weak var vc: IHomeViewController?
}

//MARK: - IHomePresenter
extension HomePresenter: IHomePresenter {
    func presentAssets(_ response: HomeModel.FetchAssets.Response) {
        let nextPage = response.nextPage
        let assetViewModels = response.assets.map { HomeModel.FetchAssets.AssetViewModel(from: $0) }
        self.vc?.displayAssets(viewModel: .init(nextPage: nextPage, assets: assetViewModels))
    }
    
    func presentAssetImage(response: HomeModel.FetchAssetImage.Response) {
        let userImage = UIImage(data: response.assetImageData ?? Data())
        self.vc?.displayAssetImage(viewModel: .init(assetImage: userImage, indexPath: response.indexPath))
    }
    
    func presentCollectionImage(response: HomeModel.FetchCollectionImage.Response) {
        let userImage = UIImage(data: response.collectionImageData ?? Data())
        self.vc?.displayCollectionImage(viewModel: .init(collectionImage: userImage, indexPath: response.indexPath))
    }
}
