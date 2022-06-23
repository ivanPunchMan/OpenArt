//
//  HomeInteractor.swift
//  OpenArt
//
//  Created by Иван Дурмашев on 13.06.2022.
//

import Foundation

protocol IHomeInteractor: AnyObject {
    func selectAsset(_ request: HomeModel.SelectAsset.Request)
    func saveAsset(_ request: HomeModel.SaveAsset.Request)
    func fetchAssets(_ request: HomeModel.FetchAssets.Request)
    func fetchImagesForCell(_ request: HomeModel.FetchAssetImage.Request)
}

protocol IHomeDataStore: AnyObject {
    var assetDataStore: AssetDataStoreModel? { get set }
}

final class HomeInteractor: IHomeDataStore {
//MARK: - properties
    var assets = [Asset]()
    var assetDataStore: AssetDataStoreModel?
    
    private var presenter: IHomePresenter
    private var networkWorker: (IAssetsNetworkWorker & IImageNetworkWorker)
    private var dataStorageWorker: IDataStorageSaveWorker
    private var next: String?
    
//MARK: - init
    init(_ presenter: IHomePresenter,_  networkWorker: (IAssetsNetworkWorker & IImageNetworkWorker),_  dataStorageWorker: IDataStorageSaveWorker) {
        self.presenter = presenter
        self.networkWorker = networkWorker
        self.dataStorageWorker = dataStorageWorker
    }
}

//MARK: - IHomeInteractor
extension HomeInteractor: IHomeInteractor {
    func selectAsset(_ request: HomeModel.SelectAsset.Request) {
        self.assetDataStore = request.asset
    }
    
    func saveAsset(_ request: HomeModel.SaveAsset.Request) {
        let assetSaveDataModel = AssetDataStoreModel(tokenID: request.tokenID,
                                                        assetName: request.assetName,
                                                        assetImageData: request.assetImage?.pngData(),
                                                        assetDescription: request.assetDescription,
                                                        collectionName: request.collectionName,
                                                        collectionImageData: request.collectionImage?.pngData())
        
        self.dataStorageWorker.save(data: assetSaveDataModel)
    }
    
    func fetchAssets(_ request: HomeModel.FetchAssets.Request) {
        let nextPage = request.nextPage
        self.networkWorker.fetchAssets(nextPage: nextPage) { [weak self] result in
            switch result {
            case .success(let assetsDTO):
                let assetsResponse = HomeModel.FetchAssets.Response(from: assetsDTO)
                self?.assets += assetsResponse.assets
                self?.presenter.presentAssets(assetsResponse)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func fetchImagesForCell(_ request: HomeModel.FetchAssetImage.Request) {
        let urlAsset = assets[request.indexPath.row].imageURL
        let urlCollection = assets[request.indexPath.row].collection?.imageURL
        
        self.fetchAssetImage(from: urlAsset, for: request.indexPath)
        self.fetchCollectionImage(from: urlCollection, for: request.indexPath)
    }
}

//MARK: - private methods
private extension HomeInteractor {
    func fetchAssetImage(from url: String?, for indexPath: IndexPath) {
        self.networkWorker.fetchImage(from: url) { [weak self] result in
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
        self.networkWorker.fetchImage(from: url) { [weak self] result in
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
