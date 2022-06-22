//
//  SavedRouter.swift
//  OpenArt
//
//  Created by Иван Дурмашев on 20.06.2022.
//

import Foundation


protocol ISavedRouter: AnyObject {
    
}

protocol ILikedDataPassing: AnyObject {
    var dataStore: ISavedDataStore? { get }
}

final class SavedRouter: ILikedDataPassing {
    var dataStore: ISavedDataStore?
    
}

extension SavedRouter: ISavedRouter {
    
}
