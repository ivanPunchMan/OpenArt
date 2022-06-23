//
//  HomeModel.swift
//  OpenArt
//
//  Created by Иван Дурмашев on 13.06.2022.
//

import Foundation
import UIKit

enum HomeModel {
//MARK: - FetchAssets
    enum FetchAssets {
        struct Request {
            let nextPage: String?
        }
        
        struct Response {
            let nextPage: String?
            let assets: [Asset]
            
            init(from assetsDTO: AssetsDTO) {
                self.nextPage = assetsDTO.next
                self.assets = assetsDTO.assets.filter { $0.imageURL != nil && $0.collection?.imageURL != nil }
            }
        }
        
        struct ViewModel {
            let nextPage: String?
            let assets: [AssetViewModel]
        }
        
        struct AssetViewModel {
            let assetName: String?
            let assetImageURL: String?
            let assetDescription: String?
            let collectionName: String?
            let collectionImageURL: String?
            let tokenID: String?
            
            init(from asset: Asset) {
                self.assetName = asset.name
                self.assetImageURL = asset.imageURL
                self.assetDescription = asset.description
                self.collectionName = asset.collection?.name
                self.collectionImageURL = asset.collection?.imageURL
                self.tokenID = asset.tokenID
            }
        }
    }
    
//MARK: - FetchCollectionImage
    enum FetchCollectionImage {
        struct Request {
            let indexPath: IndexPath
        }
        
        struct Response {
            let collectionImageData: Data?
            let indexPath: IndexPath
        }
        
        struct ViewModel {
            let collectionImage: UIImage?
            let indexPath: IndexPath
        }
    }

//MARK: - FetchAssetImage
    enum FetchAssetImage {
        struct Request {
            let indexPath: IndexPath
        }
        
        struct Response {
            let assetImageData: Data?
            let indexPath: IndexPath
        }
        
        struct ViewModel {
            let assetImage: UIImage?
            let indexPath: IndexPath
        }
    }
  
//MARK: - SaveAsset
    enum SaveAsset {
        struct Request {
            let tokenID: String?
            let assetName: String?
            let assetImage: UIImage?
            let assetDescription: String?
            let collectionName: String?
            let collectionImage: UIImage?
        }
    }
    
    enum SelectAsset {
        struct Request {
            let asset: AssetDataStoreModel
        }
    }
}
