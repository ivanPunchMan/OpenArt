//
//  NetworkService.swift
//  OpenArt
//
//  Created by Иван Дурмашев on 12.06.2022.
//

import Foundation
import UIKit

protocol INetworkService {
    func loadAssets(nextPage: String?, completion: @escaping (Result<AssetsDTO, Error>) -> Void)
    func downloadImage(from urlString: String?, completion: @escaping (Result<Data, Error>) -> Void)
}

final class NetworkService {
    
    static let shared = NetworkService()
    
    private init() {}
    
    private enum EndPoint {
        static let assetsURL = "https://opensea13.p.rapidapi.com/assets?"
    }
    
    private enum QueryItem {
        static let orderDirection = URLQueryItem(name: "order_direction", value: "desc")
        static let limit = URLQueryItem(name: "limit", value: "50")
        static let include = URLQueryItem(name: "include_orders", value: "false")
    }
    
    private let session = URLSession.shared
    private let jsonDecoder = JSONDecoder()
    private let cachedDataSource: NSCache<NSString, NSData> = {
        let cache = NSCache<NSString, NSData>()
        cache.totalCostLimit = 30 * 1024 * 1024
        
        return cache
    }()
}

extension NetworkService: INetworkService {

    func loadAssets(nextPage: String?, completion: @escaping (Result<AssetsDTO, Error>) -> Void) {
        let url = self.url(param: nextPage)

        var request = URLRequest(url: url)
        let headers = ["X-RapidAPI-Key": "0c963ec949msh5c8f66cec582c34p1bfc69jsn5d668d6ecc2a",
                       "X-RapidAPI-Host": "opensea13.p.rapidapi.com"]
        request.allHTTPHeaderFields = headers

        self.session.dataTask(with: request) { [weak self] data, response, error in
            guard let self = self else { assert(false, "Некорректный URL") }

            if let error = error {
                completion(.failure(error))
            }

            if let data = data {
                do {
                    let assets = try self.jsonDecoder.decode(AssetsDTO.self, from: data)
                    completion(.success(assets))
                } catch {
                    completion(.failure(error))
                }
            }
        }.resume()
    }

    enum NetError: Error {
        case uncorrectURL
    }
    
    func downloadImage(from urlString: String?, completion: @escaping (Result<Data, Error>) -> Void) {
        
        let urlStrong = urlString ?? ""
        guard let url = URL(string: urlStrong) else { completion(.failure(NetError.uncorrectURL))
            return
        }
        let request = URLRequest(url: url, timeoutInterval: 30)
        
        if let data = self.cachedDataSource.object(forKey: urlStrong as NSString) {
            completion(.success(data as Data))
        } else {
            self.session.downloadTask(with: request) { [weak self] url, request, error in
                if let error = error {
                    completion(.failure(error))
                }
                
                if let url = url {
                    if let dataImage = try? Data(contentsOf: url) {
                        self?.cachedDataSource.setObject(dataImage as NSData, forKey: urlStrong as NSString)
                        completion(.success(dataImage))
                    }
                }
            }.resume()
        }
    }
}

private extension NetworkService {
    func url(param cursor: String?) -> URL {
        let queryItems = [
            QueryItem.orderDirection,
            QueryItem.limit,
            QueryItem.include,
            URLQueryItem(name: "cursor", value: cursor),
//            URLQueryItem(name: "collection_slug", value: "cryptoverse-vip")
        ]
        var urlComponents = URLComponents(string: EndPoint.assetsURL)
        urlComponents?.queryItems = queryItems
        guard let url = urlComponents?.url else { assert(false, "Некорректный URL") }
        
        return url
    }
}
