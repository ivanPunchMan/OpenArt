//
//  LikedView.swift
//  OpenArt
//
//  Created by Иван Дурмашев on 20.06.2022.
//

import Foundation
import UIKit

final class LikedView: UIView {
//MARK: - private enums
    private enum Constant {
        static let itemAndGroupFractionalWidth: CGFloat = 1
        static let itemAndGroupEstimatedHeightDimension: CGFloat = 563
        
        static let itemTopEdgeSpacing: CGFloat = 32
        static let itemHorizontalEdgeInsets: CGFloat = 16
        
        static let itemFractionalWidthAndHeight: CGFloat = 1
        static let groupFractionalWidth: CGFloat = 1
        static let groupFractionalHeight: CGFloat = 0.33
        static let countItemInGroup = 2
        static let interItemSpacing: CGFloat = 16
        static let contentInsets: CGFloat = 16
    }
    
    private enum Constraint {
        static let likedViewHorizontalInset: CGFloat = 16
        
        static let likedLabelTopOffset: CGFloat = 27
        
        static let collectionViewTopOffset: CGFloat = 16
    }

//MARK: - properties
    var deleleAssetHandler2: ((String) -> Void)?
    
    lazy var collectionView = createCollectionView()
    private let likedLabel = UILabel()
    
    private var assetsViewModel: LikedModel.LoadAssets.ViewModel? {
        didSet {
            self.collectionView.reloadData()
        }
    }
    
//MARK: - init
    init() {
        super.init(frame: .zero)
        self.backgroundColor = .white
        self.setupLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//MARK: - internal methods    
    func displayAssets(viewModel: LikedModel.LoadAssets.ViewModel) {
        self.assetsViewModel = viewModel
    }
}

//MARK: - private methods
private extension LikedView {
    func createCollectionView() -> UICollectionView {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.createCollectionViewLayout())
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(LikedAssetCell.self, forCellWithReuseIdentifier: LikedAssetCell.id)
        
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
        self.setupLikedLabelLayout()
        self.setupCollectionViewLayout()
    }
    
    func setupLikedLabelLayout() {
        self.addSubview(self.likedLabel)
        self.configureLikedLabel()
        NSLayoutConstraint.activate([
            self.likedLabel.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: Constraint.likedLabelTopOffset),
            self.likedLabel.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: Constraint.likedViewHorizontalInset),
            self.likedLabel.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -Constraint.likedViewHorizontalInset)
        ])
    }
    
    func configureLikedLabel() {
        self.likedLabel.translatesAutoresizingMaskIntoConstraints = false
        self.likedLabel.font = Typography.DisplayXS.semiBold.font
        self.likedLabel.text = "Liked"
        self.likedLabel.backgroundColor = .clear
    }
    
    func setupCollectionViewLayout() {
        self.addSubview(self.collectionView)
        NSLayoutConstraint.activate([
            self.collectionView.topAnchor.constraint(equalTo: self.likedLabel.bottomAnchor, constant: Constraint.collectionViewTopOffset),
            self.collectionView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            self.collectionView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            self.collectionView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor)
        ])
    }
}

//MARK: - UICollectionViewDataSource
extension LikedView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.assetsViewModel?.assets.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LikedAssetCell.id, for: indexPath) as? LikedAssetCell else { return UICollectionViewCell() }
        
        let asset = self.assetsViewModel?.assets[indexPath.row]

        cell.set(assetModel: asset)
        
        cell.onDeleteButtonTappedHandler = { [weak self] in
            if let tokenID = asset?.tokenID {
                self?.deleleAssetHandler2?(tokenID)
                self?.assetsViewModel?.assets.remove(at: indexPath.row)
            }
        }
        
        return cell
    }
}

extension LikedView: UICollectionViewDelegate {
    
}
