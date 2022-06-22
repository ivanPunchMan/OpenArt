//
//  AssetAssembly.swift
//  OpenArt
//
//  Created by Иван Дурмашев on 15.06.2022.
//

import Foundation

enum AssetAssembly {
    static func build() -> AssetViewController {
        let presenter = AssetPresenter()
        let networkWorker = NetworkWorker()
        let dataStorageWorker = AssetDataStorageWorker()
        let interactor = AssetInteractor(presenter: presenter, networkWorker: networkWorker, dataStorageWorker: dataStorageWorker)
        let router = AssetRouter()
        let vc = AssetViewController(interactor: interactor, router: router)
        presenter.vc = vc
        router.dataStore = interactor
        
        return vc
    }
}
