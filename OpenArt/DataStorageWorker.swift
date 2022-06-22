//
//  AssetDetailDataStorageWorker.swift
//  OpenArt
//
//  Created by Иван Дурмашев on 19.06.2022.
//

import Foundation
import CoreData

protocol IDataStorageSaveWorker {
    func save(data: AssetSaveDataModel)
}

protocol IDataStorageLoadWorker {
    func loadAssets() -> [AssetEntity]
    func deleteAsset(with uniqueID: String)
}

//MARK: - AssetDataStorageWorker
final class AssetDataStorageWorker: NSObject {
    private let dataService = DataService.shared
}

//MARK: - IDataStorageSaveWorker
extension AssetDataStorageWorker: IDataStorageSaveWorker {
    func save(data: AssetSaveDataModel) {
        self.dataService.addNew(asset: data)
    }
}

//MARK: - IDataStorageLoadWorker
extension AssetDataStorageWorker: IDataStorageLoadWorker {
    func deleteAsset(with uniqueID: String) {
        self.dataService.deleteAssetEntity(with: uniqueID)
    }
    
    func loadAssets() -> [AssetEntity] {
        self.dataService.loadAssets()
    }
}
