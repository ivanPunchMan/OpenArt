//
//  HomeView.swift
//  OpenArt
//
//  Created by Иван Дурмашев on 13.06.2022.
//

import Foundation
import UIKit

final class HomeView: UIView {
//MARK: - private enums
    private enum Constant {
        static let itemAndGroupFractionalWidth: CGFloat = 1
        static let itemAndGroupEstimatedHeightDimension: CGFloat = 563
        
        static let itemTopEdgeSpacing: CGFloat = 32
        static let itemHorizontalEdgeInsets: CGFloat = 16
    }

//MARK: - properties
    var nextPage = ""
    var assetsViewModel = [HomeModel.FetchAssets.AssetViewModel]()
    var fetchDataHandler: ((HomeModel.FetchAssets.Request) -> Void)?
    var fetchImagesForCellHandler: ((HomeModel.FetchAssetImage.Request) -> Void)?
    var didSelectItem: ((AssetDataStoreModel) -> Void)?
    var saveAssetButtonTappedHandler: ((HomeModel.SaveAsset.Request) -> Void)?
    lazy var collectionView = createCollectionView()
    
    private let cachedDataSource: NSCache<AnyObject, UIImage> = {
        let cache = NSCache<AnyObject, UIImage>()
        cache.totalCostLimit = 30 * 1024 * 1024
        
        return cache
    }()
        
//MARK: - init
    init() {
        super.init(frame: .zero)
        self.backgroundColor = .white
        self.setupCollectionViewLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - private methods
private extension HomeView {
    func createCollectionView() -> UICollectionView {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createCollectionViewLayout())
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.prefetchDataSource = self
        collectionView.register(HomeCollectionViewCell.self, forCellWithReuseIdentifier: HomeCollectionViewCell.id)
        
        return collectionView
    }
    
    func createCollectionViewLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(Constant.itemAndGroupFractionalWidth),
                                              heightDimension: .estimated(Constant.itemAndGroupEstimatedHeightDimension))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 0,
                                                     leading: Constant.itemHorizontalEdgeInsets,
                                                     bottom: 0,
                                                     trailing: Constant.itemHorizontalEdgeInsets)
        item.edgeSpacing = NSCollectionLayoutEdgeSpacing(leading: .none,
                                                         top: .fixed(Constant.itemTopEdgeSpacing),
                                                         trailing: .none,
                                                         bottom: .none)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(Constant.itemAndGroupFractionalWidth),
                                               heightDimension: .estimated(Constant.itemAndGroupEstimatedHeightDimension))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
    }
    
    func calculateIndexPathsToReload(from newViewModel: HomeModel.FetchAssets.ViewModel) -> [IndexPath] {
        let assetsCount = self.assetsViewModel.count
        let newPageAssetsCount = newViewModel.assets.count
        
        let startIndex = assetsCount - newPageAssetsCount
        let endIndex = assetsCount + newPageAssetsCount
        return (startIndex..<endIndex).map { IndexPath(row: $0, section: 0) }
    }
     
    func setupCollectionViewLayout() {
        self.addSubview(self.collectionView)
        
        NSLayoutConstraint.activate([
            self.collectionView.topAnchor.constraint(equalTo: self.topAnchor),
            self.collectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.collectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.collectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
    }
}

//MARK: - UICollectionViewDelegate
extension HomeView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as? HomeCollectionViewCell
        let asset = self.assetsViewModel[indexPath.row]
        
        self.didSelectItem?(.init(tokenID: asset.tokenID,
                                  assetName: asset.assetName,
                                  assetImageData: cell?.assetImage?.pngData(),
                                  assetDescription: asset.assetDescription,
                                  collectionName: asset.collectionName,
                                  collectionImageData: cell?.collectionImage?.pngData()))
    }
}

//MARK: - UICollectionViewDataSource
extension HomeView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.assetsViewModel.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeCollectionViewCell.id, for: indexPath) as? HomeCollectionViewCell,
                self.assetsViewModel.indices.contains(indexPath.row)
        else { return UICollectionViewCell() }
        
        let asset = self.assetsViewModel[indexPath.row]
        
        self.fetchImagesForCellHandler?(.init(indexPath: indexPath))
        
        cell.set(collectionName: asset.collectionName)
        
        cell.saveButtonTappedHandler = { [weak self] in
            self?.saveAssetButtonTappedHandler?(.init(tokenID: asset.tokenID,
                                                      assetName: asset.assetName,
                                                      assetImage: cell.assetImage,
                                                      assetDescription: asset.assetDescription,
                                                      collectionName: asset.collectionName,
                                                      collectionImage: cell.collectionImage))
        }
        
        return cell
    }
}

extension HomeView: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        let indexPath = indexPaths.first
        
        if (self.assetsViewModel.count - 5) == indexPath?.row {
            self.fetchDataHandler?(.init(nextPage: self.nextPage))
        }
    }
}
