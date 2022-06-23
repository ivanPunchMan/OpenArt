//
//  HomeAssembly.swift
//  OpenArt
//
//  Created by Иван Дурмашев on 13.06.2022.
//

import Foundation
import UIKit

enum HomeAssembly {
    static func build() -> HomeViewController {
        let networkWorker = NetworkWorker()
        let dataStorageWorker = DataStorageWorker()
        let presenter = HomePresenter()
        let router = HomeRouter()
        let interactor = HomeInteractor(presenter, networkWorker, dataStorageWorker)
        router.dataStore = interactor
        let vc = HomeViewController(interactor, router)
        router.vc = vc
        presenter.vc = vc
        
        return vc
    }
}
