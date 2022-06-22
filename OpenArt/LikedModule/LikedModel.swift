//
//  LikedModel.swift
//  OpenArt
//
//  Created by Иван Дурмашев on 20.06.2022.
//

import UIKit

struct LikedModel {
    
    enum LoadAssets {
        struct Request {
        }
        
        struct Response {
            var assets: [AssetModel]
        }
        
        struct AssetModel {
            var uniqueID: String?
            var assetName: String?
            var assetImage: Data?
            var assetDescription: String?
            var collectionName: String?
            var collectionImage: Data?
            
            init(from assetEntity: AssetEntity) {
                self.uniqueID = assetEntity.uniqueID
                self.assetName = assetEntity.assetName
                self.assetImage = assetEntity.assetImage
                self.assetDescription = assetEntity.assetDescription
                self.collectionName = assetEntity.collectionName
                self.collectionImage = assetEntity.collectionImage
            }
        }
        
        struct ViewModel {
            var assets: [AssetModel]
            
            init(from response: Response) {
                self.assets = response.assets
            }
        }
    }
    
    enum DisplayAsset {
        struct Request {
            let indexPath: IndexPath
            let cell: UICollectionViewCell
        }
        
        struct Response {
            let indexPath: IndexPath
            let data: DisplaedData
            let cell: UICollectionViewCell
        }
        
        struct DisplaedData {
            var assetName: String?
            var assetImage: UIImage?
            var assetDescription: String?
            var collectionName: String?
            var collectionImage: UIImage?
            
            init(from assetEntity: AssetEntity) {
                self.assetName = assetEntity.assetName
                self.assetImage = UIImage(data: assetEntity.assetImage ?? Data())
                self.assetDescription = assetEntity.assetDescription
                self.collectionName = assetEntity.collectionName
                self.collectionImage = UIImage(data: assetEntity.collectionImage ?? Data())
            }
        }
        
        struct ViewModel {
            let indexPath: IndexPath
            let data: DisplaedData
            let cell: UICollectionViewCell
        }
    }
    
    enum LoadAsset {
        struct Request {
            let indexPath: IndexPath
        }
        
        struct Response {
            let indexPath: IndexPath
            var assetName: String?
            var assetImage: UIImage?
            var assetDescription: String?
            var collectionName: String?
            var collectionImage: UIImage?
            
            init(from assetEntity: AssetEntity, for indexPath: IndexPath) {
                self.indexPath = indexPath
                self.assetName = assetEntity.assetName
                self.assetImage = UIImage(data: assetEntity.assetImage ?? Data())
                self.assetDescription = assetEntity.assetDescription
                self.collectionName = assetEntity.collectionName
                self.collectionImage = UIImage(data: assetEntity.collectionImage ?? Data())
            }
        }
        
        struct ViewModel {
            let indexPath: IndexPath
            var assetName: String?
            var assetImage: UIImage?
            var assetDescription: String?
            var collectionName: String?
            var collectionImage: UIImage?
            
            init(from response: Response) {
                self.indexPath = response.indexPath
                self.assetName = response.assetName
                self.assetImage = response.assetImage
                self.assetDescription = response.assetDescription
                self.collectionName = response.collectionName
                self.collectionImage = response.collectionImage
            }
        }
    }
    
    enum CountAssets {
        struct Request {}
        
        struct Response {
            let count: Int
        }
        
        struct ViewModel {
            let count: Int
        }
    }
    
    enum DeleteAsset {
        struct Request {
            let indexPath: IndexPath
        }
        
        struct Response {
            let indexPath: IndexPath
        }
        
        struct ViewModel {
            let indexPath: IndexPath
        }
    }
}
