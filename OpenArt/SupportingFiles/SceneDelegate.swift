//
//  SceneDelegate.swift
//  OpenArt
//
//  Created by Иван Дурмашев on 02.06.2022.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        self.window = UIWindow(windowScene: windowScene)
        let navigationVC = UINavigationController(rootViewController: HomeAssembly.build())
        let likedVC = LikedAssembly.build()
        self.window?.rootViewController = likedVC
        self.window?.makeKeyAndVisible()
    }
}

