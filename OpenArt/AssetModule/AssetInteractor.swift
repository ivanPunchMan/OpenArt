//
//  AssetInteractor.swift
//  OpenArt
//
//  Created by Иван Дурмашев on 15.06.2022.
//

import Foundation

protocol IAssetInteractor: AnyObject {
    func fetchAssetData(request: AssetModel.FetchAssetData.Request)
}

protocol IAssetDataStore: AnyObject {
    var assetDataStore: AssetDataStoreModel? { get set }
}

//MARK: - IAssetDataStore
final class AssetInteractor: IAssetDataStore {
//MARK: - properties
    var assetDataStore: AssetDataStoreModel?
    
    private var presenter: IAssetPresenter
    
//MARK: - init
    init(_ presenter: IAssetPresenter) {
        self.presenter = presenter
    }
}

//MARK: - IAssetInteractor
extension AssetInteractor: IAssetInteractor {
    func fetchAssetData(request: AssetModel.FetchAssetData.Request) {
        self.presenter.presentAssetData(response: .init(assetImageData: self.assetDataStore?.assetImageData,
                                                        collectionImageData: self.assetDataStore?.collectionImageData,
                                                        assetName: self.assetDataStore?.assetName,
                                                        assetDescription: self.assetDataStore?.assetDescription,
                                                        collectionName: self.assetDataStore?.collectionName))
    }
}
