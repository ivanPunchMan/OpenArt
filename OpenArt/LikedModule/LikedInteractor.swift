//
//  LikedInteractor.swift
//  OpenArt
//
//  Created by Иван Дурмашев on 20.06.2022.
//

import Foundation

protocol ILikedInteractor: AnyObject {
    func deleteAsset(for request: LikedModel.DeleteAsset2.Request)
    func loadAssets(request: LikedModel.LoadAssets.Request)
}

protocol ILikedDataStore: AnyObject {}

//MARK: - ILikedDataStore
final class LikedInteractor: ILikedDataStore {
    private var presenter: ILikedPresenter?
    private var dataStorageWorker: IDataStorageLoadWorker
    
    init(presenter: ILikedPresenter, dataStorageWorker: IDataStorageLoadWorker) {
        self.presenter = presenter
        self.dataStorageWorker = dataStorageWorker
    }
}

//MARK: - ILikedInteractor
extension LikedInteractor: ILikedInteractor {
    func loadAssets(request: LikedModel.LoadAssets.Request) {
        let assetsEntities = self.dataStorageWorker.loadAssets()
        let assetModels: [LikedModel.LoadAssets.AssetModel] = assetsEntities.map { .init(from: $0) }
        
        self.presenter?.presentAssets(response: .init(assets: assetModels) )
    }
    
    func deleteAsset(for request: LikedModel.DeleteAsset2.Request) {
        self.dataStorageWorker.deleteAsset(with: request.uniqueID)
    }
}
