//
//  AssetModel.swift
//  OpenArt
//
//  Created by Иван Дурмашев on 15.06.2022.
//

import UIKit

struct AssetModel {
    enum FetchCollectionImage {
        struct Request {
            var collectionImageURL: String?
        }
        
        struct Response {
            var collectionImageData: Data?
        }
        
        struct ViewModel {
            var collectionImage: UIImage?
        }
    }
    
    enum FetchAssetImage {
        struct Request {
        }
        
        struct Response {
            let assetImageData: Data?
        }
        
        struct ViewModel {
            let assetImage: UIImage?
        }
    }
    
    enum FetchAssetInfo {
        struct Request {}
        
        struct Response {
            var assetName: String?
            var assetDescription: String?
            var collectionName: String?
        }
        
        struct ViewModel {
            var assetName: String?
            var assetDescription: String?
            var collectionName: String?
        }
    }
    
    enum SaveAsset {
        struct Request {
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
    
    enum LoadAsset {
        struct Request {
            let indexPath: IndexPath?
        }
        
        struct Response {
            var assetName: String?
            var assetImage: UIImage?
            var assetDescription: String?
            var collectionName: String?
            var collectionImage: UIImage?
        }
        
        struct ViewModel {
            var assetName: String?
            var assetImage: UIImage?
            var assetDescription: String?
            var collectionName: String?
            var collectionImage: UIImage?
            
            init(from response: Response) {
                self.assetName = response.assetName
                self.assetImage = response.assetImage
                self.assetDescription = response.assetDescription
                self.collectionName = response.collectionName
                self.collectionImage = response.collectionImage
            }
        }
    }
}
