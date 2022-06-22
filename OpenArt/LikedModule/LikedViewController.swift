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
    func displayAsset(viewModel: LikedModel.DisplayAsset.ViewModel)
    func displayCountOfAssets(viewModel: LikedModel.CountAssets.ViewModel)
    func displayAsset(viewModel: LikedModel.LoadAsset.ViewModel)
    func displayDeleteAsset(viewModel: LikedModel.DeleteAsset.ViewModel)
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
        
        self.customView.fetchAssetForCell = { [weak self] request in
            self?.fetchAssetFoCell(request: request)
        }
        
        
        self.customView.fetchAssetForCellHandler = { [weak self] indexPath in
            self?.interactor?.loadAsset(for: .init(indexPath: indexPath))
        }
        
        self.customView.deleteAssetHandler = { [weak self] indexPath in
            self?.interactor?.deleteAsset(for: .init(indexPath: indexPath))
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
    
    func fetchAssets(request: LikedModel.LoadAssets.Request) {
        self.interactor?.loadAssets(request: request)
    }
    
    func displayAssets(viewModel: LikedModel.LoadAssets.ViewModel) {
        self.customView.displayAssets(viewModel: viewModel)
    }
    
    func fetchAssetFoCell(request: LikedModel.DisplayAsset.Request) {
        self.interactor?.loadAsset(for: request)
    }
    
    func displayCountOfAssets(viewModel: LikedModel.CountAssets.ViewModel) {
        self.customView.set(countOfAssets: viewModel.count)
    }
    
    func displayAsset(viewModel: LikedModel.DisplayAsset.ViewModel) {
        if let cell = viewModel.cell as? LikedAssetCell {
            cell.set(assetName: viewModel.data.assetName)
            cell.set(assetImage: viewModel.data.assetImage)
        }
    }
    
    func displayAsset(viewModel: LikedModel.LoadAsset.ViewModel) {
        
        print(viewModel.indexPath)
//        if let cell = customView.cell(at: viewModel.indexPath) {
        print(customView.collectionView.visibleCells.map{ customView.collectionView.indexPath(for: $0) })
        
        customView.displayAssetHandler?(viewModel)
//        if let cell = customView.collectionView.cellForItem(at: viewModel.indexPath) as? LikedAssetCell {
//            cell.set(assetName: viewModel.assetName)
//            cell.set(assetImage: viewModel.assetImage)
//            print(viewModel.assetImage)
//        }
    }
    
    func displayDeleteAsset(viewModel: LikedModel.DeleteAsset.ViewModel) {
        self.customView.deleteItem(at: viewModel.indexPath)
    }
}

private extension LikedViewController {
    func fetchCountOfAssets(request: LikedModel.CountAssets.Request) {
        self.interactor?.countAssets(request: request)
    }
}
