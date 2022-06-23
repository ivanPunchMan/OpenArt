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
    func routeToSaved()
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
    
    func routeToAsset() {
        let assetVC = AssetAssembly.build()
        
        self.passDataTo(assetVC, from: self.dataStore)
        self.navigateTo(assetVC)
    }
    
    func routeToSaved() {
        let savedVC = SavedAssembly.build()
        
        self.navigateTo(savedVC)
    }
}

private extension HomeRouter {
    func passDataTo(_ asset: AssetViewController?, from homeDataStore: IHomeDataStore?) {
        asset?.router?.dataStore?.assetDataStore = homeDataStore?.assetDataStore
    }
    
    func navigateTo<T: UIViewController>(_ destination: T) {
        self.vc?.navigationController?.pushViewController(destination, animated: true)
    }
}
