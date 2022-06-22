//
//  SavedPresenter.swift
//  OpenArt
//
//  Created by Иван Дурмашев on 20.06.2022.
//

import Foundation

protocol ISavedPresenter: AnyObject {
    func presentAssets(response: SavedModel.LoadAssets.Response)
}

final class SavedPresenter {
    weak var vc: ISavedViewController?
}

//MARK: - ILikedPresenter
extension SavedPresenter: ISavedPresenter {
    func presentAssets(response: SavedModel.LoadAssets.Response) {
        self.vc?.displayAssets(viewModel: .init(from: response))
    }
}
