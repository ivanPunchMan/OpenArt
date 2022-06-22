//
//  LikedRouter.swift
//  OpenArt
//
//  Created by Иван Дурмашев on 20.06.2022.
//

import Foundation


protocol ILikedRouter: AnyObject {
    
}

protocol ILikedDataPassing: AnyObject {
    var dataStore: ILikedDataStore? { get }
}

final class LikedRouter: ILikedDataPassing {
    var dataStore: ILikedDataStore?
    
}

extension LikedRouter: ILikedRouter {
    
}
