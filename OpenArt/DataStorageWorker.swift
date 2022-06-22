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
    var deleteAsset: ((IndexPath?) -> Void)? { get set }
    func loadAssets() -> [AssetEntity]
    
    func deleteAsset(with uniqueID: String)
    func countOfAssets() -> Int
    func loadAsset(for indexPath: IndexPath) -> AssetEntity
    func deleteAsset(at indexPath: IndexPath)
}

final class AssetDataStorageWorker: NSObject {
    var deleteAsset: ((IndexPath?) -> Void)?
    
    private let dataService = DataService.shared
    
    override init() {
        super.init()
//        dataService.fetchedResultController.delegate = self
    }
}

extension AssetDataStorageWorker: IDataStorageSaveWorker {
    func save(data: AssetSaveDataModel) {
        self.dataService.addNew(asset: data)
        
        print(data)
        print("Данные сохранены")
    }
}

extension AssetDataStorageWorker: IDataStorageLoadWorker {
    func countOfAssets() -> Int {
        self.dataService.countOfAssets()
    }
    
    func loadAsset(for indexPath: IndexPath) -> AssetEntity {
        let assetEntity = self.dataService.fetchedResultController.object(at: indexPath)

        return assetEntity
    }
    
    func deleteAsset(with uniqueID: String) {
        self.dataService.deleteAssetEntity(with: uniqueID)
    }
    
    func deleteAsset(at indexPath: IndexPath) {
        let assetEntity = self.dataService.fetchedResultController.object(at: indexPath)
        self.dataService.delete(assetEntity: assetEntity)
    }
    
    func loadAssets() -> [AssetEntity] {
        self.dataService.loadAssets()
    }
}

extension AssetDataStorageWorker: NSFetchedResultsControllerDelegate {
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .delete:
            deleteAsset?(indexPath)
        default:
            break
        }
    }
}
