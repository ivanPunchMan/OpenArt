//
//  AssetViewController.swift
//  OpenArt
//
//  Created by Иван Дурмашев on 15.06.2022.
//

import Foundation
import UIKit

protocol IAssetViewController: AnyObject {
    func displayAssetData(viewModel: AssetModel.FetchAssetData.ViewModel)
}

final class AssetViewController: UIViewController {
//MARK: - privat enum
    private enum Text {
        static let navigationItemTitle = "Details"
    }
    
//MARK: - properties
    var router: (IAssetRouter & IAssetDataPassing)?
    
    private let customView = AssetDetailView()
    private var interactor: IAssetInteractor?

//MARK: - init
    init(_ interactor: IAssetInteractor,_  router: (IAssetRouter & IAssetDataPassing)) {
        super.init(nibName: nil, bundle: nil)
        self.interactor = interactor
        self.router = router
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
        self.fetchAssetData()
        
        self.navigationItem.title = Text.navigationItemTitle
    }

//MARK: - internal method
    func fetchAssetData() {
        self.interactor?.fetchAssetData(request: .init())
    }
}

//MARK: - IAssetViewController
extension AssetViewController: IAssetViewController {
    func displayAssetData(viewModel: AssetModel.FetchAssetData.ViewModel) {
        self.customView.set(assetInfo: viewModel)
    }
}
