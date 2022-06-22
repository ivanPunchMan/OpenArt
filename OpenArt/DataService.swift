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
    
    private init() {
        self.configureFetchedResultController()
        
//        let asset = AssetEntity(context: viewContext)
//        asset.assetImage = UIImage(named: "testImage")?.pngData()
//        asset.assetName = "1"
//        saveContext()
//
//        let asset2 = AssetEntity(context: viewContext)
//        asset2.assetImage = UIImage(named: "testImage")?.pngData()
//        asset2.assetName = "2"
//        saveContext()
//
//        let asset3 = AssetEntity(context: viewContext)
//        asset3.assetImage = UIImage(named: "testImage")?.pngData()
//        asset3.assetName = "3"
//        saveContext()
//
//        let asset4 = AssetEntity(context: viewContext)
//        asset4.assetImage = UIImage(named: "testImage")?.pngData()
//        asset4.assetName = "4"
//        saveContext()
//
//        let asset5 = AssetEntity(context: viewContext)
//        asset5.assetImage = UIImage(named: "testImage")?.pngData()
//        asset5.assetName = "5"
//        saveContext()
    }
    
    var fetchedResultController = NSFetchedResultsController<AssetEntity>()
    
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
    
    func countOfAssets() -> Int {
        self.fetchedResultController.sections?.first?.numberOfObjects ?? 0
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
    
    func delete(assetEntity: AssetEntity) {
        self.viewContext.delete(assetEntity)
        self.saveContext()
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

private extension DataService {
    func configureFetchedResultController() {
        let fetchRequest = AssetEntity.fetchRequest()
        fetchRequest.fetchLimit = 20
        
        let sortDescriptor = NSSortDescriptor(key: "dateAdded", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        self.fetchedResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        
        do {
            try self.fetchedResultController.performFetch()
        } catch {
            print(error.localizedDescription)
        }
    }
}
