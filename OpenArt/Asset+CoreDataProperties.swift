//
//  Asset+CoreDataProperties.swift
//  OpenArt
//
//  Created by Иван Дурмашев on 20.06.2022.
//
//

import Foundation
import CoreData


extension Asset {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AssetEntity> {
        return NSFetchRequest<AssetEntity>(entityName: "AssetEntity")
    }

    @NSManaged public var assetName: String?
    @NSManaged public var assetImage: UIImage?
    @NSManaged public var assetDescription: String?
    @NSManaged public var collectionName: String?
    @NSManaged public var collectionImage: UIImage?

}

extension Asset : Identifiable {

}
