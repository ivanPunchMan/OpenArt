//
//  SavedAssembly.swift
//  OpenArt
//
//  Created by Иван Дурмашев on 21.06.2022.
//

import Foundation

enum SavedAssembly {
    
    static func build() -> SavedViewController {
        let dataStorageWorker = AssetDataStorageWorker()
        let presenter = SavedPresenter()
        let router = SavedRouter()
        let interactor = SavedInteractor(presenter: presenter, dataStorageWorker: dataStorageWorker)
        let vc = SavedViewController(interactor: interactor, router: router)
        presenter.vc = vc
        
        return vc
    }
}
