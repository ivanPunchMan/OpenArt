//
//  LikedPresenter.swift
//  OpenArt
//
//  Created by Иван Дурмашев on 20.06.2022.
//

import Foundation

protocol ILikedPresenter: AnyObject {
    func presentAssets(response: LikedModel.LoadAssets.Response)
}

final class LikedPresenter {
    weak var vc: ILikedViewController?
}

extension LikedPresenter: ILikedPresenter {
    func presentAssets(response: LikedModel.LoadAssets.Response) {
        self.vc?.displayAssets(viewModel: .init(from: response))
    }
}
