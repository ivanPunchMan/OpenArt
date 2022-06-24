//
//  SavedInteractor.swift
//  OpenArt
//
//  Created by Иван Дурмашев on 20.06.2022.
//

import Foundation

protocol ISavedInteractor: AnyObject {
    func selectAsset(request: SavedModel.SelectAsset.Request)
    func deleteAsset(request: SavedModel.DeleteAsset.Request)
    func loadAssets(request: SavedModel.LoadAssets.Request)
}

protocol ISavedDataStore: AnyObject {
    var assetDataStore: AssetDataStoreModel? { get set }
}

//MARK: - ISavedDataStore
final class SavedInteractor: ISavedDataStore {
    var assetDataStore: AssetDataStoreModel?
    
    private var presenter: ISavedPresenter?
    private var dataStorageWorker: (IDataStorageLoadWorker & IDataStorageDeleteWorker)
    private var assets = [SavedModel.LoadAssets.AssetModel]()
    
    init(_ presenter: ISavedPresenter, _ dataStorageWorker: (IDataStorageLoadWorker & IDataStorageDeleteWorker)) {
        self.presenter = presenter
        self.dataStorageWorker = dataStorageWorker
    }
}

//MARK: - ISavedInteractor
extension SavedInteractor: ISavedInteractor {
    func selectAsset(request: SavedModel.SelectAsset.Request) {
        self.assets = self.loadAssets()
        
        if assets.indices.contains(request.indexPath.row) {
            let assetModel = assets[request.indexPath.row]
            self.assetDataStore = convertModelsForDataPassing(from: assetModel)
        }
    }
    
    func loadAssets(request: SavedModel.LoadAssets.Request) {
        self.assets = self.loadAssets()
        self.presenter?.presentAssets(response: .init(assets: self.assets) )
    }
    
    func deleteAsset(request: SavedModel.DeleteAsset.Request) {
        self.dataStorageWorker.deleteAsset(with: request.tokenID)
    }
}

private extension SavedInteractor {
    func convertModelsForDataPassing(from assetModel: SavedModel.LoadAssets.AssetModel) -> AssetDataStoreModel {
        .init(tokenID: assetModel.tokenID,
              assetName: assetModel.assetName,
              assetImageData: assetModel.assetImageData,
              assetDescription: assetModel.assetDescription,
              collectionName: assetModel.collectionName,
              collectionImageData: assetModel.collectionImageData)
    }
    
    func loadAssets() -> [SavedModel.LoadAssets.AssetModel] {
        let assetsEntities = self.dataStorageWorker.loadAssets()
        return assetsEntities.map { .init(from: $0) }
    }
}
