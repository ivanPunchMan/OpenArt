//
//  LikedViewController.swift
//  OpenArt
//
//  Created by Иван Дурмашев on 20.06.2022.
//

import Foundation
import UIKit

protocol ILikedViewController: AnyObject {
    func displayAssets(viewModel: LikedModel.LoadAssets.ViewModel)
}

final class LikedViewController: UIViewController {
//MARK: - properties
    private let customView = LikedView()
    private var interactor: ILikedInteractor?
    private var router: ILikedRouter?
    
//MARK: - init
    init(interactor: ILikedInteractor, router: ILikedRouter) {
        super.init(nibName: nil, bundle: nil)
        self.interactor = interactor
        self.router = router
        
        self.customView.deleleAssetHandler2 = { [weak self] uniqueID in
            self?.interactor?.deleteAsset(for: .init(uniqueID: uniqueID))
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

//MARK: - ILikedViewController
extension LikedViewController: ILikedViewController {
    func displayAssets(viewModel: LikedModel.LoadAssets.ViewModel) {
        self.customView.displayAssets(viewModel: viewModel)
    }
}

private extension LikedViewController {
    func fetchAssets(request: LikedModel.LoadAssets.Request) {
        self.interactor?.loadAssets(request: request)
    }
}
