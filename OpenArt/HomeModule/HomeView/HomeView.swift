//
//  HomeView.swift
//  OpenArt
//
//  Created by Иван Дурмашев on 13.06.2022.
//

import Foundation
import UIKit

final class HomeView: UIView {
    
    private enum Constant {
        static let itemAndGroupFractionalWidth: CGFloat = 1
        static let itemAndGroupEstimatedHeightDimension: CGFloat = 563
        
        static let itemTopEdgeSpacing: CGFloat = 32
        static let itemHorizontalEdgeInsets: CGFloat = 16
    }
    
    var viewModel: HomeModel.FetchAssets.ViewModel?
    var fetchDataHandler: ((HomeModel.FetchAssets.Request) -> Void)?
    var fetchImagesForCellHandler: ((HomeModel.FetchAssetImage.Request) -> Void)?
    var didSelectItemAt: ((IndexPath) -> Void)?
    var savedButtonTappedHandler: (() -> Void)?
    var saveButtonTappedHandler: ((HomeModel.SaveAsset.Request) -> Void)?
    lazy var collectionView = createCollectionView()
    
    private let cachedDataSource: NSCache<AnyObject, UIImage> = {
        let cache = NSCache<AnyObject, UIImage>()
        cache.totalCostLimit = 30 * 1024 * 1024
        
        return cache
    }()
        
    private var urls = [String]()
    
    init() {
        super.init(frame: .zero)
        self.backgroundColor = .white
        self.setupCollectionViewLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func display(comletion: @escaping (UIImage) -> Void) {
    }
}

private extension HomeView {
    
    func createCollectionView() -> UICollectionView {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createCollectionViewLayout())
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(AssetCollectionViewCell.self, forCellWithReuseIdentifier: AssetCollectionViewCell.id)
        
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

extension HomeView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.didSelectItemAt?(indexPath)
    }
}

extension HomeView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let count = self.viewModel?.assets.count else { return 0 }
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AssetCollectionViewCell.id, for: indexPath) as? AssetCollectionViewCell,
            let asset = self.viewModel?.assets[indexPath.row]
        else { return UICollectionViewCell() }
    
        cell.set(collectionName: asset.collectionName)
        
        cell.saveButtonTappedHandler = { [weak self] assetImage, collectionImage in
            self?.saveButtonTappedHandler?(.init(tokenID: asset.tokenID,
                                                 assetName: asset.creatorUsername,
                                                 assetImage: assetImage,
                                                 assetDescription: asset.assetDescription,
                                                 collectionName: asset.collectionName,
                                                 collectionImage: collectionImage))
        }
        
        self.fetchImagesForCellHandler?(.init(indexPath: indexPath))
        
        return cell
    }
}
