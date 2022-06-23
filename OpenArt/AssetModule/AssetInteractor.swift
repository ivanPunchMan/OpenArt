//
//  AssetInteractor.swift
//  OpenArt
//
//  Created by Иван Дурмашев on 15.06.2022.
//

import Foundation

protocol IAssetInteractor: AnyObject {
    func fetchAssetData(request: AssetModel.FetchAssetData.Request)
}

protocol IAssetDataStore: AnyObject {
    var asset: Asset? { get set }
    var assetDataStore: AssetDataProviderModel? { get set }
}

//MARK: - IAssetDataStore
final class AssetInteractor: IAssetDataStore {
//MARK: - properties
    var asset: Asset?
    var assetDataStore: AssetDataProviderModel?
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
    func fetchAssetData(request: AssetModel.FetchAssetData.Request) {
        self.presenter.presentAssetData(response: .init(assetImageData: self.assetDataStore?.assetImageData,
                                                        collectionImageData: self.assetDataStore?.collectionImageData,
                                                        assetName: self.assetDataStore?.assetName,
                                                        assetDescription: self.assetDataStore?.assetDescription,
                                                        collectionName: self.assetDataStore?.collectionName))
    }
}
