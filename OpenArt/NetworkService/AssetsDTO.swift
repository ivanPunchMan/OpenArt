//
//  AssetsDTO.swift
//  OpenArt
//
//  Created by Иван Дурмашев on 12.06.2022.
//

import Foundation

struct AssetsDTO: Codable {
    let previous: String?
    let next: String?
    let assets: [Asset]
}

struct Asset: Codable {
    let imagePreviewURL: String?
    let imageThumbnailURL: String?
    let animationOriginalURL: String?
    let description: String?
    let imageURL: String?
    let name: String?
    let collection: Collection?
    let creator: Creator?
    let assetContract: Contract?
    let tokenID: String?
    
    enum CodingKeys: String, CodingKey {
        case imagePreviewURL = "image_preview_url"
        case imageThumbnailURL = "image_thumbnail_url"
        case animationOriginalURL = "animation_original_url"
        case description
        case imageURL = "image_url"
        case name
        case collection
        case creator
        case assetContract = "asset_contract"
        case tokenID = "token_id"
    }
}

struct Creator: Codable {
    let user: User?
    let address: String?
}

struct User: Codable {
    let username: String?
}

struct Collection: Codable {
    let largeImageURL: String?
    let imageURL: String?
    let name: String?
    let description: String?
    
    enum CodingKeys: String, CodingKey {
        case largeImageURL = "large_image_url"
        case imageURL = "image_url"
        case name
        case description
    }
}

struct Contract: Codable {
    let address: String?
}
