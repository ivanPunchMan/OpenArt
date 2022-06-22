//
//  HomeRouter.swift
//  OpenArt
//
//  Created by Иван Дурмашев on 13.06.2022.
//

import Foundation
import UIKit

protocol IHomeRouter: AnyObject {
    func routeToSavedVC()
    func routeToPlaceBidVC(from indexPath: IndexPath)
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
    func routeToPlaceBidVC(from indexPath: IndexPath) {
        let nextVC = AssetAssembly.build()
        
        if let assets = self.dataStore?.assets, assets.indices.contains(indexPath.row) {
            nextVC.router?.dataStore?.asset = assets[indexPath.row]
        }
        
        self.vc?.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    func routeToSavedVC() {
        let nextVC = LikedAssembly.build()
        self.vc?.navigationController?.pushViewController(nextVC, animated: true)
    }
}
