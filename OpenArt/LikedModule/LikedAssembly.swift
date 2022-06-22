//
//  LikedAssembly.swift
//  OpenArt
//
//  Created by Иван Дурмашев on 21.06.2022.
//

import Foundation

enum LikedAssembly {
    
    static func build() -> LikedViewController {
        let dataStorageWorker = AssetDataStorageWorker()
        let presenter = LikedPresenter()
        let router = LikedRouter()
        let interactor = LikedInteractor(presenter: presenter, dataStorageWorker: dataStorageWorker)
        let vc = LikedViewController(interactor: interactor, router: router)
        presenter.vc = vc
        
        return vc
    }
}
