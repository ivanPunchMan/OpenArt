//
//  AssetRouter.swift
//  OpenArt
//
//  Created by Иван Дурмашев on 15.06.2022.
//

import Foundation

protocol IAssetRouter: AnyObject {
    
}

protocol IAssetDataPassing: AnyObject {
    var dataStore: IAssetDataStore? { get set }
}

final class AssetRouter: IAssetDataPassing {
    weak var dataStore: IAssetDataStore?
}

extension AssetRouter: IAssetRouter {
    
}
