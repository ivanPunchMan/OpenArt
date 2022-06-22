//
//  LikedInteractor.swift
//  OpenArt
//
//  Created by Иван Дурмашев on 20.06.2022.
//

import Foundation

protocol ILikedInteractor: AnyObject {
    func loadAssets(request: LikedModel.LoadAssets.Request)
    func loadAsset(for request: LikedModel.DisplayAsset.Request)
    func countAssets(request: LikedModel.CountAssets.Request)
    func loadAsset(for request: LikedModel.LoadAsset.Request)
    func deleteAsset(for request: LikedModel.DeleteAsset.Request)
}

protocol ILikedDataStore: AnyObject {
    
}

final class LikedInteractor: ILikedDataStore {
    
    private var presenter: ILikedPresenter?
    private var dataStorageWorker: IDataStorageLoadWorker
    
    init(presenter: ILikedPresenter, dataStorageWorker: IDataStorageLoadWorker) {
        self.presenter = presenter
        self.dataStorageWorker = dataStorageWorker
    }
}

extension LikedInteractor: ILikedInteractor {
    
    func loadAssets(request: LikedModel.LoadAssets.Request) {
        let assetsEntities = self.dataStorageWorker.loadAssets()
        let assetModels: [LikedModel.LoadAssets.AssetModel] = assetsEntities.map { .init(from: $0) }
        
        self.presenter?.presentAssets(response: .init(assets: assetModels) )
    }
    
    func countAssets(request: LikedModel.CountAssets.Request) {
        let count = self.dataStorageWorker.countOfAssets()
        self.presenter?.presentCountOfAssets(response: .init(count: count))
    }
    
    func loadAsset(for request: LikedModel.DisplayAsset.Request) {
        let assetEntity = self.dataStorageWorker.loadAsset(for: request.indexPath)
        self.presenter?.presentAsset(response: .init(indexPath: request.indexPath, data: .init(from: assetEntity), cell: request.cell))
    }
    
    func loadAsset(for request: LikedModel.LoadAsset.Request) {
        let indexPath = request.indexPath
        let assetEntity = self.dataStorageWorker.loadAsset(for: indexPath)
        
        self.presenter?.presentAsset(response: .init(from: assetEntity, for: indexPath))
    }
    
    func deleteAsset(for request: LikedModel.DeleteAsset.Request) {
        self.dataStorageWorker.deleteAsset = { [weak self] indexPath in
            let indexPathStrong = indexPath ?? IndexPath()
            self?.presenter?.deleteAsset(response: .init(indexPath: indexPathStrong))
        }
        
        self.dataStorageWorker.deleteAsset(at: request.indexPath)
    }
}
