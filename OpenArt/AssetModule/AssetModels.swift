//
//  AssetModel.swift
//  OpenArt
//
//  Created by Иван Дурмашев on 15.06.2022.
//

import UIKit

struct AssetModel {
//MARK: - FetchAssetData
    enum FetchAssetData {
        struct Request {}
        
        struct Response {
            let assetImageData: Data?
            let collectionImageData: Data?
            let assetName: String?
            let assetDescription: String?
            let collectionName: String?
        }
        
        struct ViewModel {
            let assetImage: UIImage?
            let collectionImage: UIImage?
            let assetName: String?
            let assetDescription: String?
            let collectionName: String?
        }
    }
}
