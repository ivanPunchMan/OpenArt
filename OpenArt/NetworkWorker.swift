//
//  NetworkWorker.swift
//  OpenArt
//
//  Created by Иван Дурмашев on 13.06.2022.
//

import Foundation

protocol IAssetsNetworkWorker: AnyObject {
    func fetchAssets(nextPage: String?, completion: @escaping (Result<AssetsDTO, Error>) -> Void)
}

protocol IImageNetworkWorker: AnyObject {
    func fetchImage(from url: String?, completion: @escaping (Result<Data, Error>) -> Void)
}

final class NetworkWorker {
    var networkService = NetworkService.shared
}

//MARK: - IAssetsNetworkWorker
extension NetworkWorker: IAssetsNetworkWorker {
    func fetchAssets(nextPage: String?, completion: @escaping (Result<AssetsDTO, Error>) -> Void) {
        networkService.loadAssets(nextPage: nextPage) { result in
            switch result {
            case.success(let assetsDTO):
                DispatchQueue.main.async {
                    completion(.success(assetsDTO))
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
}

//MARK: - IImageNetworkWorker
extension NetworkWorker: IImageNetworkWorker {
    func fetchImage(from url: String?, completion: @escaping (Result<Data, Error>) -> Void) {
        networkService.downloadImage(from: url) { result in
            switch result {
            case .success(let imageData):
                DispatchQueue.main.async {
                    completion(.success(imageData))
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
}
