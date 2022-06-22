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
    
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "AssetDataModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    private lazy var viewContext = persistentContainer.viewContext
    
    func addNewAsset(from model: AssetModel.SaveAsset.Request) {
        let assetEntity = AssetEntity(context: viewContext)
        
        assetEntity.collectionName = model.collectionName
        assetEntity.assetDescription = model.assetDescription
        assetEntity.assetName = model.assetName
        assetEntity.collectionImage = model.collectionImage?.pngData()
        assetEntity.assetImage = model.assetImage?.pngData()
        assetEntity.dateAdded = Date.now
        
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
    
// MARK: - saveContext
    func saveContext () {
        if self.viewContext.hasChanges {
            do {
                try self.viewContext.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
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
