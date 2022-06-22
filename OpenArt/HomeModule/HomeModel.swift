//
//  HomeEntity.swift
//  OpenArt
//
//  Created by Иван Дурмашев on 13.06.2022.
//

import Foundation
import UIKit

enum HomeModel {
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
            let creatorUsername: String?
            let assetImageURL: String?
            let assetDescription: String?
            let collectionName: String?
            let collectionImageURL: String?
            let tokenID: String?
            
            init(from asset: Asset) {
                self.creatorUsername = asset.creator?.user?.username
                self.assetImageURL = asset.imageURL
                self.assetDescription = asset.description
                self.collectionName = asset.collection?.name
                self.collectionImageURL = asset.collection?.imageURL
                self.tokenID = asset.tokenID
            }
        }
    }
    
    enum FetchCollectionImage {
        struct Request {
            let indexPath: IndexPath
        }
        
        struct Response {
            var collectionImageData: Data?
            let indexPath: IndexPath
        }
        
        struct ViewModel {
            var collectionImage: UIImage?
            let indexPath: IndexPath
        }
    }
    
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
    
    enum SaveAsset {
        struct Request {
            var tokenID: String?
            var assetName: String?
            var assetImage: UIImage?
            var assetDescription: String?
            var collectionName: String?
            var collectionImage: UIImage?
        }
        struct Response {
            
        }
        struct ViewModel {
            
        }
    }
}
