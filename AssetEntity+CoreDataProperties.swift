//
//  AssetEntity+CoreDataProperties.swift
//  OpenArt
//
//  Created by Иван Дурмашев on 21.06.2022.
//
//

import Foundation
import CoreData


extension AssetEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AssetEntity> {
        return NSFetchRequest<AssetEntity>(entityName: "AssetEntity")
    }

    @NSManaged public var assetName: String?
    @NSManaged public var assetImage: Data?
    @NSManaged public var assetDescription: String?
    @NSManaged public var collectionName: String?
    @NSManaged public var collectionImage: Data?
    @NSManaged public var dateAdded: Date?
    @NSManaged public var uniqueID: String?

}

extension AssetEntity : Identifiable {

}
