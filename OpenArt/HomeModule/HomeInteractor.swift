//
//  HomeInteractor.swift
//  OpenArt
//
//  Created by Иван Дурмашев on 13.06.2022.
//

import Foundation
import UIKit

protocol IHomeInteractor: AnyObject {
    func fetchAssets(request: HomeModel.FetchAssets.Request)
    func fetchImagesForCell(request: HomeModel.FetchAssetImage.Request)
}

protocol IHomeDataStore: AnyObject {
    var assets: [Asset] { get set }
}

final class HomeInteractor: IHomeDataStore {
    var assets = [Asset]()
    
    private var presenter: IHomePresenter
    private var networkWorker: (IAssetsNetworkWorker & IImageNetworkWorker)
    private var next: String?
    
    
    init(presenter: IHomePresenter, networkWorker: (IAssetsNetworkWorker & IImageNetworkWorker)) {
        self.presenter = presenter
        self.networkWorker = networkWorker
    }
}

extension HomeInteractor: IHomeInteractor {
    func fetchAssets(request: HomeModel.FetchAssets.Request) {
        let nextPage = request.nextPage
        networkWorker.fetchAssets(nextPage: nextPage) { [weak self] result in
            switch result {
            case .success(let assetsDTO):
                let assetsResponse = HomeModel.FetchAssets.Response.init(from: assetsDTO)
                self?.assets = assetsResponse.assets
                self?.presenter.presentAssets(response: assetsResponse)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func fetchAssets(response: HomeModel.FetchAssets.Response) {
        self.presenter.presentAssets(response: response)
    }
    
    func fetchImagesForCell(request: HomeModel.FetchAssetImage.Request) {
        let urlAsset = assets[request.indexPath.row].imageURL
        let urlCollection = assets[request.indexPath.row].collection?.imageURL
        
        self.fetchAssetImage(from: urlAsset, for: request.indexPath)
        self.fetchCollectionImage(from: urlCollection, for: request.indexPath)
    }
}

private extension HomeInteractor {
    func fetchAssetImage(from url: String?, for indexPath: IndexPath) {
        networkWorker.fetchImage(from: url) { [weak self] result in
            switch result {
            case .success(let data):
                self?.presenter.presentAssetImage(response: .init(assetImageData: data, indexPath: indexPath))
            case .failure(let error):
                self?.presenter.presentAssetImage(response: .init(assetImageData: nil, indexPath: indexPath))
                print(error.localizedDescription)
            }
        }
    }
    
    func fetchCollectionImage(from url: String?, for indexPath: IndexPath) {
        networkWorker.fetchImage(from: url) { [weak self] result in
            switch result {
            case .success(let data):
                self?.presenter.presentCollectionImage(response: .init(collectionImageData: data, indexPath: indexPath))
            case .failure(let error):
                self?.presenter.presentCollectionImage(response: .init(collectionImageData: nil, indexPath: indexPath))
                print(error.localizedDescription)
            }
        }
    }
}
