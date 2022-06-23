//
//  SavedView.swift
//  OpenArt
//
//  Created by Иван Дурмашев on 20.06.2022.
//

import Foundation
import UIKit

final class SavedView: UIView {
//MARK: - private enums
    private enum Text {
        static let savedLabelText = "Saved"
    }
    
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
        static let savedViewHorizontalInset: CGFloat = 16
        
        static let savedLabelTopOffset: CGFloat = 27
        
        static let collectionViewTopOffset: CGFloat = 16
    }

//MARK: - properties
    var deleleAssetHandler: ((String) -> Void)?
    var didSelectItemAt: ((IndexPath) -> Void)?
    
    lazy var collectionView = createCollectionView()
    private let savedLabel = UILabel()
    
    private var assetsViewModel: SavedModel.LoadAssets.ViewModel? {
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
    func displayAssets(viewModel: SavedModel.LoadAssets.ViewModel) {
        self.assetsViewModel = viewModel
    }
}

//MARK: - private methods
private extension SavedView {
    func createCollectionView() -> UICollectionView {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.createCollectionViewLayout())
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.dataSource = self
        collectionView.delegate = self
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
        self.setupSavedLabelLayout()
        self.setupCollectionViewLayout()
    }
    
    func setupSavedLabelLayout() {
        self.addSubview(self.savedLabel)
        self.configureSavedLabel()
        NSLayoutConstraint.activate([
            self.savedLabel.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: Constraint.savedLabelTopOffset),
            self.savedLabel.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: Constraint.savedViewHorizontalInset),
            self.savedLabel.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -Constraint.savedViewHorizontalInset)
        ])
    }
    
    func configureSavedLabel() {
        self.savedLabel.translatesAutoresizingMaskIntoConstraints = false
        self.savedLabel.font = Typography.DisplayXS.semiBold.font
        self.savedLabel.text = Text.savedLabelText
        self.savedLabel.backgroundColor = .clear
    }
    
    func setupCollectionViewLayout() {
        self.addSubview(self.collectionView)
        NSLayoutConstraint.activate([
            self.collectionView.topAnchor.constraint(equalTo: self.savedLabel.bottomAnchor, constant: Constraint.collectionViewTopOffset),
            self.collectionView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            self.collectionView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            self.collectionView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor)
        ])
    }
}

//MARK: - UICollectionViewDataSource
extension SavedView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.assetsViewModel?.assets.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SavedCollectionViewCell.id, for: indexPath) as? SavedCollectionViewCell else { return UICollectionViewCell() }
        
        let asset = self.assetsViewModel?.assets[indexPath.row]

        cell.set(assetModel: asset)
        
        cell.onDeleteButtonTappedHandler = { [weak self] in
            if let tokenID = asset?.tokenID {
                self?.deleleAssetHandler?(tokenID)
                self?.assetsViewModel?.assets.remove(at: indexPath.row)
            }
        }
        
        return cell
    }
}

extension SavedView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.didSelectItemAt?(indexPath)
    }
}
