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
        let interactor = AssetInteractor(presenter)
        let router = AssetRouter()
        let vc = AssetViewController(interactor, router)
        presenter.vc = vc
        router.dataStore = interactor
        
        return vc
    }
}
