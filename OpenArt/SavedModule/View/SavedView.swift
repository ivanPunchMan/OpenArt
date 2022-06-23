//
//  SavedView.swift
//  OpenArt
//
//  Created by Иван Дурмашев on 20.06.2022.
//

import Foundation
import UIKit

final class SavedView: UIView, UICollectionViewDelegate {
//MARK: - private enums
    private enum Constant {
        static let itemAndGroupFractionalWidth: CGFloat = 1
        static let itemAndGroupEstimatedHeightDimension: CGFloat = 563
        
        static let itemTopEdgeSpacing: CGFloat = 32
        static let itemHorizontalEdgeInsets: CGFloat = 16
        
        static let itemFractionalWidthAndHeight: CGFloat = 1
        static let groupFractionalWidth: CGFloat = 1
        static let groupFractionalHeight: CGFloat = 0.3
        static let countItemInGroup = 2
        static let interItemSpacing: CGFloat = 16
        static let contentInsets: CGFloat = 16
    }

//MARK: - properties
    let collectionViewDataSource = SavedCollectionViewDataSource()
    let collectionViewDelegate = SavedCollectionViewDelegate()
    lazy var collectionView = createCollectionView()
    
//MARK: - init
    init() {
        super.init(frame: .zero)
        self.backgroundColor = .white
        self.setupLayout()
        
        self.collectionViewDataSource.reloadDataHandler = { [weak self] in
            self?.collectionView.reloadData()
        }
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//MARK: - internal methods    
    func displayAssets(viewModel: SavedModel.LoadAssets.ViewModel) {
        self.collectionViewDataSource.assetsViewModel = viewModel.assets
    }
}

//MARK: - private methods
private extension SavedView {
    func createCollectionView() -> UICollectionView {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.createCollectionViewLayout())
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.dataSource = self.collectionViewDataSource
        collectionView.delegate = self.collectionViewDelegate
        collectionView.register(SavedCollectionViewCell.self, forCellWithReuseIdentifier: SavedCollectionViewCell.id)
        
        return collectionView
    }
    
    func createCollectionViewLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(Constant.itemFractionalWidthAndHeight),
                                              heightDimension: .fractionalHeight(Constant.itemFractionalWidthAndHeight))
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(Constant.groupFractionalWidth),
                                               heightDimension: .fractionalHeight(Constant.groupFractionalHeight))
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: Constant.countItemInGroup)
        
        group.interItemSpacing = .fixed(Constant.interItemSpacing)
        
        group.contentInsets = NSDirectionalEdgeInsets(top: 0,
                                                      leading: Constant.contentInsets,
                                                      bottom: Constant.contentInsets,
                                                      trailing: Constant.contentInsets)
        
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
