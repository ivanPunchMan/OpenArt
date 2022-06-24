//
//  DataService.swift
//  OpenArt
//
//  Created by Иван Дурмашев on 20.06.2022.
//

import Foundation
import CoreData

class DataService {
    static var shared = DataService()
    
    static var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "AssetDataModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    private lazy var backgroundContext = Self.persistentContainer.newBackgroundContext()
    
    private init() {}
    
    func addNew(asset model: AssetDataStoreModel) {
        let assetEntity = AssetEntity(context: backgroundContext)
        
        assetEntity.collectionName = model.collectionName
        assetEntity.assetDescription = model.assetDescription
        assetEntity.assetName = model.assetName
        assetEntity.collectionImage = model.collectionImageData
        assetEntity.assetImage = model.assetImageData
        assetEntity.dateAdded = Date.now
        assetEntity.tokenID = model.tokenID
        
        self.saveContext()
    }
    
    func loadAssets() -> [AssetEntity] {
        let fetchRequest = AssetEntity.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "dateAdded", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        var assetEntities = [AssetEntity]()
        
        do {
            assetEntities = try self.backgroundContext.fetch(fetchRequest)
        } catch {
            print(error.localizedDescription)
        }
        
        return assetEntities
    }
    
    func deleteAssetEntity(with tokenID: String) {
        let fetchRequest = AssetEntity.fetchRequest()
        fetchRequest.fetchLimit = 1
        
        let predicate = NSPredicate(format: "tokenID = %@", tokenID)
        fetchRequest.predicate = predicate
        
        var assetEntities = [AssetEntity]()
        do {
            assetEntities = try self.backgroundContext.fetch(fetchRequest)
        } catch {
            print("Не удалось достать объект с уникальным ID: \(error.localizedDescription)")
        }
        
        for assetEntity in assetEntities {
            self.backgroundContext.delete(assetEntity)
        }
        saveContext()
    }
}

private extension DataService {
// MARK: - saveContext
    func saveContext () {
        if self.backgroundContext.hasChanges {
            do {
                try self.backgroundContext.save()
            } catch {
                let nserror = error as NSError
                print("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

