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
        
        self.passDataTo(assetVC, from: dataStore)
        
        self.navigateTo(assetVC)
    }
}

private extension SavedRouter {
    func passDataTo(_ asset: AssetViewController?, from savedDataStore: ISavedDataStore?) {
        asset?.router?.dataStore?.assetDataStore = savedDataStore?.assetDataStore
    }
    
    func navigateTo<T: UIViewController>(_ destination: T) {
        self.vc?.navigationController?.pushViewController(destination, animated: true)
    }
}
