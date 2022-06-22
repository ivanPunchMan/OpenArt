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
            var tokenID: String?
            var assetName: String?
            var assetImage: Data?
            var assetDescription: String?
            var collectionName: String?
            var collectionImage: Data?
            
            init(from assetEntity: AssetEntity) {
                self.tokenID = assetEntity.tokenID
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

    enum DeleteAsset2 {
        struct Request {
            let uniqueID: String
        }
        
        struct Response {
            let uniqueID: String
        }
        
        struct ViewModel {
            let uniqueID: String
        }
    }
}
