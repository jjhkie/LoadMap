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
        
        let homeView = GoalView()
        let noteView = NoteView()
        let calendarView = CalendarLineView()
        
        tabBar.viewControllers = [homeView,noteView,calendarView]
        

        
        noteView.tabBarItem = UITabBarItem(title: "메모", image: UIImage(systemName: "house"), selectedImage: UIImage(systemName: "house.fill"))
        
        homeView.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), selectedImage: UIImage(systemName: "house.fill"))
        calendarView.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), selectedImage: UIImage(systemName: "house.fill"))
        
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

