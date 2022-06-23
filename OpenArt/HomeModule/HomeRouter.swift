//
//  HomeRouter.swift
//  OpenArt
//
//  Created by Иван Дурмашев on 13.06.2022.
//

import Foundation
import UIKit

protocol IHomeRouter: AnyObject {
    func routeToAsset()
    func routeToSavedVC()
    func routeToAssetVC(from indexPath: IndexPath)
}

protocol IHomeDataPassing: AnyObject {
    var dataStore: IHomeDataStore? { get }
}

//MARK: - IHomeDataPassing
final class HomeRouter: IHomeDataPassing {
    weak var dataStore: IHomeDataStore?
    weak var vc: UIViewController?
}

//MARK: - IHomeRouter
extension HomeRouter: IHomeRouter {
    func routeToAssetVC(from indexPath: IndexPath) {
        let assetVC = AssetAssembly.build()
        
        if let assets = self.dataStore?.assets, assets.indices.contains(indexPath.row) {
            assetVC.router?.dataStore?.asset = assets[indexPath.row]
        }
        
        self.vc?.navigationController?.pushViewController(assetVC, animated: true)
    }
    
    func routeToAsset() {
        let assetVC = AssetAssembly.build()
        
        assetVC.router?.dataStore?.assetDataStore = dataStore?.asset
        
        self.vc?.navigationController?.pushViewController(assetVC, animated: true)
    }
    
    func routeToSavedVC() {
        let nextVC = SavedAssembly.build()
        
        self.vc?.navigationController?.pushViewController(nextVC, animated: true)
    }
}
