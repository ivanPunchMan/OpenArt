//
//  SavedInteractor.swift
//  OpenArt
//
//  Created by Иван Дурмашев on 20.06.2022.
//

import Foundation

protocol ISavedInteractor: AnyObject {
    func deleteAsset(for request: SavedModel.DeleteAsset.Request)
    func loadAssets(request: SavedModel.LoadAssets.Request)
}

protocol ISavedDataStore: AnyObject {}

//MARK: - ISavedDataStore
final class SavedInteractor: ISavedDataStore {
    private var presenter: ISavedPresenter?
    private var dataStorageWorker: IDataStorageLoadWorker
    
    init(presenter: ISavedPresenter, dataStorageWorker: IDataStorageLoadWorker) {
        self.presenter = presenter
        self.dataStorageWorker = dataStorageWorker
    }
}

//MARK: - ISavedInteractor
extension SavedInteractor: ISavedInteractor {
    func loadAssets(request: SavedModel.LoadAssets.Request) {
        let assetsEntities = self.dataStorageWorker.loadAssets()
        let assetModels: [SavedModel.LoadAssets.AssetModel] = assetsEntities.map { .init(from: $0) }
        
        self.presenter?.presentAssets(response: .init(assets: assetModels) )
    }
    
    func deleteAsset(for request: SavedModel.DeleteAsset.Request) {
        self.dataStorageWorker.deleteAsset(with: request.tokenID)
    }
}
