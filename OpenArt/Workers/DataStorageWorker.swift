//
//  DataStorageWorker.swift
//  OpenArt
//
//  Created by Иван Дурмашев on 19.06.2022.
//

import Foundation
import CoreData

protocol IDataStorageSaveWorker {
    func save(data: AssetDataStoreModel)
}

protocol IDataStorageLoadWorker {
    func loadAssets() -> [AssetEntity]
}

protocol IDataStorageDeleteWorker {
    func deleteAsset(with uniqueID: String)
}

//MARK: - DataStorageWorker
final class DataStorageWorker {
    private let dataService = DataService.shared
}

//MARK: - IDataStorageSaveWorker
extension DataStorageWorker: IDataStorageSaveWorker {
    func save(data: AssetDataStoreModel) {
        self.dataService.addNew(asset: data)
    }
}

//MARK: - IDataStorageLoadWorker
extension DataStorageWorker: IDataStorageLoadWorker {
    func loadAssets() -> [AssetEntity] {
        self.dataService.loadAssets()
    }
}

extension DataStorageWorker: IDataStorageDeleteWorker {
    func deleteAsset(with tokenID: String) {
        self.dataService.deleteAssetEntity(with: tokenID)
    }
}

