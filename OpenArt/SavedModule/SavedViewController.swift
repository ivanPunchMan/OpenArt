//
//  SavedViewController.swift
//  OpenArt
//
//  Created by Иван Дурмашев on 20.06.2022.
//

import Foundation
import UIKit

protocol ISavedViewController: AnyObject {
    func displayAssets(viewModel: SavedModel.LoadAssets.ViewModel)
}

final class SavedViewController: UIViewController {
//MARK: - properties
    private let customView = SavedView()
    private var interactor: ISavedInteractor?
    private var router: ISavedRouter?
    
//MARK: - init
    init(interactor: ISavedInteractor, router: ISavedRouter) {
        super.init(nibName: nil, bundle: nil)
        self.interactor = interactor
        self.router = router
        
        self.customView.didSelectItemAt = { [weak self] indexPath in
            self?.interactor?.selectAsset(request: .init(indexPath: indexPath))
            self?.router?.routeToAssetVC()
        }
        
        self.customView.deleleAssetHandler = { [weak self] tokenID in
            self?.interactor?.deleteAsset(request: .init(tokenID: tokenID))
        }
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

//MARK: - loadView
    override func loadView() {
        self.view = self.customView
    }

//MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        self.fetchAssets(request: .init())
    }
}

//MARK: - ISavedViewController
extension SavedViewController: ISavedViewController {
    func displayAssets(viewModel: SavedModel.LoadAssets.ViewModel) {
        self.customView.displayAssets(viewModel: viewModel)
    }
}

private extension SavedViewController {
    func fetchAssets(request: SavedModel.LoadAssets.Request) {
        self.interactor?.loadAssets(request: request)
    }
}
