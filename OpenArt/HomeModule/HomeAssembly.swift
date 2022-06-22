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
        let presenter = HomePresenter()
        let router = HomeRouter()
        let interactor = HomeInteractor(presenter: presenter, networkWorker: networkWorker)
        router.dataStore = interactor
        let vc = HomeViewController(interactor: interactor, router: router)
        router.vc = vc
        presenter.vc = vc
        
        return vc
    }
}
