//
//  LikedPresenter.swift
//  OpenArt
//
//  Created by Иван Дурмашев on 20.06.2022.
//

import Foundation

protocol ILikedPresenter: AnyObject {
    func presentAssets(response: LikedModel.LoadAssets.Response)
    func presentAsset(response: LikedModel.DisplayAsset.Response)
    func presentCountOfAssets(response: LikedModel.CountAssets.Response)
    func presentAsset(response: LikedModel.LoadAsset.Response)
    func deleteAsset(response: LikedModel.DeleteAsset.Response)
}

final class LikedPresenter {
    weak var vc: ILikedViewController?
    
}

extension LikedPresenter: ILikedPresenter {
    
    func presentAssets(response: LikedModel.LoadAssets.Response) {
        self.vc?.displayAssets(viewModel: .init(from: response))
    }
    
    func presentAsset(response: LikedModel.DisplayAsset.Response) {
        self.vc?.displayAsset(viewModel: .init(indexPath: response.indexPath, data: response.data, cell: response.cell))
    }
    
    func presentCountOfAssets(response: LikedModel.CountAssets.Response) {
        self.vc?.displayCountOfAssets(viewModel: .init(count: response.count))
    }
    
    func presentAsset(response: LikedModel.LoadAsset.Response) {
        self.vc?.displayAsset(viewModel: .init(from: response))
    }
    
    func deleteAsset(response: LikedModel.DeleteAsset.Response) {
        self.vc?.displayDeleteAsset(viewModel: .init(indexPath: response.indexPath))
    }
}
