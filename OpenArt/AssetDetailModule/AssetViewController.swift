//
//  AssetViewController.swift
//  OpenArt
//
//  Created by Иван Дурмашев on 15.06.2022.
//

import Foundation
import UIKit

protocol IAssetViewController: AnyObject {
    func displayAssetInfo(viewModel: AssetModel.FetchAssetInfo.ViewModel)
    func displayAssetImage(viewModel: AssetModel.FetchAssetImage.ViewModel)
    func displayCollectionImage(viewModel: AssetModel.FetchCollectionImage.ViewModel)
}

final class AssetViewController: UIViewController {
//MARK: - properties
    var router: (IAssetRouter & IAssetDataPassing)?
    private let customView = AssetDetailView()
    private var interactor: IAssetInteractor?

//MARK: - init
    init(interactor: IAssetInteractor, router: (IAssetRouter & IAssetDataPassing)) {
        super.init(nibName: nil, bundle: nil)
        self.interactor = interactor
        self.router = router
        
        self.customView.onLikedButtonTappedHandler = { request in
            interactor.save(data: request)
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
        self.fetchAssetData()
    }
    
    func fetchAssetData() {
        self.fetchAssetInfo(request: .init())
        self.fetchAssetImageHandler(request: .init())
        self.fetchCollectionImageHandler(request: .init())
    }
    
    func fetchAssetInfo(request: AssetModel.FetchAssetInfo.Request) {
        self.interactor?.fetchAssetInfo(request: request)
    }

    func fetchAssetImageHandler(request: AssetModel.FetchAssetImage.Request) {
        self.interactor?.fetchAssetImage(request: request)
    }
    
    func fetchCollectionImageHandler(request: AssetModel.FetchCollectionImage.Request) {
        self.interactor?.fetchCollectionImage(request: request)
    }
}

//MARK: - IAssetViewController
extension AssetViewController: IAssetViewController {
    func displayAssetInfo(viewModel: AssetModel.FetchAssetInfo.ViewModel) {
        self.customView.set(collectionName: viewModel.collectionName)
        self.customView.set(title: viewModel.assetName)
        self.customView.set(description: viewModel.assetDescription)
    }
    
    func displayAssetImage(viewModel: AssetModel.FetchAssetImage.ViewModel) {
        self.customView.set(assetImage: viewModel.assetImage)
    }
    
    func displayCollectionImage(viewModel: AssetModel.FetchCollectionImage.ViewModel) {
        self.customView.set(collectionImage: viewModel.collectionImage)
    }
}
