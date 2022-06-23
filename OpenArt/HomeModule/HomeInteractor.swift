//
//  HomeInteractor.swift
//  OpenArt
//
//  Created by Иван Дурмашев on 13.06.2022.
//

import Foundation

protocol IHomeInteractor: AnyObject {
    func selectAsset(request: HomeModel.SelectAsset.Request)
    func saveAsset(request: HomeModel.SaveAsset.Request)
    func fetchAssets(request: HomeModel.FetchAssets.Request)
    func fetchImagesForCell(request: HomeModel.FetchAssetImage.Request)
}

protocol IHomeDataStore: AnyObject {
    var assets: [Asset] { get set }
    var asset: AssetDataProviderModel? { get set }
}

final class HomeInteractor: IHomeDataStore {
//MARK: - properties
    var assets = [Asset]()
    var asset: AssetDataProviderModel?
    
    private var presenter: IHomePresenter
    private var networkWorker: (IAssetsNetworkWorker & IImageNetworkWorker)
    private var dataStorageWorker: IDataStorageSaveWorker
    private var next: String?
    
//MARK: - init
    init(presenter: IHomePresenter, networkWorker: (IAssetsNetworkWorker & IImageNetworkWorker), dataStorageWorker: IDataStorageSaveWorker) {
        self.presenter = presenter
        self.networkWorker = networkWorker
        self.dataStorageWorker = dataStorageWorker
    }
}

//MARK: - IHomeInteractor
extension HomeInteractor: IHomeInteractor {
    
    func selectAsset(request: HomeModel.SelectAsset.Request) {
        self.asset = request.asset
    }
    
    func saveAsset(request: HomeModel.SaveAsset.Request) {
        let tokenID = request.tokenID
        let assetName = request.assetName
        let assetImageData = request.assetImage?.pngData()
        let assetDescription = request.assetDescription
        let collectionName = request.collectionName
        let collectionImageData = request.collectionImage?.pngData()
        
        let assetSaveDataModel = AssetDataProviderModel(tokenID: tokenID,
                                                    assetName: assetName,
                                                    assetImageData: assetImageData,
                                                    assetDescription: assetDescription,
                                                    collectionName: collectionName,
                                                    collectionImageData: collectionImageData)
        
        dataStorageWorker.save(data: assetSaveDataModel)
    }
    
    func fetchAssets(request: HomeModel.FetchAssets.Request) {
        let nextPage = request.nextPage
        networkWorker.fetchAssets(nextPage: nextPage) { [weak self] result in
            switch result {
            case .success(let assetsDTO):
                let assetsResponse = HomeModel.FetchAssets.Response(from: assetsDTO)
                self?.assets += assetsResponse.assets
                self?.presenter.presentAssets(response: assetsResponse)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func fetchImagesForCell(request: HomeModel.FetchAssetImage.Request) {
        let urlAsset = assets[request.indexPath.row].imageURL
        let urlCollection = assets[request.indexPath.row].collection?.imageURL
        
        self.fetchAssetImage(from: urlAsset, for: request.indexPath)
        self.fetchCollectionImage(from: urlCollection, for: request.indexPath)
    }
}

//MARK: - private methods
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
