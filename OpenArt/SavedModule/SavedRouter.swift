//
//  SavedRouter.swift
//  OpenArt
//
//  Created by Иван Дурмашев on 20.06.2022.
//

import Foundation
import UIKit


protocol ISavedRouter: AnyObject {
    func routeToAssetVC()
}

protocol ILikedDataPassing: AnyObject {
    var dataStore: ISavedDataStore? { get }
}

final class SavedRouter: ILikedDataPassing {
    weak var dataStore: ISavedDataStore?
    weak var vc: UIViewController?
}

extension SavedRouter: ISavedRouter {
    func routeToAssetVC() {
        let assetVC = AssetAssembly.build()
        
        let selectedAsset = self.dataStore?.selectedAsset
        assetVC.router?.dataStore?.assetDataStore = selectedAsset
        
        vc?.navigationController?.pushViewController(assetVC, animated: true)
    }
}
