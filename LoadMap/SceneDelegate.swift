//
//  SceneDelegate.swift
//  LoadMap
//
//  Created by 김진혁 on 2023/04/17.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        self.window = UIWindow(windowScene: windowScene)
        
        let tabBar = UITabBarController()
        
        let homeView = HomeView()
        let noteView = NoteView()
        
        tabBar.viewControllers = [noteView,homeView]
        
        noteView.tabBarItem = UITabBarItem(title: "Note", image: UIImage(systemName: "house"), selectedImage: UIImage(systemName: "house.fill"))
        
        homeView.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), selectedImage: UIImage(systemName: "house.fill"))
        let rootView = UINavigationController(rootViewController: tabBar)
        
        window?.rootViewController = rootView
        window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {}

    func sceneDidBecomeActive(_ scene: UIScene) {}

    func sceneWillResignActive(_ scene: UIScene) {}

    func sceneWillEnterForeground(_ scene: UIScene) {}

    func sceneDidEnterBackground(_ scene: UIScene) {}


}

