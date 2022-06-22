//
//  AssetModel.swift
//  OpenArt
//
//  Created by Иван Дурмашев on 15.06.2022.
//

import UIKit

struct AssetModel {
//MARK: - FetchCollectionImage
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

//MARK: - FetchAssetImage
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

//MARK: - FetchAssetInfo
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
    
//MARK: - SaveAsset
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
}
