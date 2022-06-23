//
//  SavedAssembly.swift
//  OpenArt
//
//  Created by Иван Дурмашев on 21.06.2022.
//

import Foundation

enum SavedAssembly {
    
    static func build() -> SavedViewController {
        let dataStorageWorker = DataStorageWorker()
        let presenter = SavedPresenter()
        let router = SavedRouter()
        let interactor = SavedInteractor(presenter, dataStorageWorker)
        let vc = SavedViewController(interactor, router)
        presenter.vc = vc
        router.vc = vc
        router.dataStore = interactor
        
        return vc
    }
}
