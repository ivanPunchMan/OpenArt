//
//  HomeViewController.swift
//  OpenArt
//
//  Created by Иван Дурмашев on 02.06.2022.
//

import UIKit

protocol IHomeViewController: AnyObject {
    func displayAssets(viewModel: HomeModel.FetchAssets.ViewModel)
    func displayCollectionImage(viewModel: HomeModel.FetchCollectionImage.ViewModel)
    func displayAssetImage(viewModel: HomeModel.FetchAssetImage.ViewModel)
}

final class HomeViewController: UIViewController {
//MARK: - properties
    private var router: (IHomeRouter & IHomeDataPassing)?
    private var interactor: IHomeInteractor?
    private var customView = HomeView()
    
//MARK: - init
    init(_ interactor: IHomeInteractor,_ router: (IHomeRouter & IHomeDataPassing)) {
        super.init(nibName: nil, bundle: nil)
        self.interactor = interactor
        self.router = router
        
        self.configureNavBar()
        
        self.customView.fetchDataHandler = { request in
            interactor.fetchAssets(request)
        }
        
        self.customView.didSelectItem = { asset in
            let request = HomeModel.SelectAsset.Request(asset: asset)
            interactor.selectAsset(request)
            router.routeToAsset()
        }
        
        self.customView.fetchImagesForCellHandler = { request in
            interactor.fetchImagesForCell(request)
        }
        
        self.customView.saveAssetButtonTappedHandler = { request in
            interactor.saveAsset(request)
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
        self.customView.fetchDataHandler?(.init(nextPage: nil))
    }
}

//MARK: - IHomeViewController
extension HomeViewController: IHomeViewController {
    func displayAssets(viewModel: HomeModel.FetchAssets.ViewModel) {
        self.customView.nextPage = viewModel.nextPage ?? ""
        self.customView.assetsViewModel += viewModel.assets
        self.customView.collectionView.reloadData()
    }
    
    func displayAssetImage(viewModel: HomeModel.FetchAssetImage.ViewModel) {
        if let cell = self.customView.collectionView.cellForItem(at: viewModel.indexPath) as? HomeCollectionViewCell {
            cell.set(assetImage: viewModel.assetImage)
        }
    }
    
    func displayCollectionImage(viewModel: HomeModel.FetchCollectionImage.ViewModel) {
        if let cell = self.customView.collectionView.cellForItem(at: viewModel.indexPath) as? HomeCollectionViewCell {
            cell.set(collectionImage: viewModel.collectionImage)
        }
    }
}

//MARK: - private methods
private extension HomeViewController {
    func configureNavBar() {
        let savedImage = UIImage(systemName: "photo.on.rectangle.angled")
        let savedBarButton = UIBarButtonItem(image: savedImage, style: .done, target: self, action: #selector(onSavedBarButtonTapped))
        savedBarButton.tintColor = Color.black.tone
        self.navigationItem.rightBarButtonItem = savedBarButton
    }
    
    @objc func onSavedBarButtonTapped() {
        self.router?.routeToSaved()
    }
}




