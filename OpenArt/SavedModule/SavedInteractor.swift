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
//    var assets: [AssetDataProviderModel] { get set }
    var selectedAsset: AssetDataProviderModel? { get set }
}

//MARK: - ISavedDataStore
final class SavedInteractor: ISavedDataStore {
    var selectedAsset: AssetDataProviderModel?
    
    private var presenter: ISavedPresenter?
    private var dataStorageWorker: IDataStorageLoadWorker
    private var assets: [SavedModel.LoadAssets.AssetModel]?
    
    init(presenter: ISavedPresenter, dataStorageWorker: IDataStorageLoadWorker) {
        self.presenter = presenter
        self.dataStorageWorker = dataStorageWorker
    }
}

//MARK: - ISavedInteractor
extension SavedInteractor: ISavedInteractor {
    func selectAsset(request: SavedModel.SelectAsset.Request) {
        guard let assets = self.assets, assets.indices.contains(request.indexPath.row) else { return }
        let assetModel = assets[request.indexPath.row]
        self.selectedAsset = convertModelsForDataPassing(from: assetModel)
    }
    
    func loadAssets(request: SavedModel.LoadAssets.Request) {
        let assetsEntities = self.dataStorageWorker.loadAssets()
        let assetModels: [SavedModel.LoadAssets.AssetModel] = assetsEntities.map { .init(from: $0) }
        self.assets = assetModels
        self.presenter?.presentAssets(response: .init(assets: assetModels) )
    }
    
    func deleteAsset(request: SavedModel.DeleteAsset.Request) {
        self.dataStorageWorker.deleteAsset(with: request.tokenID)
    }
}

private func convertModelsForDataPassing(from assetModel: SavedModel.LoadAssets.AssetModel) -> AssetDataProviderModel {
    .init(tokenID: assetModel.tokenID,
          assetName: assetModel.assetName,
          assetImageData: assetModel.assetImageData,
          assetDescription: assetModel.assetDescription,
          collectionName: assetModel.collectionName,
          collectionImageData: assetModel.collectionImageData)
}
