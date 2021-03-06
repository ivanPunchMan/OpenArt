//
//  SavedModel.swift
//  OpenArt
//
//  Created by Иван Дурмашев on 20.06.2022.
//

import UIKit

struct SavedModel {
//MARK: - LoadAssets
    enum LoadAssets {
        struct Request {
        }
        
        struct Response {
            var assets: [AssetModel]
        }
        
        struct AssetModel {
            var tokenID: String?
            var assetName: String?
            var assetImageData: Data?
            var assetDescription: String?
            var collectionName: String?
            var collectionImageData: Data?
            
            init(from assetEntity: AssetEntity) {
                self.tokenID = assetEntity.tokenID
                self.assetName = assetEntity.assetName
                self.assetImageData = assetEntity.assetImage
                self.assetDescription = assetEntity.assetDescription
                self.collectionName = assetEntity.collectionName
                self.collectionImageData = assetEntity.collectionImage
            }
        }
        
        struct ViewModel {
            var assets: [AssetModel]
            
            init(from response: Response) {
                self.assets = response.assets
            }
        }
    }

//MARK: - DeleteAsset
    enum DeleteAsset {
        struct Request {
            let tokenID: String
        }
        
        struct Response {
            let tokenID: String
        }
        
        struct ViewModel {
            let tokenID: String
        }
    }

//MARK: - SelectAsset
    enum SelectAsset {
        struct Request {
            let indexPath: IndexPath
        }
    }
}
