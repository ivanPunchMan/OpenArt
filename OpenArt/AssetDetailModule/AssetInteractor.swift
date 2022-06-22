//
//  AssetInteractor.swift
//  OpenArt
//
//  Created by Иван Дурмашев on 15.06.2022.
//

import Foundation

protocol IAssetInteractor: AnyObject {
    var asset: Asset? { get set }
    func save(data: AssetModel.SaveAsset.Request)
    func fetchAssetInfo(request: AssetModel.FetchAssetInfo.Request)
    func fetchAssetImage(request: AssetModel.FetchAssetImage.Request)
    func fetchCollectionImage(request: AssetModel.FetchCollectionImage.Request)
}

protocol IAssetDataStore: AnyObject {
    var asset: Asset? { get set }
}

final class AssetInteractor: IAssetDataStore {
//MARK: - properties
    var asset: Asset?
    private var presenter: IAssetPresenter
    private var networkWorker: IImageNetworkWorker
    private var dataStorageWorker: IDataStorageSaveWorker
    
//MARK: - init
    init(presenter: IAssetPresenter, networkWorker: IImageNetworkWorker, dataStorageWorker: IDataStorageSaveWorker) {
        self.presenter = presenter
        self.networkWorker = networkWorker
        self.dataStorageWorker = dataStorageWorker
    }
}

//MARK: - IAssetInteractor
extension AssetInteractor: IAssetInteractor {
    func fetchAssetInfo(request: AssetModel.FetchAssetInfo.Request) {
        let assetName = asset?.name
        let assetDescription = asset?.description
        let collectionName = asset?.collection?.name
        
        self.presenter.presentAssetInfo(response: .init(assetName: assetName, assetDescription: assetDescription, collectionName: collectionName))
    }
    
    func fetchAssetImage(request: AssetModel.FetchAssetImage.Request) {
        networkWorker.fetchImage(from: asset?.imageURL) { [weak self] result in
            switch result {
            case .success(let data):
                self?.presenter.presentAssetImage(response: .init(assetImageData: data))
            case .failure(let error):
                self?.presenter.presentAssetImage(response: .init(assetImageData: nil))
                print(error.localizedDescription)
            }
        }
    }
    
    func fetchCollectionImage(request: AssetModel.FetchCollectionImage.Request) {
        networkWorker.fetchImage(from: asset?.collection?.imageURL) { [weak self] result in
            switch result {
            case .success(let data):
                self?.presenter.presentCollectionImage(response: .init(collectionImageData: data))
            case .failure(let error):
                self?.presenter.presentCollectionImage(response: .init(collectionImageData: nil))
                print(error.localizedDescription)
            }
        }
    }
    
    func save(data: AssetModel.SaveAsset.Request) {
//        self.dataStorageWorker.save(data: data)
    }
}
