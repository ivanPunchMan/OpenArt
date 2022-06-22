//
//  HomePresenter.swift
//  OpenArt
//
//  Created by Иван Дурмашев on 13.06.2022.
//

import Foundation
import UIKit

protocol IHomePresenter: AnyObject {
    func presentAssets(response: HomeModel.FetchAssets.Response)
    func presentAssetImage(response: HomeModel.FetchAssetImage.Response)
    func presentCollectionImage(response: HomeModel.FetchCollectionImage.Response)
}

final class HomePresenter {
    weak var vc: IHomeViewController?
}

extension HomePresenter: IHomePresenter {
    func presentAssets(response: HomeModel.FetchAssets.Response) {
        let nextPage = response.nextPage
        let assetViewModels = response.assets.map { HomeModel.FetchAssets.AssetViewModel(from: $0) }
        vc?.displayAssets(viewModel: .init(nextPage: nextPage, assets: assetViewModels))
    }
    
    func presentImage(response: HomeModel.FetchCollectionImage.Response) {
        
    }
    
    func presentAssetImage(response: HomeModel.FetchAssetImage.Response) {
        let userImage = UIImage(data: response.assetImageData ?? Data())
        vc?.displayAssetImage(viewModel: .init(assetImage: userImage, indexPath: response.indexPath))
    }
    
    func presentCollectionImage(response: HomeModel.FetchCollectionImage.Response) {
        let userImage = UIImage(data: response.collectionImageData ?? Data())
        vc?.displayCollectionImage(viewModel: .init(collectionImage: userImage, indexPath: response.indexPath))
    }
}
