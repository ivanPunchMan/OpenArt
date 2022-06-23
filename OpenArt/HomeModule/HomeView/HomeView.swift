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
        
        static let itemTopEdgeSpacing: CGFloat = 15
        static let itemHorizontalEdgeInsets: CGFloat = 16
    }

//MARK: - internal properties
    lazy var collectionView = createCollectionView()
    var collectionViewDataSource = HomeCollectionViewDataSource()
    var collectionViewDelegate = HomeCollectionViewDelegate()
        
//MARK: - init
    init() {
        super.init(frame: .zero)
        self.backgroundColor = .white
        self.setupLayout()
        
        self.collectionViewDelegate.assetAt = { [weak self] indexPath in
            self?.collectionViewDataSource.assetsViewModel[indexPath.row]
        }
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

//MARK: - internal methods
    func displayAssets(_ viewModel: HomeModel.FetchAssets.ViewModel) {
        self.collectionViewDataSource.nextPage = viewModel.nextPage ?? ""
        self.collectionViewDataSource.assetsViewModel += viewModel.assets
        self.collectionView.reloadData()
    }
    
    func displayAssetImage(_ viewModel: HomeModel.FetchAssetImage.ViewModel) {
        if let cell = self.collectionView.cellForItem(at: viewModel.indexPath) as? HomeCollectionViewCell {
            cell.set(assetImage: viewModel.assetImage)
            self.collectionView.reconfigureItems(at: [viewModel.indexPath])
        }
    }
    
    func displayCollectionImage(_ viewModel: HomeModel.FetchCollectionImage.ViewModel) {
        if let cell = self.collectionView.cellForItem(at: viewModel.indexPath) as? HomeCollectionViewCell {
            cell.set(collectionImage: viewModel.collectionImage)
            self.collectionView.reconfigureItems(at: [viewModel.indexPath])
        }
    }
}

//MARK: - private methods
private extension HomeView {
    func createCollectionView() -> UICollectionView {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createCollectionViewLayout())
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.dataSource = self.collectionViewDataSource
        collectionView.prefetchDataSource = self.collectionViewDataSource
        collectionView.delegate = self.collectionViewDelegate
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
    
    func setupLayout() {
        self.setupCollectionViewLayout()
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
