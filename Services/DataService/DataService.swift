//
//  DataService.swift
//  OpenArt
//
//  Created by Иван Дурмашев on 20.06.2022.
//

import Foundation
import CoreData
//НЕ ЗАБЫТЬ УДАЛИТЬ
import UIKit

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
    
    private lazy var viewContext = Self.persistentContainer.viewContext
    
    private init() {}
    
    func addNew(asset model: AssetSaveDataModel) {
        let assetEntity = AssetEntity(context: viewContext)
        
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
        let sortDescriptor = NSSortDescriptor(key: "dateAdded", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        var assetEntities = [AssetEntity]()
        
        do {
            assetEntities = try self.viewContext.fetch(fetchRequest)
        } catch {
            print(error.localizedDescription)
        }
        
        return assetEntities
    }
    
    func deleteAssetEntity(with uniqueID: String) {
        let fetchRequest = AssetEntity.fetchRequest()
        fetchRequest.fetchLimit = 1
        
        let sortDescriptor = NSSortDescriptor(key: "tokenID", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        var assetEntities = [AssetEntity]()
        do {
            assetEntities = try self.viewContext.fetch(fetchRequest)
        } catch {
            print("Не удалось достать объект с уникальным ID: \(error.localizedDescription)")
        }
        
        for assetEntity in assetEntities {
            self.viewContext.delete(assetEntity)
        }
        saveContext()
    }
}

private extension DataService {
// MARK: - saveContext
    func saveContext () {
        if self.viewContext.hasChanges {
            do {
                try self.viewContext.save()
            } catch {
                let nserror = error as NSError
                print("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

